    import {UImixin, LinkMixin} from 'lince/client/uiActor.js'
import {observable, autorun} from 'mobx'

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
        <button onclick={()=>this.filter.set('ALL')}>All</button>
        <button onclick={()=>this.filter.set('PENDING')}>Pending</button>
        <button onclick={()=>this.filter.set('DONE')}>Done</button>
    </div>
    <string-input link={val} />
    <button onclick={onClick}>add</button>
    <br>
    <todo-item each={ item, i in items }></todo-item>

    <script>
        this.mixin(UImixin(this))

        this.filter = observable('ALL')
        autorun(() =>{
            this.subscribePredicate('unique id', 'todos', this.filter.get())
        })

        this.sortCmp = (a,b) => a.desc <= b.desc ? 1: -1

        this.val = observable('')

        onClick(evt){
            console.log('on click', {desc: this.val.get(), done: false})
            this.dispatcher.tell('rpc', 'add', 'todos', {desc: this.val.get(), done: false})
            this.val.set('')
        }

        toggle(item){
            this.dispatcher.tell('rpc', 'update', 'todos', item.id, {done: !item.done})
        }

    </script>
</app>