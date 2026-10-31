hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 2,
		col = {
			active_border = "rgba(782817ff)",
			inactive_border = "rgba(131314ff)",
		},

		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},
	hl.config({
		dwindle = {
			force_split = 2,
			smart_resizing = false,
			split_width_multiplier = 1.0,
			use_active_for_splits = true,
			default_split_ratio = 1.0,
			split_bias = 0,
		},
	}),

	decoration = {
		rounding = 0,
		active_opacity = 1,
		inactive_opacity = 1,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			ignore_opacity = true,
			size = 2,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
})
