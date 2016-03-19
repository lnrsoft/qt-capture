import QtQuick 2.3
import QtQuick.Controls 1.2

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 840
    height: 680
    title: qsTr("Hello World")

    Rectangle {
        id: head
        width: parent.width
        height: 60
        color: "red"

        Button {
            id: startButton
            text: qsTr("Start")
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            onClicked: _qtpcap.pcapStart()
        }
    }

    Rectangle {
        id: body
        width: parent.width
        height: parent.height - head.height
        y: head.height
        color: "blue"

        TabView {
            width: parent.width
            height: parent.height
            Tab {
                title: "Binary"
                source: "binary.qml"
            }
            Tab {
                title: "Hexadecimal"
                source: "hexadecimal.qml"
            }
            Tab {
                title: "Diagram"
                source: "diagram.qml"
            }
            Tab {
                title: "Tabulation"
                source: "tabulation.qml"
            }
            Tab {
                title: "Textual"
                source: "textual.qml"
            }
        }
    }
}





