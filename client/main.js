import 'lince'
import {store} from 'lince/client/collectionStoreActor'
import riot from 'riot'
import './app.tag'

store.register('todos', 'todos')

riot.mount('app')
