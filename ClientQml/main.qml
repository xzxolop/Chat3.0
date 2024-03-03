import QtQuick
import QtWebSockets

WebSocket {
        id: ws
        url: "ws://127.0.0.1:8080"
        active: true
}
