import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.2

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 840
    height: 680
    title: qsTr("QT-CAPTURE")


    Rectangle {
        id: head
        width: parent.width
        height: 60
        color: "red"
        Button {
            id: startButton
            property bool started: false
            text: qsTr("Start")
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            onClicked: {
                if(started){
                    _threadPcap.pcapStop();
                    started = false;
                    text = qsTr("Start");
                }else{
                    _threadPcap.pcapStart();
                    started = true;
                    text = qsTr("Stop");
                }
            }
        }
    }



    Rectangle {
        id: body
        width: parent.width
        height: parent.height - head.height
        y: head.height
        color: "black"
        Connections {
            target: _qtpcap
            onSendBinary: {
                binaryModel.append(JSON.parse(binaryString))
            }
            onSendHexadecimal:{
                hexadecimalModel.append(JSON.parse(hexString))
            }
            onSendDiagram:{
                console.log(diaString)
                diagramModel.append(JSON.parse(diaString));
            }
        }

        ListModel{
            id: binaryModel
        }
        ListModel{
            id: hexadecimalModel
        }
        ListModel{
            id: diagramModel
        }

        TabView {
            width: parent.width
            height: parent.height
            Tab {
                title: "Binary"
                Binary{model:binaryModel}
            }
            Tab {
                title: "Hexadecimal"
                Hexadecimal{model:hexadecimalModel}
            }
            Tab {
                title: "Diagram"
                Diagram{model:diagramModel}
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





