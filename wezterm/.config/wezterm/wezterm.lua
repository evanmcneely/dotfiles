local wezterm = require("wezterm")
local sessionizer = require("sessionizer")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "tokyonight_night"
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 13
config.line_height = 1.4

config.window_decorations = "RESIZE"
config.max_fps = 120

-- Explicitly set padding around the terminal
config.window_padding = {
	left = 10,
	right = 10,
	top = 20,
	bottom = 10, -- Set a lower bottom padding so the Neovim status line appears at the bottom
}

-- Use CTRL-b as the leader key because I came from tmux
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
-- stylua: ignore
config.keys = {
	-- Search projects and launch new workspace
	{ key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.toggle) },
  -- List all current workspaces
	{ key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  -- Close the current pane
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
  -- Create pane in "vertical" split
  { key = '%', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- Create pane in "horizontal" split
  { key = '"', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
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
}

-- A tabbar plugin
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config, {
	modules = {
		pane = { color = 2 }, -- Override to use Tokyonight theme red
		leader = { enabled = false },
		hostname = { enabled = false },
		cwd = { enabled = false },
	},
})
-- Override default tabbar theme colors
config.colors.tab_bar.background = "#24283b" -- Tokyonight storm background color
config.show_new_tab_button_in_tab_bar = false
config.colors.tab_bar.active_tab.bg_color = config.colors.tab_bar.background
config.colors.tab_bar.active_tab.fg_color = "#7aa2f7" -- Tokyonight function blue color
config.colors.tab_bar.inactive_tab.bg_color = config.colors.tab_bar.background

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
