local terminal = "ghostty"
local browser = "firefox"
local hyprshot_region = "hyprshot -s -m region --clipboard-only"
local hyprshot_file = "hyprshot -m region"

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal)) -- Terminal
hl.bind("SUPER + CONTROL + RETURN", hl.dsp.exec_cmd("groob-cwd")) -- CWD Terminal
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser)) -- Browser
hl.bind("SUPER + R", hl.dsp.exec_cmd("rofi -show drun")) -- App Menu
hl.bind("SUPER + W", hl.dsp.exec_cmd("groob-windows")) -- App Menu
hl.bind("SUPER + X", hl.dsp.exec_cmd("groob-keybinds")) -- Keybinds
hl.bind("SUPER + I", hl.dsp.exec_cmd("groob-wallpaper")) -- Wallpaper Picker
hl.bind("SUPER + ALT + I", hl.dsp.exec_cmd("groob-randompaper")) -- Random Wallpaper
hl.bind("SUPER + P", hl.dsp.exec_cmd(hyprshot_region)) -- Screenshot Region
hl.bind("CONTROL + SUPER + P", hl.dsp.exec_cmd(hyprshot_file)) -- Screenshot File
-- TODO: Add Full screenshot
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock")) -- Lock Screen
hl.bind("CONTROL + ALT + X", hl.dsp.exec_cmd("hyprpicker -a")) -- Color Picker

-- Workspaces

hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic")) -- Spoopy magic workspace
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" })) -- Move to Spoopyspace

-- Window Manipulation

hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" })) -- Toggle Floating
hl.bind("SUPER + D", hl.dsp.layout("togglesplit")) -- Toggle Split
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = 0, action = "toggle" })) -- Toggle Fullsreen
hl.bind("SUPER + M", hl.dsp.window.fullscreen({ mode = 1, action = "toggle" })) -- Maximise Window
hl.bind("SUPER + T", hl.dsp.window.alter_zorder({ mode = "top" })) -- Move Floating Window to Top
hl.bind("SUPER + C", hl.dsp.window.close()) -- Close Window

-- Navigate Windows

hl.bind("CONTROL + J", hl.dsp.focus({ direction = "left" })) -- Move Focus Left
hl.bind("CONTROL + K", hl.dsp.focus({ direction = "right" })) -- Move Focus Right
hl.bind("CONTROL + H", hl.dsp.focus({ direction = "up" })) -- Move Focus Up
hl.bind("CONTROL + L", hl.dsp.exec_cmd("groob-ctrl-l"))

-- Move Windows
hl.bind("CONTROL + SHIFT + J", hl.dsp.window.move({ direction = "left" })) -- Move Window Left
hl.bind("CONTROL + SHIFT + K", hl.dsp.window.move({ direction = "right" })) -- Move Window Right
hl.bind("CONTROL + SHIFT + H", hl.dsp.window.move({ direction = "up" })) -- Move Window Up
hl.bind("CONTROL + SHIFT + L", hl.dsp.window.move({ direction = "down" })) -- Move Window Down

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Drag Window
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Resize Window

-- KEYBIND: Volume Up
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
-- KEYBIND: Volume Down
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
-- KEYBIND: Mute
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
-- KEYBIND: Mute Mic
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
