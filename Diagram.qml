import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.2


ListView{
    //model: diagramModel
    //model:diagramModel.model

    delegate: Component {
        Rectangle{
            width: 800
            height: 500
            color: "black"
            ColumnLayout{
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Ethernet Head")
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 120
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.etherHeader.destination
                        }
                    }
                    Rectangle{
                        width: 120
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.etherHeader.source
                        }
                    }
                    Rectangle{
                        width: 20
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.etherHeader.type
                        }
                    }
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("IP Head")
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 120
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.etherHeader.destination
                        }
                    }
                    Rectangle{
                        width: 120
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.etherHeader.source
                        }
                    }
                    Rectangle{
                        width: 20
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.etherHeader.type
                        }
                    }

                }
            }


        }
    }


}


