import {mbx} from 'lince/client/collectionStoreActor'
import riot from 'riot'
import './app.tag'

mbx.newCollection('collection')
mbx.register('predicateA', 'collection')

riot.mount('app')
