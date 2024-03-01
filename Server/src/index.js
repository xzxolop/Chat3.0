import { WebSocketServer } from 'ws';

var port = 8080;
var ip = '127.0.0.1';

const wss = new WebSocketServer({
    port: port, 
    host: ip,
});

console.log('Server is open on: ', ip, port);

wss.on('connection', (ws) => {
    console.log('client connected');
    
    ws.on('message', (mes) => {
        console.log(mes);
    });

    ws.on('message', function message(data) {
        console.log('received: %s', data);
    });
    
    ws.send('something');
});


