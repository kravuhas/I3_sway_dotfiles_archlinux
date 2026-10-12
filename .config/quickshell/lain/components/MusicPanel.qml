import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Panel {
  id: mp
  panelId: "music"
  title: "now playing // 再生中"
  panelWidth: 400

  readonly property var p: State.player
  readonly property bool has: p !== null && p !== undefined

  function fmt(s) {
    const m = Math.floor(s / 60), ss = Math.floor(s % 60)
    return m + ":" + (ss < 10 ? "0" : "") + ss
  }

  Timer {
    interval: 1000; repeat: true
    running: State.popup === "music" && mp.has && mp.p.isPlaying
    onTriggered: mp.p.positionChanged()
  }

  RowLayout {
    Layout.fillWidth: true
    spacing: 14

    ClippingRectangle {
      Layout.preferredWidth: 112
      Layout.preferredHeight: 112
      radius: 56
      color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.20)
      border.width: 2
      border.color: Theme.accent
      Image {
        anchors.fill: parent
        source: mp.has ? mp.p.trackArtUrl : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
      }
      Rectangle {
        anchors.centerIn: parent
        width: 18; height: 18; radius: 9
        color: Theme.bg
        border.width: 2
        border.color: Theme.accent
      }
      RotationAnimator on rotation {
        from: 0; to: 360; duration: 12000
        loops: Animation.Infinite
        running: mp.has && mp.p.isPlaying
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 4
      Text {
        Layout.fillWidth: true
        text: mp.has ? mp.p.trackTitle : "nothing playing // 再生なし"
        color: Theme.fg
        font.family: Theme.font
        font.pixelSize: 15
        font.bold: true
        elide: Text.ElideRight
      }
      Text {
        Layout.fillWidth: true
        text: mp.has ? mp.p.trackArtist : ""
        color: Theme.accent
        font.family: Theme.font
        font.pixelSize: 12
        elide: Text.ElideRight
      }
      Text {
        Layout.fillWidth: true
        text: mp.has ? "via " + mp.p.identity : ""
        color: Theme.dim
        font.family: Theme.font
        font.pixelSize: 11
        elide: Text.ElideRight
      }
    }
  }

  Item {
    Layout.fillWidth: true
    implicitHeight: 14
    visible: mp.has && mp.p.lengthSupported
    Rectangle {
      anchors.verticalCenter: parent.verticalCenter
      width: parent.width; height: 4
      color: Qt.rgba(Theme.fg.r, Theme.fg.g, Theme.fg.b, 0.15)
      Rectangle {
        height: parent.height
        width: (mp.has && mp.p.length > 0) ? parent.width * Math.min(1, mp.p.position / mp.p.length) : 0
        color: Theme.accent
      }
    }
    MouseArea {
      anchors.fill: parent
      onClicked: (m) => { if (mp.has && mp.p.canSeek) mp.p.position = (m.x / width) * mp.p.length }
    }
  }

  RowLayout {
    Layout.fillWidth: true
    visible: mp.has && mp.p.lengthSupported
    Text { text: mp.has ? mp.fmt(mp.p.position) : ""; color: Theme.dim; font.family: Theme.font; font.pixelSize: 11 }
    Item { Layout.fillWidth: true }
    Text { text: mp.has ? mp.fmt(mp.p.length) : ""; color: Theme.dim; font.family: Theme.font; font.pixelSize: 11 }
  }

  RowLayout {
    Layout.alignment: Qt.AlignHCenter
    spacing: 28
    IconBtn { text: "\uf048"; onClicked: if (mp.has) mp.p.previous() }
    IconBtn {
      text: (mp.has && mp.p.isPlaying) ? "\uf04c" : "\uf04b"
      base: Theme.accent
      font.pixelSize: 28
      onClicked: if (mp.has) mp.p.togglePlaying()
    }
    IconBtn { text: "\uf051"; onClicked: if (mp.has) mp.p.next() }
  }

  RowLayout {
    Layout.alignment: Qt.AlignHCenter
    spacing: 8
    Chip { icon: "\uf1de"; label: "equalizer"; onClicked: Quickshell.execDetached(["easyeffects"]) }
    Chip { icon: "\uf028"; label: "mixer"; onClicked: Quickshell.execDetached(["pavucontrol"]) }
  }
}
