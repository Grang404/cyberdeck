-- KEYBIND: CONTROL + 1-5 → Focus Workspace 1-5
-- KEYBIND: ALT + 1-5 → Focus Workspace 6-10
-- KEYBIND: SUPER + K → Focus Workspace uwu
-- KEYBIND: CONTROL + SHIFT + 1-5 → Move Window to Workspace 1-5
-- KEYBIND: ALT + SHIFT + 1-5 → Move Window to Workspace 6-10
-- KEYBIND: CONTROL + SUPER + K → Move Window to Workspace uwu
-- KEYBINDS_SKIP_START
for i = 1, 5 do
	hl.bind("CONTROL + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind("ALT + " .. i, hl.dsp.focus({ workspace = i + 5 }))
	hl.bind("CONTROL + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
	hl.bind("ALT + SHIFT + " .. i, hl.dsp.window.move({ workspace = i + 5 }))
end

for i = 6, 9 do
	local ws = i + 5
	hl.bind("CONTROL + " .. i, hl.dsp.focus({ workspace = ws }))
	hl.bind("ALT + " .. i, hl.dsp.focus({ workspace = ws + 5 }))
	hl.bind("CONTROL + SHIFT + " .. i, hl.dsp.window.move({ workspace = ws }))
	hl.bind("ALT + SHIFT + " .. i, hl.dsp.window.move({ workspace = ws + 5 }))
end

hl.bind("SUPER + K", hl.dsp.focus({ workspace = "name:uwu" }))
hl.bind("CONTROL + SUPER + K", hl.dsp.window.move({ workspace = "name:uwu" }))

for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1" })
	hl.workspace_rule({ workspace = tostring(i + 5), monitor = "DP-2" })
end

for i = 11, 14 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1" })
	hl.workspace_rule({ workspace = tostring(i + 5), monitor = "DP-2" })
end
-- KEYBINDS_SKIP_END
