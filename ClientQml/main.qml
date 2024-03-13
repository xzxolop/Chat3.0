import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.6


Window {
    id: _app
    width: 600
    height: 450
    visible: true

    WebSocket {
        id: _ws
        property string myId: "0"
        property var messages: []
        url: "ws://127.0.0.1:8080"
        active: false

        onBinaryMessageReceived: {
            var data = JSON.parse(message);

            if (data.type === 'connect') {
                _ws.myId = data.data
            }

            else if(data.type === 'message') {
                var newMsg = {
                    sendBy: data.sendBy,
                    text: data.text
                }
                _messageModel.append(newMsg)
            }
        }

        // тут приходит приветственное сообщение при подключении (в будущем стоит переместить всё в onBinaryRecvMes)
        onTextMessageReceived: {
            var newMsg = { text: message }
            _messageModel.append(newMsg)
            viewMessage.model = _messageModel
        }
    }

    Page {
        id: _page
        anchors.fill: parent
        readonly property int margin: 10
        readonly property color panelColor: "#212121"
        readonly property color myMessageColor: "#8774e1"
        readonly property color serverMessageColor: "#212121"
        readonly property color bgColor: "#0E1621"
        readonly property color textColor: "white"

        background: Rectangle {
            color: _page.bgColor
        }

        // Connect button
        Button {
            id: _connect
            x: 50
            y: 30
            width: 100
            height: 40
            text: qsTr("Connect")

            background: Rectangle {
                color: _page.myMessageColor
            }

            onClicked: {
                _ws.active = !_ws.active
                if(text === qsTr("Connect"))
                    text = qsTr("Disconnect")
                else {
                    text = qsTr("Connect")
                }
            }
        }

        Column {
            x: _connect.x
            y: _connect.y + _connect.height + 30

            ListView {
                id: viewMessage
                width: _writeMes.x + _writeMes.width
                height: 280
                spacing: _page.margin
                model: _messageModel

                delegate: Rectangle {
                    height: 40
                    width: viewMessage.width-150
                    anchors.left: isMyMessage ? undefined : parent.left
                    anchors.right: isMyMessage ? parent.right : undefined
                    radius: 10
                    color: isMyMessage ? _page.myMessageColor : _page.serverMessageColor
                    property bool isMyMessage: model.sendBy === _ws.myId

                    Label {
                        x: 10
                        color: _page.textColor
                        text: 'id: ' + model.sendBy
                    }

                    Label {
                        x: 10
                        y: 15
                        color: _page.textColor
                        text: model.text
                    }
                }
            }

            Row {
                y: viewMessage.y + viewMessage.height
                spacing: 5

                TextField {
                    id: _writeMes
                    width: _page.width - 200
                    height: 50
                    wrapMode: Text.Wrap

                    background: Rectangle {
                        color: _page.panelColor
                    }

                    color: _page.textColor
                }

                Button {
                    id: _send
                    width: 50
                    height: _writeMes.height
                    text: qsTr("Send")

                    background: Rectangle {
                        color: _page.myMessageColor
                    }

                    // Send message function
                    onClicked: {
                        var message = {
                            type: "message",
                            text: _writeMes.text,
                            sendBy: _ws.myId
                        }

                        _ws.sendTextMessage(JSON.stringify(message))
                        _writeMes.clear()
                    }
                }
            }
        }

        ListModel {
            id: _messageModel

            ListElement {
                text: 'ban'
                sendBy: '128'
            }
        }
    }
}
