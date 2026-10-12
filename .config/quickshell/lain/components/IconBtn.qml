import QtQuick

Text {
  id: t
  property color base: Theme.fg
  signal clicked()
  color: ma.containsMouse ? Theme.accent : base
  font.family: Theme.font
  font.pixelSize: 22
  Behavior on color { ColorAnimation { duration: 120 } }
  MouseArea {
    id: ma
    anchors.fill: parent
    anchors.margins: -8
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: t.clicked()
  }
}
