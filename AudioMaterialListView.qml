import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15

Rectangle {
    id: root
    width: 800
    height: 600
    //到达底部时，发送继续加载信号
    signal qmlContinueLoad()
    //点击下载按钮
    signal qmlDownloadClicked(string id)
    //点击应用按钮时，发送信号
    signal qmlApplyClicked(string id)

    //构造要请求的在线缩略图资源json
    function constructImageSource(url, category) {
        var jsonData = {
            "url": url,
            "width": 90,
            "height": 90,
            "category": category
        };
        return JSON.stringify(jsonData);
    }

    function playerMusic(localFile, display, localThumbnail) {
        if (localFile === "")
            return ;
        console.log("localFile: " + localFile)
        player.source = localFile;
        mediaPlayer.displayName = display;
        //mediaPlayer.thumbnail = localThumbnail;
        mediaPlayer.visible = true;
        player.play();
        mediaPlayer.playing = true;
    }

    function closePlayer() {
        player.stop();
        mediaPlayer.visible = false;
    }

    anchors.margins: 8
    color: "#1a1a1c"

    GridView {
        /*
        ScrollBar.vertical: ScrollBar{
            policy: ScrollBar.AsNeeded
        }
         */

        id: gridView
        z:1

        property int highlightIndex: -1

        anchors.fill: parent
        cellHeight: 100
        cellWidth: 100
        delegate: cellDelegate
        flow: GridView.FlowLeftToRight
        focus: true
        model: appMaterialListModel
        onContentYChanged: {
            // 当内容的垂直偏移量加上视图的高度等于内容的总高度时，即到达底部
            if (contentY + gridView.height === contentHeight) {
                console.log("已经到达底部");
                qmlContinueLoad();
            }
        }
        onFocusChanged: {
        }
    }

    Component {
        id: cellDelegate

        Rectangle {
            required property int index
            required property string name
            required property string materialId
            required property string thumbnail
            required property string file
            required property string fileUrl
            required property string category
            required property bool downloaded

            color: "transparent"
            height: gridView.cellHeight
            radius: 4
            width: gridView.cellWidth

            Rectangle {
                id: rcImage

                anchors.margins: 5
                border.color: gridView.highlightIndex == index ? "darkblue" : "#10101c"
                border.width: 2
                color: "#10101c"
                focus: true
                height: 90
                radius: 4
                width: 90
                x: 5
                y: 5

                Rectangle {
                    anchors.centerIn: parent
                    anchors.fill: parent
                    anchors.margins: 4
                    color: '#10101c'

                    AnimatedImage {
                        id: imgBg

                        property url thunmbnailUrl: ""
                        property bool bPlaying: false
                        property string materialJson: ""

                        playing: bPlaying
                        anchors.centerIn: parent
                        anchors.fill: parent
                        /*图片缩放并保持比例*/
                        fillMode: Image.PreserveAspectCrop
                        horizontalAlignment: Text.AlignHCenter
                        /*协议标识 image://
                        materialAsyncImageProvider C++中注册的imageprovider
                         */
                        source: thumbnail === "" ? "" : (thumbnail)
                        //"image://materialAsyncImageProvider/" + constructImageSource(thumbnail, category)
                        verticalAlignment: Text.AlignVCenter
                    }
                    //拖拽相关
                    MouseArea {
                        id: mouseArea
                        propagateComposedEvents: true
                        drag.target: dragHandler
                        anchors.fill: parent
                        enabled: true
                        hoverEnabled: true
                        visible: true
                        onPressed: {
                            if(imgBg.thumbnailUrl === null || imgBg.thumbnailUrl === "" || imgBg.thumbnailUrl === undefined) {
                                imgBg.grabToImage(function(result){
                                    imgBg.thunmbnailUrl = result.url
                                })
                            }
                            if(downloaded && (imgBg.materialJson === null || imgBg.materialJson === "" || imgBg.materialJson === undefined)) {
                                //imgBg.materialJson = appMaterialListModel.constructJson(materialId)
                            }
                            mouse.accepted = false;
                        }
                        onClicked: {
                            //判断是否在mediaPlayer区域
                            console.log("containsMouse: " )

                            qmlDownloadClicked(materialId);
                            if(downloaded) {
                                playerMusic(file, name, thumbnail)
                            }
                            mouse.accepted = false;
                        }
                        onEntered: {
                            imgBg.bPlaying = true;
                            gridView.highlightIndex = index;
                        }
                        onExited: {
                            imgBg.bPlaying = false;
                            gridView.highlightIndex = -1;
                        }
                    }

                    Item {
                        id: dragHandler

                        anchors.fill: parent
                        visible: mouseArea.drag.active
                        Drag.active: mouseArea.drag.active && downloaded
                        Drag.dragType: Drag.Automatic
                        Drag.mimeData: {
                            "vidme/material": imgBg.materialJson
                        }
                        Drag.onDragStarted: {
                            console.log("drag started");
                        }
                        Drag.imageSource: imgBg.thunmbnailUrl
                    }

                }

                ToolTip {
                    id: tooltip

                    text: name
                    visible: false
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    color: "#af000000"
                    height: 20
                    radius: 4
                    width: parent.width

                    Text {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 20
                        padding: 6
                        rightPadding: 20
                        color: "#ffffff"
                        elide: Text.ElideMiddle/*省略方式*/
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        text: name

                        font {
                            pixelSize: 12
                        }

                    }

                    Text {
                        id: downloadButton

                        z: 10
                        anchors.right: parent.right
                        anchors.top: parent.top
                        width: 20
                        height: 20
                        color: "white"
                        text: downloaded ? "\ue6a7" : "\ue6a8"
                        visible: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        MouseArea {
                            propagateComposedEvents: true
                            anchors.fill: parent
                            enabled: true
                            hoverEnabled: true
                            visible: true
                            onClicked: {
                                if (downloaded) {
                                    qmlApplyClicked(materialId);
                                } else {
                                    qmlDownloadClicked(materialId);
                                }
                                mouse.accepted = false;
                            }
                            onEntered: {
                                //鼠标变成手势
                                cursorShape = Qt.PointingHandCursor;
                                tooltip.visible = true
                            }
                            onExited: {
                                //恢复鼠标手势
                                cursorShape = Qt.ArrowCursor;
                                tooltip.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: highlightDelegate

        Rectangle {
            color: "lightsteelblue"
            height: gridView.cellHeight
            radius: 5
            width: gridView.cellWidth
            x: gridView.currentItem.x
            y: gridView.currentItem.y

            Behavior on x {
                SpringAnimation {
                    damping: 0.2
                    spring: 3
                }

            }

            Behavior on y {
                SpringAnimation {
                    damping: 0.2
                    spring: 3
                }

            }

        }

    }

    MediaPlayer {
        id: player

        autoPlay: false
        onDurationChanged: {
            mediaPlayer.duration = duration;
        }
        onPositionChanged: {
            mediaPlayer.position = position;
            if (position >= duration)
                mediaPlayer.playing = false;

        }
    }
    MMediaPlayer {
        id: mediaPlayer
        z:100
        height: 60
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: false
        onSigPlay: {
            player.play();
        }
        onSigPause: {
            player.pause();
        }
        onSigStop: {
            player.stop();
            visible = false;
        }
        onSigPositionChanged: {
            player.seek(ms);
        }

    }

}