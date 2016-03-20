import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.3
import QtQuick.Window 2.2

Rectangle {
    anchors.fill: parent
    color: "black"


    TableView {
        objectName: "binaryTable"
        anchors.fill: parent
        TableViewColumn {
            role: "number"
            title: "NO."
            width: 80
        }
        TableViewColumn {
            role: "content"
            title: "Content"
        }
        model: libraryModel
    }

    ListModel {
        id: libraryModel
        ListElement {
            number: "A Masterpiece"
            content: "Gabriel"
        }
        ListElement {
            number: "Brilliance"
            content: "Jens"
        }
        ListElement {
            number: "Outstanding"
            content: "asdfsfd"
        }
    }

}

