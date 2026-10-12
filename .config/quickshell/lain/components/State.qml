pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire

Singleton {
  id: s
  property string popup: ""
  function toggle(n) { popup = (popup === n) ? "" : n }

  readonly property var player: {
    const v = Mpris.players.values
    for (let i = 0; i < v.length; i++) if (v[i].isPlaying) return v[i]
    return v.length > 0 ? v[0] : null
  }

  readonly property var sink: Pipewire.defaultAudioSink
  PwObjectTracker { objects: [ s.sink ] }
  readonly property real volume: (sink && sink.audio) ? sink.audio.volume : 0
  readonly property bool muted: (sink && sink.audio) ? sink.audio.muted : false
  function setVolume(v) { if (sink && sink.audio) sink.audio.volume = Math.max(0, Math.min(1, v)) }
  function toggleMute() { if (sink && sink.audio) sink.audio.muted = !sink.audio.muted }

  property real brightness: 0.5
  function setBrightness(v) {
    brightness = v
    Quickshell.execDetached(["brightnessctl", "set", Math.round(Math.max(0.05, v) * 100) + "%"])
  }
  Process {
    id: bp
    command: ["brightnessctl", "-m"]
    stdout: StdioCollector {
      onStreamFinished: {
        const f = text.trim().split(",")
        if (f.length > 3) s.brightness = parseInt(f[3]) / 100
      }
    }
  }
  Timer {
    interval: 2000; repeat: true; triggeredOnStart: true
    running: s.popup === "vol"
    onTriggered: if (!bp.running) bp.running = true
  }
}
