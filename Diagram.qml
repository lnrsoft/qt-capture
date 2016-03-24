import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.2


ListView{
    property bool isRowCountChanged: false
    onCountChanged:{isRowCountChanged=true}
    Timer {
        interval: 500; running: true; repeat: true
        onTriggered: {
            if(parent.isRowCountChanged){
                positionViewAtEnd()
                parent.isRowCountChanged = false;
            }
        }
    }
    delegate: Component {
        Rectangle{
            width: 800
            height: 300
            color: "black"
            ColumnLayout{
                spacing: 0
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
                        width: 150
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
                        width: 150
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
                        width: 40
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.ipHeader.version
                        }
                    }
                    Rectangle{
                        width: 40
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.ipHeader.headLength
                        }
                    }
                    Rectangle{
                        width: 60
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                           // text: model.ipHeader.headLength
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
                            //text: model.ipHeader.headLength
                        }
                    }
                    Rectangle{
                        width: 160
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.ipHeader.totalLength
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 160
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.ipHeader.identification
                        }
                    }
                    Rectangle{
                        width: 160
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.ipHeader.fragment
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 80
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.ipHeader.ttl
                        }
                    }
                    Rectangle{
                        width: 80
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.ipHeader.protocol
                        }
                    }
                    Rectangle{
                        width: 160
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.ipHeader.checksum
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 320
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.ipHeader.source
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 320
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.ipHeader.dest
                        }
                    }

                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("TCP Head")
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 160
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.tcpHeader.sourcePort
                        }
                    }
                    Rectangle{
                        width: 160
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.tcpHeader.destPort
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 320
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.tcpHeader.seqNumber
                        }
                    }

                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 320
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.tcpHeader.ackNumber
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 40
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            //text: model.tcpHeader.sourcePort
                        }
                    }
                    Rectangle{
                        width: 60
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            //text: model.tcpHeader.destPort
                        }
                    }
                    Rectangle{
                        width: 60
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            //text: model.tcpHeader.sourcePort
                        }
                    }
                    Rectangle{
                        width: 160
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: "white"
                            text: model.tcpHeader.windowSize
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    spacing: 0
                    Rectangle{
                        width: 160
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.tcpHeader.checksum
                        }
                    }
                    Rectangle{
                        width: 160
                        height: parent.height
                        color: "black"
                        border.color: "white"
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            text: model.tcpHeader.urgentPoint
                        }
                    }
                }
            }
        }
    }
}


