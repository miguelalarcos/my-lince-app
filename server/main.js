const Q = require('q')
const Controller = require('lince/server/ServerController').Controller
const start = require('lince/server/ServerActor').start
const validateItem = require('../validation/validateItem').validateItem

class MyServer extends Controller{

    setUp(){
        this.permission('todos').canUpdate = (doc) => this.userId == doc.userId
        this.permission('todos').canAdd = (doc) => this.userId != null
        this.permission('todos').canDelete = (doc) => this.userId == doc.userId
    }

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

    rpc_allDone(){
        r.table('todos').filter({userId: this.userId}).update({done: true}).run(this.conn)
    }

    check(collection, doc){
        if(collection == 'todos'){
            return validateItem.validate(doc)
        }
        return super.check(collection, doc)
    }
}

start(MyServer)

