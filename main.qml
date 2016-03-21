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
            property bool started: false
            text: qsTr("Start")
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            onClicked: {
                if(started){
                    _qtpcap.pcapStop();
                    started = false;
                    text = qsTr("Start");
                }else{
                    _qtpcap.pcapStart();
                    started = true;
                    text = qsTr("Stop");
                }
            }
            Connections {
                target: _qtpcap
                onSend2qml: {
                    jsonString = count;
                }
            }
        }

        Button{
            anchors.fill: parent.Center
            text: "add row"
            onClicked: {
                listModel.append(JSON.parse(jsonString))
            }
        }
    }
    property string jsonString: '{"number":"999", "content":"888"}'

    ListModel{
        id: listModel
        ListElement{
            number: "111"
            content: "aaa"
        }
        ListElement{
            number: "111"
            content: "aaa"
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
                //source: "binary.qml"
                TableView {
                    //objectName: "binaryTable"
                    anchors.fill: parent

                    TableViewColumn {
                        role: "number"
                        title: "NO."
                        width: 80
                    }
                    property bool isRowContChanged: false
                    onRowCountChanged:{isRowContChanged=true}
                    Timer {
                        interval: 500; running: true; repeat: true
                        onTriggered: {
                            if(parent.isRowContChanged){
                                positionViewAtRow(rowCount-1, ListView.End)
                                parent.isRowContChanged = false
                            }
                        }

                    }

                    TableViewColumn {
                        role: "content"
                        title: "Content"
                    }
                    model:listModel


                    itemDelegate: Item {
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: styleData.textColor
                            elide: styleData.elideMode
                            text: styleData.value
                        }
                    }

                }
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





