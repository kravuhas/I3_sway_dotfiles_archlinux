import QtQuick

Item {
  id: t
  property real value: 0
  signal moved(real v)
  implicitHeight: 20
  readonly property real v: Math.max(0, Math.min(1, value))

  Rectangle {
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width
    height: 6
    color: Qt.rgba(Theme.fg.r, Theme.fg.g, Theme.fg.b, 0.15)
    Rectangle { width: parent.width * t.v; height: parent.height; color: Theme.accent }
  }
  Rectangle {
    x: (t.width - width) * t.v
    anchors.verticalCenter: parent.verticalCenter
    width: 8
    height: 16
    color: Theme.fg
  }
  MouseArea {
    anchors.fill: parent
    function setAt(mx) { t.moved(Math.max(0, Math.min(1, mx / width))) }
    onPressed: (m) => setAt(m.x)
    onPositionChanged: (m) => { if (pressed) setAt(m.x) }
  }
}
