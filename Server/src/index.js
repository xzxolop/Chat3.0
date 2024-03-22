const ws = require('ws');

var port = 8080;
var ip = '127.0.0.1';

const wss = new ws.WebSocketServer({
    port: port, 
    host: ip,
});

clients = {};
console.log('Server is open on: ', ip, port);

wss.on('connection', (ws) => {
    // connect
    var id = (Math.floor(Math.random() * 1000)).toString();
    ws.send(Buffer.from(JSON.stringify({type: 'connect', data: id})));
    clients[id] = ws;

    console.log('Client connected ' + id);
    ws.send('Welcome! You are connect with id: ' + id); // пока отправляем только одному клиенту
    
    // recv
    ws.on('message', (mes) => {
        console.log(mes.toString());
        
        for(key in clients) {
            clients[key].send(mes);
        }
    });

    // disconnect
    ws.on('close', (ws) => {
    console.log('Client disconnected: ' + id); 

    delete clients[id]; 
   });
});




