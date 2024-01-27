local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.colors = { background = "#1d2029", cursor_bg = "#bdbfbe", cursor_fg = "#212121" }
-- config.color_scheme = "Night Owl (Gogh)"
-- config.color_scheme = "nord"
config.color_scheme = "tokyonight"
config.font = wezterm.font("Fira Code")
config.font_size = 14
config.line_height = 1.3

config.keys = {
	-- { key = "LeftArrow", mods = "CMD", action = act.ActivateTabRelative(-1) },
	-- { key = "RightArrow", mods = "CMD", action = act.ActivateTabRelative(1) },
}

-- will manually check and download updates
config.check_for_updates = false

config.window_decorations = "RESIZE"
-- config.use_dead_keys = false
config.enable_tab_bar = false

return config
