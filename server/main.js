const Controller = require('lince/server/ServerController').Controller
const start = require('lince/server/ServerActor').start

class MyServer extends Controller{
    rpc_add_(a,b, callback){
        callback(a+b)
    }
    subs_todos(filter){
        if(filter == 'ALL'){
            return r.table('todos')
        }
        else{
            return r.table('todos').filter({done: filter == 'DONE'})
        }
    }
    rpc_getLanguage(lang, c){
        console.log('****************')
        console.log(lang, c)
        this.get('i18n', lang, c)
    }
}

start(MyServer)

