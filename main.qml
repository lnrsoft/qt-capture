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
        }
        ListModel{
            id: binaryModel
    //        ListElement{
    //            number: "111"
    //            content: "aaa"
    //        }
        }
        ListModel{
            id: hexadecimalModel
        }
        TabView {
            width: parent.width
            height: parent.height
            Tab {
                title: "Binary"
                //source: "binary.qml"
                TableView {
                    backgroundVisible: false
                    //objectName: "binaryTable"
                    anchors.fill: parent
                    model:binaryModel

                    TableViewColumn {
                        role: "number"
                        title: "NO."
                        width: 80
                    }
                    TableViewColumn {
                        width: parent.width-80
                        role: "content"
                        title: "Packets Content"
                    }

                    property bool isRowCountChanged: false
                    onRowCountChanged:{isRowCountChanged=true}
                    Timer {
                        interval: 500; running: true; repeat: true
                        onTriggered: {
                            if(parent.isRowCountChanged){
                                positionViewAtRow(rowCount-1, ListView.End);
                                parent.isRowCountChanged = false;
                            }
                        }
                    }
                    itemDelegate: Item {
                        anchors.fill: parent
                        TextEdit {
                            readOnly: true
                            selectByMouse: true
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            color: "white"
                            text: styleData.value
                            //textColor: "white"
                            wrapMode: TextEdit.WrapAnywhere
                        }
                    }
                    rowDelegate: Rectangle{
                        color:"black"
                        height: 100
                    }
                }
            }
            Tab {
                title: "Hexadecimal"
                TableView {
                    backgroundVisible: false
                    //objectName: "binaryTable"
                    anchors.fill: parent
                    model:hexadecimalModel

                    TableViewColumn {
                        role: "number"
                        title: "NO."
                        width: 80
                    }
                    TableViewColumn {
                        width: parent.width-80
                        role: "content"
                        title: "Packets Content"
                    }

                    property bool isRowCountChanged: false
                    onRowCountChanged:{isRowCountChanged=true}
                    Timer {
                        interval: 500; running: true; repeat: true
                        onTriggered: {
                            if(parent.isRowCountChanged){
                                positionViewAtRow(rowCount-1, ListView.End);
                                parent.isRowCountChanged = false;
                            }
                        }
                    }
                    itemDelegate: Item {
                        anchors.fill: parent
                        TextEdit {
                            readOnly: true
                            selectByMouse: true
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            color: "white"
                            text: styleData.value
                            wrapMode: TextEdit.WrapAnywhere
                        }
                    }
                    rowDelegate: Rectangle{
                        color:"black"
                        height: 100
                    }
                }
            }
            Tab {
                title: "Diagram"
                //source: "diagram.qml"






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





