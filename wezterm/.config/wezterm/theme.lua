local wezterm = require("wezterm")

local M = {}

M.theme = "tokyonight"
M.tab_background = "#24283b" -- Tokyonight storm background color

M.apply_to_config = function(config)
	config.color_scheme = M.theme
	config.font = wezterm.font("DepartureMono Nerd Font")
	config.font_size = 12
	config.line_height = 1.4

	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.max_fps = 120
	config.window_padding = {
		left = 10,
		right = 10,
		top = 30,
		bottom = 0,
	}
end

return M
