import {UImixin, LinkMixin} from 'lince/client/uiActor.js'
import {i18nMixin} from 'lince/client/i18n.js'
import {observable, autorun, asMap} from 'mobx'
import {FormMixin} from 'lince/client/form.js'
import 'lince/client/notifications.tag'

<string-input>
    <input onkeyup={onChange} value={value} />
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
        <span>{error_message_desc}</span>
        <button disabled={!enabled} onclick={onClick}>save</button>
    </div>
    <script>
        import {validateItem} from '../validation/validateItem.js'
        this.collection = 'todos'
        this.mixin(FormMixin(this))
        this.initForm(['desc'], validateItem)

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
    <notifications-debug />
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

        this.enabled = true
        onClick(evt){
            this.enabled = false
            this.dispatcher.ask('rpc', 'add', 'todos', {desc: this.val.get(), done: false}).then((ret)=>this.enabled = true)
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