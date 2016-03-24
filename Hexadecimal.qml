import QtQuick 2.0
import QtQuick.Controls 1.2


TableView {
    backgroundVisible: false
    //objectName: "binaryTable"
    anchors.fill: parent
    //model:hexadecimalModel

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


