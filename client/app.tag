import {UImixin, LinkMixin} from 'lince/client/uiActor.js'
import {i18nMixin} from 'lince/client/i18n.js'
import {observable, autorun, asMap} from 'mobx'
import {FormMixin} from 'lince/client/form.js'
import {dispatcher} from 'lince/client/dispatcherActor.js'
import {ws} from 'lince/client/webSocketActor.js'
import _ from 'lodash'

<notifications>
    <div class="notification-bar">
        <div each={ notif in notifications }>
            <span class="{notif.type} {notif.animation}">{notif.msg}</span>
        </div>
    </div>
    <style scoped>
        .notification-bar{
            position: absolute;
        }
        .log{
            background-color: black;
            color: white
        }
        .success{
            background-color: darkseagreen;
            color: white
        }
        .error{
            background-color: indianred;
            color: white
        }
    </style>
    <script>
    ticket = 0
    this.notifications = []

    log(type, msg){
        let t = ticket++
        this.notifications.push({ticket: t, type, msg, animation: 'animated fadeIn'})
        setTimeout(()=>{
            let i = _.findIndex(this.notifications, (x)=> x.ticket == t)
            let aux = this.notifications[i]
            aux.animation = 'animated fadeOut'
            this.notifications.splice(i,1,aux)
        }, 4000)
        setTimeout(()=>this.notifications.splice(0, 1)
        , 5000)
    }

    success(msg){
        this.log('success', msg)
    }

    error(msg){
        this.log('error', msg)
    }

    dispatcher.rv.observe((ch)=>{
        let value = ch.newValue
        this.log('log', value)
    })

    ws.connected.observe((ch)=>{
        let value = ch.newValue
        if(value){
            this.success('connected')
        }else{
            this.error('disconnected')
        }
    })

    </script>

</notifications>

<string-input>
    <input onchange={onChange} value={value} />
    <script>
        this.mixin(LinkMixin(this))
        this.value = ''
        if(this.opts.link){
            this.link(this.opts.link, 'value')
        }else{
            this.linkMap(this.opts.maplink, this.opts.name, 'value')
        }

        onChange(evt){
            if(this.opts.link){
                this.opts.link.set(evt.target.value)
            }else{
                this.opts.maplink.set(this.opts.name, evt.target.value)
            }
        }
    </script>
</string-input>

<my-static-todo-item-form>
    <div>
        <string-input mapLink={doc} name='desc' />
        <button onclick={onClick}>save</button>
    </div>
    <script>
        this.collection = 'todos'
        this.mixin(FormMixin(this))
        this.initForm()

        onClick(evt){
            this.save()
        }
    </script>
</my-static-todo-item-form>

<my-todo-item-form>
    <div>
        <string-input mapLink={doc} name='desc' />
        <button onclick={onClick}>save</button>
    </div>
    <script>
        this.collection = 'todos'
        this.mixin(FormMixin(this))
        this.doc = observable(asMap(this.opts.doc))

        onClick(evt){
            this.save()
            this.parent.doneEdit()
        }
    </script>
</my-todo-item-form>

<todo-item>
    <div>
        <span class={"pointer " + (item.done ? 'done': '')} onclick={onClick}>{item.desc}</span>
        <button onclick={onEdit}>edit</button>
        <div if={edit}>
            <my-todo-item-form doc={item} />
        </div>
    </div>
    <style scoped>
        .done{
            text-decoration:line-through;
        }
        .pointer{cursor: pointer;}
    </style>
    <script>
        this.edit = false
        onEdit(evt){
            this.edit = !this.edit
            this.parent.onEdit(evt.item.item)
        }
        doneEdit(){
            this.edit = false
        }
        onClick(evt){
            this.parent.toggle(evt.item.item)
        }
    </script>
</todo-item>

<app>
    <div>
        <button onclick={toggleLanguage}>es/en</button>
        <button onclick={()=>this.filter.set('ALL')}>{t('ALL')}</button>
        <button onclick={()=>this.filter.set('PENDING')}>{t('PENDING')}</button>
        <button onclick={()=>this.filter.set('DONE')}>{t('DONE')}</button>
    </div>
    <div>{t(this.filter.get())}</div>
    <string-input link={val} />
    <button disabled={!this.enabled} onclick={onClick}>add</button>
    <br>
    <my-static-todo-item-form rv={rvEdit} predicateid={"unique id"} />
    <br>
    <todo-item each={ item, i in items }></todo-item>

    <script>
        this.mixin(UImixin(this))
        this.mixin(LinkMixin(this))
        this.mixin(i18nMixin(this))

        this.i18nInit()

        this.filter = observable('ALL')
        autorun(() =>{
            this.subscribePredicate('unique id', 'todos', this.filter.get())
        })

        this.sortCmp = (a,b) => (a.desc <= b.desc) ? 1: -1

        this.val = observable('')
        this.rvEdit = observable(null)

        onEdit(item){
            this.rvEdit.set(item.id)
        }

        this.enabled = observable(true)
        onClick(evt){
            console.log('on click', {desc: this.val.get(), done: false})
            this.enabled.set(false)
            this.dispatcher.ask('rpc', 'add', 'todos', {desc: this.val.get(), done: false}).then((ret)=>this.enabled.set(true))
            this.val.set('')
        }

        toggle(item){
            this.dispatcher.ask('rpc', 'update', 'todos', item.id, {done: !item.done})
        }

        toggleLanguage(evt){
            let lang = this.language.get()
            if(lang == 'es'){
                this.language.set('en')
            }else{
                this.language.set('es')
            }
        }

    </script>
</app>