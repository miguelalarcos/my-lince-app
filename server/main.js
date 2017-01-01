const Q = require('q')
const Controller = require('lince/server/ServerController').Controller
const start = require('lince/server/ServerActor').start
const validateItem = require('../validation/validateItem').validateItem

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
        return this.get('i18n', lang)
    }

    beforeUpdate(collection, doc){
        doc.updatedAt = new Date()
        return doc
    }

    beforeAdd(collection, doc){
        doc.userId = this.userId
        return doc
    }

    can(type, collection, doc){
        if(this.userId) {
            return Q(true)
        }
        else{
            return super.call(type, collection, doc)
        }
    }

    check(collection, doc){
        if(collection == 'todos'){
            return validateItem.validate(doc)
        }
        return super.check(collection, doc)
    }
}

start(MyServer)

