hl.config({
	input = {
		kb_layout = "gb",
		follow_mouse = 1,
		sensitivity = 0,
		repeat_delay = 400,
		repeat_rate = 50,
		touchpad = {
			disable_while_typing = true,
		},
	},
	cursor = {
		default_monitor = "DP-1",
		persistent_warps = true,
		inactive_timeout = 10,
	},
})

hl.device({
	name = "logitech-g303-1",
	accel_profile = "flat",
	sensitivity = -0.2,
})

hl.device({
	name = "logitech-pro-x-2-1",
	accel_profile = "flat",
	sensitivity = -0.2,
})
