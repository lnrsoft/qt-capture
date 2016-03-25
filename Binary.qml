import QtQuick 2.0
import QtQuick.Controls 1.3

TableView {
    alternatingRowColors: false
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
        TextEdit {
            readOnly: true
            selectByMouse: true
            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: {
                if(styleData.role==="number")return model.number
                else if(styleData.role==="content")return model.content
            }
            //textColor: "white"
            wrapMode: TextEdit.WrapAnywhere
            onContentHeightChanged: {
                if(styleData.row>0)myrow.height = contentHeight
                //console.log("content-height:"+contentHeight+" row:"+styleData.row)
            }
        }
    }
    rowDelegate: Rectangle{
        color:"black"
        height: {
            //console.log(styleData.row)
            return 200
        }
    }
}
