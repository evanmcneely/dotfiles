local wezterm = require("wezterm")
local sessionizer = require("sessionizer")
local theme = require("theme")

local M = {}

M.apply_to_config = function(config)
	local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
	tabline.setup({
		options = {
			icons_enabled = true,
			theme = theme.theme,
			tabs_enabled = true,
			color_overrides = {
				tab = {
					active = { bg = theme.tab_background },
					inactive = { bg = theme.tab_background },
					inactive_hover = { bg = theme.tab_background },
				},
			},
			section_separators = { left = "", right = "" },
			component_separators = { left = " ", right = "  " },
			tab_separators = { left = "", right = "  " },
		},
		sections = {
			tabline_a = {},
			tabline_b = {},
			tabline_c = {
				{ Foreground = { AnsiColor = "Yellow" } },
				{ Background = { Color = theme.tab_background } },
				"workspace",
			},
			tab_active = {
				"index",
				"- ",
				{ "process", padding = 0, icons_enabled = false },
			},
			tab_inactive = {
				"index",
				"- ",
				{ "process", padding = 0, icons_enabled = false },
			},
			tabline_x = {
				{ Background = { Color = theme.tab_background } },
				sessionizer.workspace_list_to_string,
				"domain",
				{ Foreground = { AnsiColor = "Purple" } },
				"You're doing great!",
			},
			tabline_y = {},
			tabline_z = {},
		},
		extensions = {},
	})
	-- Override default tabbar theme colors and style
	config.colors = {}
	config.colors.tab_bar = {}
	config.colors.tab_bar.background = theme.tab_background
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = true
	config.show_new_tab_button_in_tab_bar = false
	config.tab_max_width = 32
end

return M
