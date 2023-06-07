from libqtile.lazy import lazy
from libqtile.config import Key

mod = "mod4"
terminal = "alacritty_gl"
terminalb = "alacritty_gl_tmux"
browser = "flatpak run io.gitlab.librewolf-community"
editor = "emacsclient -c -a \"emacs\""

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "e", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "i", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "n", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    Key([mod], "slash", lazy.spawn("rofi -show combi"), desc="spawn rofi"),
    Key([mod, "control"], "e", lazy.spawn(editor), desc="spawn text editor"),
    Key([mod, "control"], "b", lazy.spawn(browser), desc="spawn web browser"),
    Key([mod], "t", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Return", lazy.spawn(terminalb), desc="Launch terminal to Tmux"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "e", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "i", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "n", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow(), desc="Grow window"),
    Key([mod, "control"], "n", lazy.layout.shrink(), desc="Shrink window"),
    Key([mod], "k", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Toggle between different layouts as defined below
    Key([mod], "m", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle between floating and tiled"),
    Key([mod, "shift", "control"], "h", lazy.layout.swap_column_left()),
    Key([mod, "shift", "control"], "i", lazy.layout.swap_column_right()),
    Key([mod, "shift"], "space", lazy.layout.flip()),
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([], "XF86AudioRaiseVolume",lazy.spawn("amixer set Master 3%+")),
    Key([], "XF86AudioLowerVolume",lazy.spawn("amixer set Master 3%-")),
    Key([], "XF86AudioMute",lazy.spawn("amixer set Master toggle")),
]
