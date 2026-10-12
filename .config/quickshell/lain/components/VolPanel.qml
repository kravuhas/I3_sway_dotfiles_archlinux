import QtQuick
import QtQuick.Layouts
import Quickshell

Panel {
  panelId: "vol"
  title: "audio + luz // 音"
  panelWidth: 340

  RowLayout {
    Layout.fillWidth: true
    spacing: 10
    Text {
      text: State.muted ? "\uf026" : "\uf028"
      color: State.muted ? Theme.alert : Theme.accent
      font.family: Theme.font
      font.pixelSize: 18
      MouseArea { anchors.fill: parent; onClicked: State.toggleMute() }
    }
    Track { Layout.fillWidth: true; value: State.volume; onMoved: (v) => State.setVolume(v) }
    Text { text: Math.round(State.volume * 100) + "%"; color: Theme.fg; font.family: Theme.font; font.pixelSize: 12; Layout.preferredWidth: 38 }
  }

  RowLayout {
    Layout.fillWidth: true
    spacing: 10
    Text { text: "\uf185"; color: Theme.accent; font.family: Theme.font; font.pixelSize: 18 }
    Track { Layout.fillWidth: true; value: State.brightness; onMoved: (v) => State.setBrightness(v) }
    Text { text: Math.round(State.brightness * 100) + "%"; color: Theme.fg; font.family: Theme.font; font.pixelSize: 12; Layout.preferredWidth: 38 }
  }

  RowLayout {
    spacing: 8
    Chip { icon: "\uf028"; label: "mixer"; onClicked: Quickshell.execDetached(["pavucontrol"]) }
    Chip { icon: "\uf1de"; label: "equalizer"; onClicked: Quickshell.execDetached(["easyeffects"]) }
  }
}
