import {dispatcher} from  'lince/client/dispatcherActor'
import {status} from 'lince/client/status'
//import {ws} from 'lince/client/webSocketActor'
import 'lince/client/inputs.tag'

<!--
<integer-input>
    <input onkeyup={onChange} value={value} />
    <script>
        import {LinkMixin} from 'lince/client/uiActor.js'
        this.mixin(LinkMixin(this))
        this.value = ''
        if(this.opts.link){
            this.link(this.opts.link, 'value')
        }else{
            this.linkMap(this.opts.maplink, this.opts.name, 'value')
        }

        onChange(evt){
            let integer = /^[+-]?\d+$/.test(evt.target.value) ? parseInt(evt.target.value): evt.target.value
            if(this.opts.link){
                this.opts.link.set(integer)
            }else{
                this.opts.maplink.set(this.opts.name, integer)
            }
        }
        </script>
</integer-input>

<string-input>
    <input onkeyup={onChange} value={value} />
    <script>
        //import {LinkMixin} from 'lince/client/uiActor'
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
-->

<my-static-todo-item-form>
    <div>
        <string-input mapLink={doc} name='desc' />
        <span class='alert'>{error_message_desc}</span>
        <button disabled={!enabled} onclick={onClick}>save</button>
    </div>
    <style scoped>
        .alert{
            font-style: italic;
            color: red;
        }
    </style>
    <script>
        import {FormMixin} from 'lince/client/form'
        import {validateItem} from '../validation/validateItem.js'

        this.mixin(FormMixin(this))
        this.initForm('todos', ['desc'], validateItem)

        beforeAdd(doc){
            doc.done = false
            return doc
        }

        //afterSave(){
        //    this.opts.rv.set(null)
        //}

        onClick(evt){
            this.save().then(()=>this.opts.rv.set(null))
        }
    </script>
</my-static-todo-item-form>

<todo-item>
    <div>
        <span class={"pointer " + (item.done ? 'done': '')} onclick={onClick}>{item.desc}</span>
        <button onclick={parent.onEdit}>edit</button>
    </div>
    <style scoped>
        .done{
            text-decoration:line-through;
        }
        .pointer{cursor: pointer;}
    </style>
    <script>
        //import {AUDMixin} from 'lince/client/uiActor'
        //this.mixin(AUDMixin(this))
        onClick(evt){
            //this.update('todos', this.item.id, {done: !this.item.done})
            dispatcher.ask('rpc', 'update', 'todos', this.item.id, {done: !this.item.done})
        }
    </script>
</todo-item>

<login-form>
    <div>
        <string-input link={login}></string-input>
        <button onclick={signin}>Sign in</button>
    </div>
    <script>
        this.login = observable('')

        signin(evt){
            dispatcher.login(this.login.get())
        }

    </script>
</login-form>

<app>
    <span>{status}</span>
    <notifications-debug />
    <login-form> if={status == "connected"}</login-form>
    <div if={status == "logged"}>
        <button onclick={toggleLanguage}>es/en</button>
        <button onclick={()=>this.filter.set('ALL')}>{t('ALL')}</button>
        <button onclick={()=>this.filter.set('PENDING')}>{t('PENDING')}</button>
        <button onclick={()=>this.filter.set('DONE')}>{t('DONE')}</button>

        <div>{t(this.filter.get())}</div>

        <my-static-todo-item-form rv={rvEdit} predicateid={"unique id"} />
        <br>
        <todo-item each={ item, i in items }></todo-item>
        <br>
    </div>
    <!--<date-input link={myDate}></date-input>-->

    <script>
        import 'lince/client/notifications.tag'
        //import 'lince/client/datePicker.tag'
        import 'lince/client/login.tag'
        import {i18nMixin} from 'lince/client/i18n.js'
        import {UImixin} from 'lince/client/uiActor.js'
        import {LinkMixin} from 'lince/client/uiActor'
        import {observable, autorun, asMap} from 'mobx'
        this.mixin(UImixin(this))
        this.mixin(LinkMixin(this))
        this.mixin(i18nMixin(this))

        //this.i18nInit()

        this.filter = observable('ALL')
        //this.myDate = observable(new Date())
        this.link(status, 'status')

        autorun(() =>{
            this.subscribe('unique id', 'todos', this.filter.get())
        })

        this.orderBy = [['desc'], ['asc']] // desc is description

        this.val = observable('')
        this.rvEdit = observable(null)

        onEdit(evt){
            this.rvEdit.set(evt.item.item.id)
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