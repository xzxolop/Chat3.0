const ws = require('ws');
var port = 8080;
var ip = '127.0.0.1';

const wss = new ws.WebSocketServer({
    port: port, 
    host: ip,
});

console.log('Server is open on: ', ip, port);

wss.on('connection', () => {
    console.log('client connected');
});
