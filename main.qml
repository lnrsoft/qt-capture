import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.2

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
            onSendDiagram:{
                console.log(diaString)
                jsonModel.append(JSON.parse(diaString));
            }
        }


    JSONListModel{
        id: jsonModel
        //json: '[{"etherHeader":{"destination":"c8:3a:35:3a:7f:50","source":"34:36:3b:5e:b1:ba","type":"IP"},"ipHeader":{"checksum":17982,"dest":"54.247.109.184","fragment":64,"headLength":20,"identification":49547,"protocol":6,"source":"192.168.11.101","totalLength":13312,"ttl":64,"type":0,"version":4},"tcpHeader":{"ackNumber":"4FFAF4D5","checksum":13209,"destPort":443,"seqNumber":"C06F31E9","sourcePort":56676,"urgentPoint":0,"windowSize":64783}}]'
        //json: '[{"label": {"a":"Answer"}, "value": "42"},{"label": {"a":"Alsace"}, "value": "68"}]'
        //query: "$[?(@.label.charAt(0)==='A')]"
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
        ListModel{
            //id: diagramModel
                ListElement{
                    number: "111"
                }
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
                ListView{
                    //model: diagramModel
                    model:jsonModel.model
                    delegate: Component {
                        Text {
                            width: parent.width
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 14
                            color: "white"
                            text: model.etherHeader.destination

                            Text {
                                anchors.fill: parent
                                anchors.rightMargin: 5
                                horizontalAlignment: Text.AlignRight
                                font.pixelSize: 12
                                color: "white"
                                text: model.etherHeader.destination
                            }
                        }
                    }




                }
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





