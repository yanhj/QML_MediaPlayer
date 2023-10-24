import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3


Item {
    property string displayName: ""
    property string signer: ""
    property int duration: 0
    property bool playing: false
    property alias position: control.value

    signal sigPlay()
    signal sigPause()
    signal sigStop()
    signal sigPositionChanged(int ms)

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
                Image {
                    source: "qrc:/assets/thumbnail.jpg"
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent

                    Rectangle {
                        id: playButton
                        width: 32
                        height: 32
                        radius: 16
                        color: "#af000000"
                        anchors.centerIn: parent
                        Image {
                            height: 16
                            width: 16
                            anchors.centerIn: parent
                            source: playing ? "qrc:/assets/pause.png" : "qrc:/assets/play.png"
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                cursorShape = Qt.PointingHandCursor
                            }
                            onExited: {
                                cursorShape = Qt.ArrowCursor
                            }

                            onClicked: {
                                playing = !playing
                                if(playing) {
                                    sigPlay()
                                } else {
                                    sigPause()
                                }
                            }
                        }
                    }
                }


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
                        Text {
                            id: mediaName
                            text: displayName
                            color: "#ffffff"
                            font.pixelSize: 14
                        }
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
                                Text {
                                    height: parent.height
                                    width: 75
                                    text: timeToString(position)
                                    font.pixelSize: 12
                                    color: "#1fc1cc"
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                }
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
                                Text {
                                    height: parent.height
                                    width: 75
                                    text: timeToString(position)
                                    font.pixelSize: 12
                                    color: "#1fc1cc"
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                            Rectangle {
                            Layout.fillHeight: true
                             Layout.fillWidth: true
                             color: "green"

                             Slider {
                                 id: control
                                 anchors.fill: parent
                                 enabled: duration > 0
                                 Layout.fillWidth: true
                                 to: duration
                                 padding: 0
                                 stepSize: 1
                                 from: 0
                                 background: Rectangle {
                                     x: control.leftPadding
                                     y: control.topPadding + control.availableHeight / 2 - height / 2
                                     implicitWidth: 200
                                     implicitHeight: 4
                                     width: control.availableWidth
                                     height: implicitHeight
                                     radius: 2
                                     color: "#47474B"

                                     Rectangle {
                                         width: control.visualPosition * parent.width
                                         height: parent.height
                                         color: "#1fc1cc"
                                         radius: 2
                                     }
                                 }
                                 handle: Rectangle {
                                       x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
                                       y: control.topPadding + control.availableHeight / 2 - height / 2
                                       implicitWidth: 16
                                       implicitHeight: 16
                                       radius: 8
                                       color: control.pressed ? "#f0f0f0" : "#FFFFFF"
                                       border.color: "#bdbebf"
                                   }
                                 onMoved: {
                                     console.log("position Changed: ", value)
                                     sigPositionChanged(value)
                                 }

                             }
                            }
                        }
                    }
                }
            }
            Rectangle {
                width: 48
                color: "blue"
                Layout.fillHeight: true
                Image {
                    width: 16
                    height: 16
                    source: "qrc:/assets/close.png"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        cursorShape = Qt.PointingHandCursor
                    }
                    onExited: {
                        cursorShape = Qt.ArrowCursor
                    }
                    onClicked: {
                        sigStop()
                    }
                }
            }
        }
    }

    function timeToString(msTime) {
        msTime = Math.floor(msTime / 1000)
        var seconds = Math.floor(msTime % 60);
        var minutes = Math.floor(msTime / 60 % 60);

        console.log(msTime, seconds, minutes)
        var hours = Math.floor(msTime / 3600 % 24);
        var formatedTime = ""
         if(minutes < 10) {
             formatedTime += "0"
         }
         formatedTime += minutes
         formatedTime += ":"
         if(seconds < 10) {
             formatedTime += "0"
         }
         formatedTime += seconds
         return formatedTime;
     }
}
