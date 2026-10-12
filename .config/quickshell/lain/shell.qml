import Quickshell
import "components"

ShellRoot {
  Variants {
    model: Quickshell.screens
    Scope {
      id: sc
      required property var modelData
      Bar { screen: sc.modelData }
      MusicPanel { screen: sc.modelData }
      NetPanel { screen: sc.modelData }
      VolPanel { screen: sc.modelData }
    }
  }
}
