local wezterm = require("wezterm")
local keys = require("keys")
local tabs = require("tabbar")
local theme = require("theme")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

theme.apply_to_config(config)
keys.apply_to_config(config)
tabs.apply_to_config(config)

-- A plugin that integrates Neovim window and Wezterm pane navigation under a single keybind
-- Must be used with Neovim plugin
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
	},
})

return config
