local home = os.getenv("HOME")
hl.on("hyprland.start", function()
	-- hl.exec_cmd("waybar -c " .. home .. "/.local/share/groobarchy/dots/waybar/config-" .. profile .. ".jsonc")
	-- hl.exec_cmd("hypridle")
	hl.exec_cmd("awww-daemon")
	-- hl.exec_cmd("systemctl --user start hyprpolkitagent")
	-- hl.exec_cmd(
	-- 	"systemctl --user start --job-mode=ignore-dependencies xdg-desktop-portal.service xdg-desktop-portal-hyprland.service"
	-- )
end)
