const Server = require('lince/server/ServerController').Server
const start = require('lince/server/ServerActor').start

class MyServer extends Server{
    rpc_add_(a,b, callback){
        callback(a+b)
    }
    subs_predicateA(){
        return r.table('collection')
    }
}

start(MyServer)

