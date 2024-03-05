const ws = require('ws');

var port = 8080;
var ip = '127.0.0.1';

const wss = new ws.WebSocketServer({
    port: port, 
    host: ip,
});

console.log('Server is open on: ', ip, port);

wss.on('connection', (ws) => {
    // connect
    var id = (Math.floor(Math.random() * 1000)).toString();
    ws.send(Buffer.from(JSON.stringify({type: 'ban', data: id})));

    console.log('client connected');
    ws.send('Welcome! You are connect.');
    
    // recv
    ws.on('message', (mes) => {
        console.log(mes.toString());
        ws.send(mes.toString());
    });

    // disconnect
    ws.on('close', () => {
    console.log('Client disconnected');
   });
});




