import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebSockets

Window {
    width: 400
    height: 450
    visible: true

    WebSocket {
        id: ws
        url: "ws://127.0.0.1:8080"
        active: false
        property string clientId: "0"

        onBinaryMessageReceived: {
            var data = JSON.parse(message);
            console.log(data.toString());
            if (data.type === 'connect') {
                ws.clientId = data.data;
            }
        }

        onTextMessageReceived: {
            chat.text += "\n" + message
        }
    }

    Page {
        anchors.fill: parent

        // Connect button
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
            width: 250
            height: 250
            x: connect.x
            y: connect.y + connect.height + 30
            wrapMode: Text.Wrap
        }

        TextField {
            id: writeMes
            width: chat.width
            height: 50
            x: chat.x
            y: chat.y + chat.height + 3
            wrapMode: Text.Wrap
        }


        Button {
            id: send
            text: qsTr("Send")
            x: writeMes.x + writeMes.width + 10
            y: writeMes.y
            width: 50
            height: writeMes.height

            // Send message function
            onClicked: {
                var message = {
                    text: writeMes.text

                }

                ws.sendTextMessage(writeMes.text)
                writeMes.clear()
            }
        }

    }
}
