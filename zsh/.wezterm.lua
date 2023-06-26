local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "tokyonight_night"
-- config.font_size = 12.0
config.line_height = 1.2

-- config.keys = {
-- 	{ key = "{", mods = "CTR", action = act.ActivateTabRelative(-1) },
-- 	{ key = "}", mods = "CTR", action = act.ActivateTabRelative(1) },
-- }

return config
