import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3


Item {
    id: root
    Rectangle {
        border.color: "black"
        anchors.fill: parent
        RowLayout {
            anchors.margins: 8
            anchors.fill: parent
            spacing: 8
            Rectangle {
                width: 80
                color: "red"
                Layout.fillHeight: true

            }
            Rectangle {
                color: "green"
                Layout.fillHeight: true
                Layout.fillWidth: true
                height: parent.height
                ColumnLayout {
                    anchors.margins: 4
                    spacing: 4
                    anchors.fill: parent
                    Rectangle {
                        height: 30
                        Layout.fillWidth: true
                        color:"red"
                    }
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color:"blue"
                        RowLayout {
                            spacing: 4
                            anchors.fill: parent
                            anchors.margins:4

                            Rectangle {
                                Layout.fillHeight: true
                                width: 75
                                color: "red"
                            }
                            Rectangle {
                                Layout.fillHeight: true
                                width: 1
                                color: "black"
                            }
                            Rectangle {
                                Layout.fillHeight: true
                                width: 75
                                color: "yellow"
                            }
                            Rectangle {
                            Layout.fillHeight: true
                             Layout.fillWidth: true
                             color: "green"
                            }
                        }
                    }
                }
            }
            Rectangle {
                width: 80
                color: "blue"
                Layout.fillHeight: true
            }
        }
    }

}
