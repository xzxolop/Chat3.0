import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.6


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
        readonly property color panelColor: "#212121"
        readonly property color myMessageColor: "#8774e1"
        readonly property color serverMessageColor: "#212121"
        readonly property color bgColor: "#0E1621"
        readonly property color textColor: "white"

        background: Rectangle {
            color: page.bgColor
        }

        // Connect button
        Button {
            id: connect
            width: 100
            height: 40
            text: qsTr("Connect")
            x: 50
            y: 30

            background: Rectangle {
                color: page.myMessageColor
            }

            onClicked: {
                ws.active = !ws.active
                if(text === qsTr("Connect"))
                    text = qsTr("Disconnect")
                else {
                    text = qsTr("Connect")
                }
            }
        }

        ListView {
            id: viewMessage
            x: connect.x
            y: connect.y + connect.height + 30
            width: 500
            height: 320
            spacing: page.margin
            ScrollBar.vertical: ScrollBar {
                opacity: 0
            }

            model: myModel
            delegate: Rectangle {
                height: 40
                width: viewMessage.width-150
                anchors.left: isMyMessage ? undefined : parent.left
                anchors.right: isMyMessage ? parent.right : undefined
                radius: 10
                color: isMyMessage ? page.myMessageColor : page.serverMessageColor
                property bool isMyMessage: model.sendBy === ws.myId

                Label {
                    text: 'id: ' + model.sendBy
                    color: page.textColor
                    x: 10
                }

                Label {
                    y: 15
                    x: 10
                    text: model.text
                    color: page.textColor
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

        TextField {
            id: writeMes
            width: page.width - 100
            height: 50
            x: page.x + 20
            y: page.y + page.height - 75
            wrapMode: Text.Wrap

            background: Rectangle {
                color: page.panelColor
            }

            color: page.textColor
        }

        Button {
            id: send
            text: qsTr("Send")
            x: writeMes.x + writeMes.width + 10
            y: writeMes.y
            width: 50
            height: writeMes.height

            background: Rectangle {
                color: page.myMessageColor
            }

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
