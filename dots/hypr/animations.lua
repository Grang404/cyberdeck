hl.config({
	animations = {
		enabled = true,
	},
})

hl.curve("snap", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.08 } } })
hl.curve("jolt", { type = "bezier", points = { { 0.7, 0 }, { 0.84, 0 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.5, bezier = "snap", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "jolt", style = "gnomed" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "snap" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 0.5, bezier = "linear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 0.5, bezier = "linear" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "snap", style = "popin 90%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 0.5, bezier = "jolt", style = "fade" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.5, bezier = "linear" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.5, bezier = "linear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "snap", style = "slidefadevert 15%" })
hl.animation({ leaf = "border", enabled = true, speed = 1.5, bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 60, bezier = "linear", style = "loop" })
