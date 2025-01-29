local wezterm = require("wezterm")
local theme = require("theme")

local M = {}

M.numbers = {
	{ active = "󰲠", inactive = "󰬺", tab = "󰎤" },
	{ active = "󰲢", inactive = "󰬻", tab = "󰎧" },
	{ active = "󰲤", inactive = "󰬼", tab = "󰎪" },
	{ active = "󰲦", inactive = "󰬽", tab = "󰎭" },
	{ active = "󰲨", inactive = "󰬾", tab = "󰎱" },
	{ active = "󰲪", inactive = "󰬿", tab = "󰎳" },
	{ active = "󰲬", inactive = "󰭀", tab = "󰎶" },
}

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
			tab_separators = { left = "", right = " " },
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
				{
					"index",
					fmt = function(str)
						return M.numbers[str].tab
					end,
				},
				" ",
				{ "process", padding = 0, icons_enabled = false },
			},
			tab_inactive = {
				{
					"index",
					fmt = function(str)
						return M.numbers[str].tab
					end,
				},
				" ",
				{ "process", padding = 0, icons_enabled = false },
			},
			tabline_x = {
				{ Background = { Color = theme.tab_background } },
				M.workspace_list_to_string,
				{ Foreground = { AnsiColor = "Red" } },
				"domain",
				{ Foreground = { AnsiColor = "Purple" } },
				"You're doing great! ",
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

M.workspace_list_to_string = function(win, _)
	-- Workspaces are added to the list in sessionizer
	local list = wezterm.GLOBAL.workspace_list
	if not list then
		return
	end

	local current_workspace = win:active_workspace()
	local max = #M.numbers
	local output = ""
	local count = 1
	for _, workspace in pairs(list) do
		local icon = M.numbers[count].inactive
		if wezterm.to_string(current_workspace) == wezterm.to_string(workspace) then
			icon = M.numbers[count].active
		end

		local workspace_name = wezterm.to_string(workspace):gsub('^"(.*)"$', "%1") -- strip surrounding quotations
		output = output .. " " .. icon .. " " .. workspace_name .. " "

		count = count + 1
		if count > max then
			break
		end
	end

	return output
end

return M
