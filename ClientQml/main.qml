import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebSockets

Window {
    width: 350
    height: 450
    visible: true

    WebSocket {
        id: ws
        url: "ws://127.0.0.1:8080"
        active: false
    }

    Page {
        anchors.fill: parent
        Button {
            width: 100
            height: 40
            text: "Connect"
            x: 50
            y: 30

            onClicked: {
                ws.active = !ws.active
                if(text === "Connect")
                    text = "Disconnect"
                else {
                    text = "Connect"
                }
            }
        }


    }
}
