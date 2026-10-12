import QtQuick

Rectangle {
  id: c
  property string icon: ""
  property string label: ""
  property color tint: Theme.fg
  property bool active: false
  signal clicked()
  signal scrolled(int dir)

  implicitHeight: 24
  implicitWidth: row.implicitWidth + 18
  readonly property bool hot: ma.containsMouse || active
  color: hot ? Theme.accent2 : "transparent"
  border.width: 1
  border.color: hot ? Theme.accent : Qt.rgba(Theme.fg.r, Theme.fg.g, Theme.fg.b, 0.30)
  Behavior on color { ColorAnimation { duration: 120 } }

  Row {
    id: row
    anchors.centerIn: parent
    spacing: 7
    Text {
      visible: c.icon !== ""
      text: c.icon
      color: c.hot ? Theme.bg : c.tint
      font.family: Theme.font
      font.pixelSize: 14
      anchors.verticalCenter: parent.verticalCenter
    }
    Text {
      visible: c.label !== ""
      text: c.label
      color: c.hot ? Theme.bg : c.tint
      font.family: Theme.font
      font.pixelSize: 12
      anchors.verticalCenter: parent.verticalCenter
    }
  }
  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: c.clicked()
    onWheel: (w) => c.scrolled(w.angleDelta.y > 0 ? 1 : -1)
  }
}
