local wezterm = require("wezterm")
local sessionizer = require("sessionizer")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "tokyonight"
config.font = wezterm.font("DepartureMono Nerd Font")
config.font_size = 13
config.line_height = 1.4

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.max_fps = 120
config.window_padding = {
	left = 10,
	right = 10,
	top = 40,
	bottom = 0,
}

-- Use CTRL-b as the leader key because I came from tmux
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
-- stylua: ignore
config.keys = {
	-- Search projects and launch new workspace
	{ key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.search) },
  -- List all current workspaces
  { key = "s", mods = "LEADER", action = wezterm.action_callback(sessionizer.switch)},
  -- Switch to previous workspace
  { key = "S", mods = "LEADER", action = wezterm.action_callback(sessionizer.previous) },
  -- Close the current pane
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
  -- Create pane in "vertical" split
  { key = '"', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- Create pane in "horizontal" split
  { key = '%', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- Create new tab
  { key = 't', mods = 'LEADER', action = wezterm.action.SpawnTab('CurrentPaneDomain') },
  -- Cycle tab right (next)
  { key = 'n', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
  -- Cycle tab left (previous)
  { key = 'p', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },
  -- Activate copy mode
  { key = 'c', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
  -- Open command palette
  { key = ':', mods = 'LEADER', action = wezterm.action.ActivateCommandPalette },
  -- Show debug overlay
  { key = 'D', mods = 'LEADER', action = wezterm.action.ShowDebugOverlay },
  -- Quick session switching
  { key = 'l', mods = 'LEADER', action = wezterm.action_callback(sessionizer.list_add) },
  { key = 'L', mods = 'LEADER', action = wezterm.action_callback(sessionizer.list_remove) },
  { key = 'X', mods = 'LEADER', action = wezterm.action_callback(sessionizer.list_clear) },
  { key = '1', mods = 'LEADER', action = sessionizer.list_goto(1) },
  { key = '2', mods = 'LEADER', action = sessionizer.list_goto(2) },
  { key = '3', mods = 'LEADER', action = sessionizer.list_goto(3) },
  { key = '4', mods = 'LEADER', action = sessionizer.list_goto(4) },
  { key = '5', mods = 'LEADER', action = sessionizer.list_goto(5) },
  { key = '+', mods = 'LEADER', action = sessionizer.list_goto(1) },
  { key = '[', mods = 'LEADER', action = sessionizer.list_goto(2) },
  { key = '{', mods = 'LEADER', action = sessionizer.list_goto(3) },
  { key = '(', mods = 'LEADER', action = sessionizer.list_goto(4) },
  { key = '&', mods = 'LEADER', action = sessionizer.list_goto(5) },
}

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local tab_background = "#24283b" -- Tokyonight storm background color
tabline.setup({
	options = {
		icons_enabled = true,
		theme = "tokyonight",
		tabs_enabled = true,
		color_overrides = {
			tab = {
				active = { bg = tab_background },
				inactive = { bg = tab_background },
				inactive_hover = { bg = tab_background },
			},
		},
		section_separators = { left = "", right = "" },
		component_separators = { left = " ", right = " " },
		tab_separators = { left = "", right = "  " },
	},
	sections = {
		tabline_a = {},
		tabline_b = {},
		tabline_c = {
			{ Foreground = { AnsiColor = "Yellow" } },
			{ Background = { Color = tab_background } },
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
			{ Background = { Color = tab_background } },
			"You're doing great!      ",
			"ram",
			"cpu",
			"domain",
		},
		tabline_y = {},
		tabline_z = {},
	},
	extensions = {},
})
-- Override default tabbar theme colors and style
config.colors = {}
config.colors.tab_bar = {}
config.colors.tab_bar.background = tab_background
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32

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
