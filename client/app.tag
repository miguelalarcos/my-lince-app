import {dispatcher} from  'lince/client/dispatcherActor'
import {status} from 'lince/client/status'
import 'lince/client/inputs.tag'

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

        onClick(evt){
            this.save().then(()=>{
                this.opts.rv.set(null)
            })
        }
    </script>
</my-static-todo-item-form>

<todo-item>
    <div>
        <span class={"pointer " + (item.done ? 'done': '')} onclick={onClick}>{item.desc}</span>
        <button if={sameUser()} onclick={parent.onEdit}>edit</button>
    </div>
    <style scoped>
        .done{
            text-decoration:line-through;
        }
        .pointer{cursor: pointer;}
    </style>
    <script>
        sameUser(){
            return this.item.userId == dispatcher.userId
        }
        onClick(evt){
            dispatcher.update('todos', this.item.id, {done: !this.item.done})
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
    <login-form if={status == "connected"}></login-form>
    <div if={status == "logged"}>
        <button onclick={toggleLanguage}>es/en</button>
        <button onclick={()=>this.filter.set('ALL')}>{t('ALL')}</button>
        <button onclick={()=>this.filter.set('PENDING')}>{t('PENDING')}</button>
        <button onclick={()=>this.filter.set('DONE')}>{t('DONE')}</button>

        <div>{t(this.filter.get())}</div>

        <my-static-todo-item-form rv={rvEdit} predicateid={"unique id"} />
        <br>
        <todo-item each={ item, i in items }></todo-item>
    </div>
    <!--<date-input link={myDate}></date-input>-->

    <script>
        import 'lince/client/notifications.tag'
        //import 'lince/client/datePicker.tag'
        import 'lince/client/login.tag'
        import {i18nMixin} from 'lince/client/i18n.js'
        import {UImixin} from 'lince/client/uiActor.js'
        import {LinkMixin} from 'lince/client/uiActor'
        import {observable, autorun} from 'mobx'
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