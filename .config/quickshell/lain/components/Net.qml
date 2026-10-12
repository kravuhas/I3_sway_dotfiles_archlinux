pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: net
  property bool online: false
  property string kind: ""
  property string name: ""
  property int signal: 0
  property bool wifiOn: true
  property var nets: []

  function refresh() {
    if (!cur.running) cur.running = true
    if (!lst.running) lst.running = true
  }
  function connectTo(ssid) {
    Quickshell.execDetached(["kitty", "--class", "nm-float", "-e", "sh", "-c",
      "nmcli --ask dev wifi connect \"$1\"; sleep 2", "_", ssid])
    settle.restart()
  }
  function toggleWifi() { Quickshell.execDetached(["nmcli", "radio", "wifi", wifiOn ? "off" : "on"]); settle.restart() }
  function rescan() { Quickshell.execDetached(["nmcli", "dev", "wifi", "rescan"]); settle.restart() }

  Timer { id: settle; interval: 6000; onTriggered: net.refresh() }
  Timer { interval: 6000; repeat: true; running: true; triggeredOnStart: true; onTriggered: net.refresh() }

  Process {
    id: cur
    command: ["sh", "-c", "dev=$(ip -o route get 1.1.1.1 2>/dev/null | sed -n 's/.* dev \\([^ ]*\\).*/\\1/p'); if [ -z \"$dev\" ]; then echo 'none||'; else if [ -d /sys/class/net/$dev/wireless ]; then k=wifi; else k=wired; fi; n=$(nmcli -t -f DEVICE,CONNECTION dev status 2>/dev/null | grep \"^$dev:\" | cut -d: -f2-); echo \"$k|$n|$dev\"; fi; echo ---; nmcli radio wifi 2>/dev/null"]
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = text.split("---")
        const f = parts[0].trim().split("|")
        if (f[0] === "wifi" || f[0] === "wired") {
          net.kind = f[0]
          net.name = (f[1] && f[1] !== "--") ? f[1] : (f[0] === "wired" ? "cabo" : (f[2] || "wi-fi"))
        } else {
          net.kind = ""
          net.name = ""
        }
        net.online = net.kind !== ""
        net.wifiOn = parts.length > 1 && parts[1].trim() === "enabled"
      }
    }
  }

  Process {
    id: lst
    command: ["sh", "-c", "nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID dev wifi list --rescan no 2>/dev/null"]
    stdout: StdioCollector {
      onStreamFinished: {
        const out = []
        const seen = {}
        let sig = 0
        text.split("\n").forEach(line => {
          if (!line) return
          const f = line.split(":")
          if (f.length < 4) return
          const ssid = f.slice(3).join(":").replace(/\\:/g, ":")
          if (!ssid || seen[ssid]) return
          seen[ssid] = true
          const inUse = f[0] === "*"
          const strength = parseInt(f[1]) || 0
          if (inUse) sig = strength
          out.push({ ssid: ssid, signal: strength, secure: f[2] !== "" && f[2] !== "--", active: inUse })
        })
        out.sort((a, b) => b.signal - a.signal)
        net.nets = out
        net.signal = sig
      }
    }
  }
}
