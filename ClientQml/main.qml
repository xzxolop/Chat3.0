import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebSockets


Window {
    width: 600
    height: 450
    visible: true

    WebSocket {
        id: ws
        url: "ws://127.0.0.1:8080"
        active: false
        property string myId: "0"
        property var messages: []

        onBinaryMessageReceived: {
            var data = JSON.parse(message);

            if (data.type === 'connect') {
                ws.myId = data.data;
            }

            else if(data.type === 'message') {
                var newMsg = {
                    sendBy: data.sendBy,
                    text: data.text
                }
                myModel.append(newMsg)
                viewMessage.model = myModel
            }
        }

        // тут приходит приветственное сообщение при подключении (в будущем стоит переместить всё в onBinaryRecvMes)
        onTextMessageReceived: {
            var newMsg = { text: message }
            myModel.append(newMsg)
            viewMessage.model = myModel
        }
    }

    Page {
        id: page
        anchors.fill: parent

        readonly property int margin: 10


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

        Label {
            id: chat
            width: 450
            height: 250
            x: connect.x
            y: connect.y + connect.height + 30
            wrapMode: Text.Wrap

            ListView {
                id: viewMessage
                anchors.fill: parent
                spacing: page.margin
                ScrollBar.vertical: ScrollBar{}

                model: myModel
                delegate: Rectangle {
                    height: 40
                    width: viewMessage.width-100
                    property bool isMyMessage: model.sendBy === ws.myId
                    color: isMyMessage ? 'green' : 'red'
                    border.color: 'black'


                    Label {
                        text: 'id: ' + model.sendBy
                    }

                    Label {
                        y: 15
                        text: model.text
                    }
                }
            }

            ListModel {
                id: myModel

                ListElement {
                    text: 'ban'
                    sendBy: '128'
                }
            }
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
                    type: "message",
                    text: writeMes.text,
                    sendBy: ws.myId
                }

                ws.sendTextMessage(JSON.stringify(message))
                writeMes.clear()
            }
        }
    }
}
