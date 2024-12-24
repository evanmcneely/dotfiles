local wezterm = require("wezterm")
local sessionizer = require("sessionizer")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "tokyonight"
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 13
config.line_height = 1.4

config.window_decorations = "RESIZE"
config.max_fps = 120

-- Explicitly set padding around the terminal
config.window_padding = {
	left = 20,
	right = 20,
	top = 20,
	bottom = 10, -- Set a lower bottom padding so the Neovim status line appears at the bottom
}

-- Use CTRL-b as the leader key because I came from tmux
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 500 }
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
}

smart_splits.apply_to_config(config, {
	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})

return config
