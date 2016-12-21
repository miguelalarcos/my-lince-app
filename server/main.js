const Q = require('q')
const Controller = require('lince/server/ServerController').Controller
const start = require('lince/server/ServerActor').start

class MyServer extends Controller{

    subs_todos(filter){
        if(filter == 'ALL'){
            return r.table('todos')
        }
        else{
            return r.table('todos').filter({done: filter == 'DONE'})
        }
    }
    rpc_getLanguage(lang){
        return Q({}) //this.get('i18n', lang)
    }

    beforeUpdate(collection, doc){
        doc.updatedAt = new Date()
        return doc
    }

    rpc_can(action, args){
        return true
    }

    can(...args){
        return Q(true)
    }

}

start(MyServer)

