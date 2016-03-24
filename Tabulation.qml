import QtQuick 2.0
import QtQuick.Controls 1.3

TableView {
    //alternatingRowColors: false
    backgroundVisible: false
    //objectName: "binaryTable"
    anchors.fill: parent
    model:diagramModel


    TableViewColumn {
        width: 40
        role: "protocol"
        title: "Protocol"
    }
    TableViewColumn {
        role: "ether_source"
        title: "Ether Source"
        width: 120
    }
    TableViewColumn {
        role: "ip_source"
        title: "IP Source"
        width: 120
    }
    TableViewColumn {
        role: "port_source"
        title: "Port Source"
        width: 60
    }
    TableViewColumn {
        role: "ether_dest"
        title: "Ether Dest"
        width: 120
    }
    TableViewColumn {
        width: 120
        role: "ip_dest"
        title: "IP Destination"
    }
    TableViewColumn {
        width: 60
        role: "port_dest"
        title: "Port Destination"
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
    itemDelegate: Rectangle {
        anchors.fill: parent
        color: "black"
        border.color: "white"
        width: 200
        TextEdit {
            readOnly: true
            selectByMouse: true
            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            text: {
                if(styleData.role == "ether_source")return model.etherHeader.source
                if(styleData.role == "ether_dest")return model.etherHeader.destination
                if(styleData.role == "protocol")return model.etherHeader.type
                if(styleData.role == "ip_source")return model.ipHeader.source
                if(styleData.role == "ip_dest")return model.ipHeader.dest
                if(styleData.role == "port_source")return model.tcpHeader.sourcePort
                if(styleData.role == "port_dest")return model.tcpHeader.destPort
            }

            //textColor: "white"
            wrapMode: TextEdit.WrapAnywhere
            onContentHeightChanged: {
                console.log("content-height:"+contentHeight+" row:"+styleData.row)
            }
        }
    }
    rowDelegate: Rectangle{
        color:"black"
        height: 20
    }
}
