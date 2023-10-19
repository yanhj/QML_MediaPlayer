import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3


Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("音频播放")

    MediaPlayer {
        id: player
        source: "qrc:/assets/music.mp3"
        autoPlay: false
        onDurationChanged: {
            mediaPlayer.duration = duration
            console.log("duration", duration)
        }
        onPositionChanged: {
            mediaPlayer.position = position
            console.log("position", position)
            if(position >= duration) {
                mediaPlayer.playing = false
            }
        }
    }

    MMediaPlayer {
        x: 10
        y: 100
        id: mediaPlayer
        width: parent.width - 20
        visible: true
        enabled: true
        height: 60
        displayName: "大笑音频"
        duration: 300
        position: 5
        focus: true
        onSigPlay: {
            player.play()
        }
        onSigPause: {
            player.pause()
        }
        onSigStop: {
            visible = false
            player.stop()
        }
        onSigPositionChanged: {
           player.seek(ms)
        }
    }
    Timer {
        interval: 1000
        running: false
        repeat: false
        onTriggered: {

            player.play()
        }
    }

    Rectangle {
        y: 200
        x: 100
        height: 100
        width: 300
        border.color: "black"
        anchors.centerIn: parent
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
                width: 80
                color: "green"
                Layout.fillHeight: true
                Layout.fillWidth: true
                ColumnLayout {
                    anchors.margins: 4
                    spacing: 4
                    anchors.fill: parent
                    Rectangle {
                        height: parent.width / 2
                        Layout.fillWidth: true
                        color:"red"
                    }
                    Rectangle {
                        height: parent.width / 2
                        Layout.fillWidth: true
                        color:"blue"
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

    MusicItem {
        x: 100
        y: 300
        width: parent.width - 150;
        height: 100

    }

    /*
    ListView {
        anchors.fill: parent
        model: ListModel {
            ListElement{videoPath:"http://xiuxiu.video.xiuxiustatic.com/oGlwyqosDYe2qm5L2l84S39G2W5mg4_H264_1_b28a8044ab549.mp4?k=bf2e7e6aae3eef78559f76d1d18cfd32&t=6530e451"}
            ListElement{videoPath:"http://xiuxiu.video.xiuxiustatic.com/njw5NYLcyOGagVX2DPLH2YnW1NRaj_H264_1_826f7b3f77bb73.mp4?k=af397fac5f055de85fe294d4e5c2dfab&t=6530d94d"}
        }
        delegate: Item {
            width: 200
            height: 200
            MediaPlayer {
                id: player
                source:videoPath
                autoPlay: true

            }
            VideoOutput {
                id: outVideo
                anchors.fill: parent
                source: player
            }
            MouseArea {
                onClicked: {

                    plyer.play()
                }
            }
        }
    }
    */
}
