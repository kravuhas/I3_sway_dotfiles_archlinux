import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.I3
import Quickshell.Wayland
import Quickshell.Services.UPower

PanelWindow {
  id: bar
  anchors { top: true; left: true; right: true }
  implicitHeight: 36
  color: "transparent"
  WlrLayershell.namespace: "lain-bar"

  readonly property string home: Quickshell.env("HOME")
  readonly property var p: State.player
  readonly property bool hasPlayer: p !== null && p !== undefined
  readonly property var bat: UPower.displayDevice
  readonly property real pct: bat ? (bat.percentage <= 1 ? bat.percentage * 100 : bat.percentage) : 0
  readonly property bool hasBat: bat !== null && bat !== undefined && bat.isLaptopBattery

  SystemClock { id: clock; precision: SystemClock.Seconds }

  function volIcon() { return State.muted ? "\uf026" : (State.volume < 0.35 ? "\uf027" : "\uf028") }
  function batIcon() {
    if (bar.bat && bar.bat.state === UPowerDeviceState.Charging) return "\uf0e7"
    return pct > 85 ? "\uf240" : pct > 60 ? "\uf241" : pct > 35 ? "\uf242" : pct > 12 ? "\uf243" : "\uf244"
  }

  Rectangle {
    anchors.fill: parent
    color: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.94)

    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 2; color: Theme.accent2 }
    Rectangle { anchors.bottom: parent.bottom; anchors.bottomMargin: 2; width: parent.width; height: 1; color: Qt.rgba(Theme.alert.r, Theme.alert.g, Theme.alert.b, 0.6) }

    RowLayout {
      anchors.left: parent.left
      anchors.leftMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      spacing: 10

      Rectangle {
        implicitWidth: tag.implicitWidth + 18
        implicitHeight: 24
        color: tagMa.containsMouse ? Theme.alert : Theme.accent
        Behavior on color { ColorAnimation { duration: 120 } }
        Text {
          id: tag
          anchors.centerIn: parent
          text: "\uf120  渋谷//lain"
          color: Theme.bg
          font.family: Theme.font
          font.pixelSize: 12
          font.bold: true
        }
        MouseArea {
          id: tagMa
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: Quickshell.execDetached(["wofi", "-c", bar.home + "/.config/wofi/config", "-I"])
        }
      }

      Rectangle {
        width: 8; height: 8; radius: 4
        color: Theme.alert
        SequentialAnimation on opacity {
          loops: Animation.Infinite
          NumberAnimation { to: 0.15; duration: 700 }
          NumberAnimation { to: 1; duration: 700 }
        }
      }

      Repeater {
        model: I3.workspaces
        delegate: Rectangle {
          required property var modelData
          implicitWidth: modelData.focused ? 34 : 24
          implicitHeight: 22
          color: modelData.focused ? Theme.accent : "transparent"
          border.width: 1
          border.color: modelData.urgent ? Theme.alert : (modelData.focused ? Theme.accent : Theme.dim)
          Behavior on implicitWidth { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
          Behavior on color { ColorAnimation { duration: 140 } }
          Text {
            anchors.centerIn: parent
            text: modelData.number
            font.family: Theme.font
            font.pixelSize: 12
            font.bold: modelData.focused
            color: modelData.focused ? Theme.bg : Theme.fg
          }
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: I3.dispatch("workspace number " + modelData.number)
          }
        }
      }
    }

    RowLayout {
      anchors.centerIn: parent
      spacing: 10
      Text { text: "現在 //"; color: Theme.dim; font.family: Theme.font; font.pixelSize: 11 }
      Text {
        text: Qt.formatDateTime(clock.date, "HH:mm:ss")
        color: Theme.accent
        font.family: Theme.font
        font.pixelSize: 15
        font.bold: true
      }
      Text { text: Qt.formatDateTime(clock.date, "yyyy.MM.dd"); color: Theme.fg; font.family: Theme.font; font.pixelSize: 12 }
    }

    RowLayout {
      anchors.right: parent.right
      anchors.rightMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      Chip {
        visible: bar.hasPlayer
        icon: "\uf001"
        label: bar.hasPlayer ? bar.p.trackTitle.substring(0, 24) : ""
        tint: Theme.accent
        active: State.popup === "music"
        onClicked: State.toggle("music")
      }
      Chip {
        icon: bar.volIcon()
        label: Math.round(State.volume * 100) + "%"
        tint: State.muted ? Theme.alert : Theme.fg
        active: State.popup === "vol"
        onClicked: State.toggle("vol")
        onScrolled: (d) => State.setVolume(State.volume + d * 0.05)
      }
      Chip {
        icon: Net.kind === "wifi" ? "\uf1eb" : (Net.kind === "wired" ? "\uf0ac" : "\uf071")
        label: Net.kind === "wifi" ? Net.name.substring(0, 14) : (Net.kind === "wired" ? "wired" : "offline")
        tint: Net.online ? Theme.fg : Theme.alert
        active: State.popup === "net"
        onClicked: State.toggle("net")
      }
      Chip {
        visible: bar.hasBat
        icon: bar.batIcon()
        label: Math.round(bar.pct) + "%"
        tint: bar.pct < 15 ? Theme.alert : Theme.fg
      }
      Chip {
        icon: "\uf03e"
        onClicked: Quickshell.execDetached([bar.home + "/.config/sway/scripts/wallsel.sh"])
      }
      Chip {
        icon: "\uf011"
        tint: Theme.alert
        onClicked: Quickshell.execDetached([bar.home + "/.config/sway/scripts/powermenu.sh"])
      }
    }
  }
}
