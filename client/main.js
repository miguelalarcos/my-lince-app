import 'lince'
import {store} from 'lince/client/collectionStoreActor'
import {offline} from 'lince/client/offlineActor'
import riot from 'riot'
import './app.tag'

store.register('todos', 'todos')

let todos_filter = (filter) => {
    return (item) => {
        if(filter == 'ALL'){
            return true
        }else{
            return filter == 'DONE'? item.done: !item.done
        }
    }
}
offline.register('todos', todos_filter)


riot.mount('app')
