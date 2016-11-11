const Controller = require('lince/server/ServerController').Controller
const start = require('lince/server/ServerActor').start

class MyServer extends Controller{
    rpc_add_(a,b, callback){
        callback(a+b)
    }
    subs_todos(){
        return r.table('todos')
    }
    rpc_getLanguage(lang, c){
        this.get('language', lang, c)
    }
}

start(MyServer)

