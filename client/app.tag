import {UImixin} from 'lince/client/uiActor.js'
import {Observable} from 'mobx'

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
        }
    </style>
    <script>
        onClick(evt){
            this.parent.toggle(evt.item)
        }
    </script>
</todo-item>

<app>
    <string-input link={val} />
    <button onclick={onClick}>add</button>
    <br>
    <todo-item each={ item, i in items }></todo-item>

    <script>
        this.mixin(UImixin(this))
        this.subscribePredicate('unique id', 'todos', 'ALL')
        this.sortCmp = (a,b) => 1

        this.val = Observable('')

        onClick(evt){
            this.dispatcher.rpc('add', 'todos', {desc: this.val.get(), done: false})
        }

        toggle(item){
            this.dispatcher.rpc('update', 'todos', item.id, {done: !item.done})
        }

    </script>
</app>