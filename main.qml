import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.12

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    MediaPlayer {
        id: player
        source: "file:///Users/yanhuajian/WorkSpace/测试数据/音频/music.mp3"
        autoPlay: false
        onDurationChanged: {
            mediaPlayer.duration = duration
            console.log("duration", duration)
        }
        onPositionChanged: {
            mediaPlayer.position = position
            console.log("position", position)
        }
    }

    MMediaPlayer {
        x: 10
        y: 100
        id: mediaPlayer
        width: parent.width - 20
        visible: true
        enabled: true
        height: 52
        displayName: "hello"
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
    }
    Timer {
        interval: 1000
        running: false
        repeat: false
        onTriggered: {

            player.play()
        }
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
