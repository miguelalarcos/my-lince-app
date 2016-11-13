import {UImixin, LinkMixin} from 'lince/client/uiActor.js'
import {i18nMixin} from 'lince/client/i18n.js'
import {observable, autorun, asMap} from 'mobx'

<string-input>
    <input onchange={onChange} value={value} />
    <script>
        this.mixin(LinkMixin(this))
        this.value = ''
        this.link(this.opts.link, 'value')

        onChange(evt){
            this.opts.link.set(evt.target.value)
        }
    </script>
</string-input>

<todo-item>
    <div class={"pointer " + (item.done ? 'done': '')} onclick={onClick}>{item.desc}</div>
    <style scoped>
        .done{
            text-decoration:line-through;
        }
        .pointer{cursor: pointer;}
    </style>
    <script>
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