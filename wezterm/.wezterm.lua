local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.colors = { background = "#1d2029", cursor_bg = "#bdbfbe", cursor_fg = "#212121" }
-- config.color_scheme = "nord"
config.color_scheme = "tokyonight"
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 13
config.line_height = 1.1

-- will manually check and download updates
config.check_for_updates = false

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

return config
