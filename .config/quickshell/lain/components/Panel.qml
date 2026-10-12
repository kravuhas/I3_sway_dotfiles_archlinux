import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
  id: win
  required property string panelId
  property string title: panelId
  property int panelWidth: 380
  default property alias content: body.data

  visible: State.popup === panelId
  anchors { top: true; right: true }
  margins { top: 42; right: 12 }
  implicitWidth: panelWidth
  implicitHeight: col.implicitHeight + 30
  exclusionMode: ExclusionMode.Ignore
  color: "transparent"
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.namespace: "lain-panel"

  onVisibleChanged: if (visible) fadeIn.restart()

  Rectangle {
    id: frame
    anchors.fill: parent
    color: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.96)
    border.width: 2
    border.color: Theme.accent2

    NumberAnimation { id: fadeIn; target: frame; property: "opacity"; from: 0; to: 1; duration: 170 }

    Rectangle { anchors.top: parent.top; width: parent.width; height: 3; color: Theme.alert }

    ColumnLayout {
      id: col
      anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
      anchors.topMargin: 16
      spacing: 10

      RowLayout {
        Layout.fillWidth: true
        Text {
          text: "// " + win.title
          color: Theme.accent
          font.family: Theme.font
          font.pixelSize: 12
          font.bold: true
        }
        Item { Layout.fillWidth: true }
        Text {
          text: "\u2715"
          color: Theme.dim
          font.family: Theme.font
          font.pixelSize: 14
          MouseArea { anchors.fill: parent; anchors.margins: -6; onClicked: State.popup = "" }
        }
      }

      ColumnLayout { id: body; Layout.fillWidth: true; spacing: 10 }
    }
  }
}
