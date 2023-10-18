## 问题1：MouseArea中处理鼠标事件无效

```javascript
//无效代码
Rectangle {
	MouseArea {
    onClicked: {
        console.log("clicked")
    }
  }
}
```

`anchors.fill:parent` 

```javascript
//正常代码
Rectangle {
	MouseArea {
    anchors.fill: parent
    onClicked: {
      console.log("clicked")
    }
	}
}
```

处理`onEntered`，`onExited`事件

需要启用 `hoverEnabled: true` 属性

```javascript
//正常代码
Rectangle {
	MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onEntered: {
      console.log("entered")
    }
    onExited: {
      console.log("exited")
    }
    onClicked: {
      console.log("clicked")
    }
	}
}
```

