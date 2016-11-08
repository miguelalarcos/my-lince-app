import 'lince'
import {store} from 'lince/client/collectionStoreActor'
import riot from 'riot'
import './app.tag'

store.newCollection('A')
store.register('pA', 'A')

riot.mount('app')
