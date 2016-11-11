import {UImixin, LinkMixin} from 'lince/client/uiActor.js'
import {observable} from 'mobx'

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
    <div class={item.done ? 'done': ''} onclick={onClick}>{item.desc}</div>
    <style scoped>
        .done{
            text-decoration:line-through;
            icon: pointer;
        }
    </style>
    <script>
        onClick(evt){
            this.parent.toggle(evt.item)
        }
    </script>
</todo-item>

<app>
    <h1>TODO list</h1>
    <string-input link={val} />
    <button onclick={onClick}>add</button>
    <br>
    <todo-item each={ item, i in items }></todo-item>

    <script>
        this.mixin(UImixin(this))
        this.subscribePredicate('unique id', 'todos', 'ALL')
        this.sortCmp = (a,b) => 1

        this.val = observable('')

        onClick(evt){
            console.log({desc: this.val.get(), done: false})
            this.dispatcher.tell('rpc', 'add', 'todos', {desc: this.val.get(), done: false})
        }

        toggle(item){
            this.dispatcher.tell('rpc', 'update', 'todos', item.id, {done: !item.done})
        }

    </script>
</app>