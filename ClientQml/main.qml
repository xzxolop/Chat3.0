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

    ListModel {
        id: buttonModel

        ListElement {
            color: "green"
            text: "connect"
            con: function() {
                ws.active = true;
                console.log("connect");
            }
        }

        ListElement {
            color: "red"
            text: "disconnect"
            con: function() {
                ws.active = false;
                console.log("disconnect");
            }
        }
    }

    ListView {
        id: view
        anchors.fill: parent
        model: buttonModel

        delegate: Button {
            width: 100
            height: 50
            text: model.text
            onClicked: model.con()

            Rectangle{
                anchors.fill: parent
                color: model.color // Если написать buttonModel вместо model, то не окрасится поч?

            }
        }
    }
}
