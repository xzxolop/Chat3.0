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

        onTextMessageReceived: {
            chat.text += "\n" + message

        }
    }

    Page {
        anchors.fill: parent
        Button {
            id: connect
            width: 100
            height: 40
            text: qsTr("Connect")
            x: 50
            y: 30

            onClicked: {
                ws.active = !ws.active
                if(text === qsTr("Connect"))
                    text = qsTr("Disconnect")
                else {
                    text = qsTr("Connect")
                }
            }
        }

        TextArea {
            id: chat
            width: 200
            height: 250
            x: connect.x
            y: connect.y + connect.height + 30
        }

        TextField {
            id: writeMes
            width: chat.width
            height: 50
            x: chat.x
            y: chat.y + chat.height + 3
        }

        Button {
            id: send
            text: qsTr("Send")
            x: writeMes.x + writeMes.width + 10
            y: writeMes.y
            width: 50
            height: writeMes.height

            onClicked: {
                ws.sendTextMessage(writeMes.text)
                writeMes.cl()
            }
        }

    }
}
