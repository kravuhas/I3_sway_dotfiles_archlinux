import QtQuick
import QtQuick.Layouts
import Quickshell

Panel {
  id: np
  panelId: "net"
  title: "network // 接続"
  panelWidth: 380

  RowLayout {
    Layout.fillWidth: true
    spacing: 10
    Text {
      text: Net.kind === "wifi" ? "\uf1eb" : (Net.kind === "wired" ? "\uf0ac" : "\uf071")
      color: Net.online ? Theme.accent : Theme.alert
      font.family: Theme.font
      font.pixelSize: 26
    }
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2
      Text {
        Layout.fillWidth: true
        text: Net.online ? Net.name : "offline"
        color: Theme.fg
        font.family: Theme.font
        font.pixelSize: 14
        font.bold: true
        elide: Text.ElideRight
      }
      Text {
        text: Net.online ? (Net.kind === "wifi" ? "wi-fi // sinal " + Net.signal + "%" : "cabo // conectado") : "sem internet"
        color: Theme.dim
        font.family: Theme.font
        font.pixelSize: 11
      }
    }
  }

  RowLayout {
    spacing: 8
    Chip { icon: "\uf011"; label: Net.wifiOn ? "wifi on" : "wifi off"; active: Net.wifiOn; onClicked: Net.toggleWifi() }
    Chip { icon: "\uf021"; label: "scan"; onClicked: Net.rescan() }
    Chip { icon: "\uf013"; label: "config"; onClicked: Quickshell.execDetached(["nm-connection-editor"]) }
    Chip { icon: "\uf120"; label: "nmtui"; onClicked: Quickshell.execDetached(["kitty","--class","nm-float","-e","nmtui"]) }
  }

  Repeater {
    model: Net.nets.slice(0, 8)
    delegate: Rectangle {
      id: row
      required property var modelData
      Layout.fillWidth: true
      implicitHeight: 30
      color: rma.containsMouse ? Qt.rgba(Theme.accent2.r, Theme.accent2.g, Theme.accent2.b, 0.55) : (modelData.active ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.18) : "transparent")
      border.width: 1
      border.color: modelData.active ? Theme.accent : Qt.rgba(Theme.fg.r, Theme.fg.g, Theme.fg.b, 0.15)
      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 8
        Text { text: "\uf1eb"; color: Theme.accent; font.family: Theme.font; font.pixelSize: 13 }
        Text {
          Layout.fillWidth: true
          text: row.modelData.ssid
          color: Theme.fg
          font.family: Theme.font
          font.pixelSize: 12
          elide: Text.ElideRight
        }
        Text { visible: row.modelData.secure; text: "\uf023"; color: Theme.dim; font.family: Theme.font; font.pixelSize: 11 }
        Text { text: row.modelData.signal + "%"; color: Theme.dim; font.family: Theme.font; font.pixelSize: 11 }
      }
      MouseArea {
        id: rma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Net.connectTo(row.modelData.ssid)
      }
    }
  }

  Text {
    visible: Net.nets.length === 0
    text: "nenhuma rede encontrada // aperte scan"
    color: Theme.dim
    font.family: Theme.font
    font.pixelSize: 11
  }
  Text {
    text: "clique numa rede: a senha e pedida numa janelinha"
    color: Theme.dim
    font.family: Theme.font
    font.pixelSize: 10
  }
}
