import QtQuick 2.0
import QtQuick.Controls 2.15
import QtMultimedia 5.15
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

    id: root
    height: 60
    width: 480
    Rectangle {
        id: background
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: 0
        color: "#29292d"

        RowLayout {
            anchors.fill: parent
            spacing: 8
            Rectangle {
                id: thumbnialArea
                width: 48
                height: 48
                anchors.margins: 0
                radius: 4
                color: "transparent"
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
                            source: parent.playing ? "qrc:/assets/pause.png" : "qrc:/assets/play.png"
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
                id: infoArea
                Layout.fillWidth: true
                height: 48
                color: "transparent"
                ColumnLayout {
                    id: colLayout
                    anchors.fill: parent
                    spacing: 2
                    Rectangle {
                        id: mediaDisplay
                        height: 24
                        Layout.fillWidth: true
                        color: "transparent"
                        Text {
                            id: mediaName
                            text: displayName
                            color: "#ffffff"
                            font.pixelSize: 14
                        }
                    }
                    Rectangle {
                        id: durationArea
                        height: 24
                        Layout.fillWidth: true
                        color: "transparent"
                        RowLayout {
                            anchors.fill: parent
                            spacing: 2
                            Text {
                                height: parent.height
                                width: 100
                                text: timeToString(position)
                                font.pixelSize: 12
                                color: "#1fc1cc"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Rectangle {
                                width: 1
                                height: parent.height
                                color: "#4c4c52"
                            }
                            Text {
                                id: textDuration
                                text: timeToString(duration)
                                font.pixelSize: 12
                                color: "#4c4c52"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Slider {
                                id: control
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
                                      implicitWidth: 20
                                      implicitHeight: 20
                                      radius: 10
                                      color: control.pressed ? "#f0f0f0" : "#FFFFFF"
                                      border.color: "#bdbebf"
                                  }
                            }

                        }
                    }
                }
            }
            Rectangle {
                id: closeArea
                color: "#505057"
                width: 32
                height: 32
                radius: 16
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
