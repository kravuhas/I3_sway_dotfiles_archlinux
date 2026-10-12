pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property color bg: "#0b0816"
  property color fg: "#e9defe"
  property color accent: "#a78bfa"
  property color accent2: "#7c3aed"
  property color alert: "#ff4d6d"
  property color dim: Qt.rgba(fg.r, fg.g, fg.b, 0.55)
  property string font: "JetBrainsMono Nerd Font"

  FileView {
    path: Quickshell.env("HOME") + "/.cache/wal/colors.json"
    watchChanges: true
    onFileChanged: reload()
    onLoaded: {
      try {
        const j = JSON.parse(text())
        root.bg = j.special.background
        root.fg = j.special.foreground
        root.accent = j.colors.color5
        root.accent2 = j.colors.color4
      } catch (e) {}
    }
  }
}
