local wezterm = require("wezterm")
local sessionizer = require("sessionizer")

local M = {}

M.apply_to_config = function(config)
	-- Use CTRL-b as the leader key because I came from tmux
	config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
  -- stylua: ignore
  config.keys = {
    -- Search projects and launch new workspace
    { key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.search_and_create_workspace) },
    -- List all current workspaces
    { key = "s", mods = "LEADER", action = wezterm.action_callback(sessionizer.switch_workspace)},
    -- Switch to previous workspace
    { key = "S", mods = "LEADER", action = wezterm.action_callback(sessionizer.goto_previous_workspace) },
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
    { key = 'l', mods = 'LEADER', action = wezterm.action_callback(sessionizer.add_current_workspace_to_list) },
    { key = 'L', mods = 'LEADER', action = wezterm.action_callback(sessionizer.remove_current_workspace_from_list) },
    { key = 'X', mods = 'LEADER', action = wezterm.action_callback(sessionizer.clear_workspace_list) },
    { key = '1', mods = 'LEADER', action = sessionizer.goto_workspace(1) },
    { key = '2', mods = 'LEADER', action = sessionizer.goto_workspace(2) },
    { key = '3', mods = 'LEADER', action = sessionizer.goto_workspace(3) },
    { key = '4', mods = 'LEADER', action = sessionizer.goto_workspace(4) },
    { key = '5', mods = 'LEADER', action = sessionizer.goto_workspace(5) },
    { key = '+', mods = 'LEADER', action = sessionizer.goto_workspace(1) },
    { key = '[', mods = 'LEADER', action = sessionizer.goto_workspace(2) },
    { key = '{', mods = 'LEADER', action = sessionizer.goto_workspace(3) },
    { key = '(', mods = 'LEADER', action = sessionizer.goto_workspace(4) },
    { key = '&', mods = 'LEADER', action = sessionizer.goto_workspace(5) },
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    { key = "LeftArrow", mods = "OPT", action=wezterm.action { SendString = "\x1bb" } },
    -- Make Option-Right equivalent to Alt-f; forward-word
    { key = "RightArrow", mods = "OPT", action=wezterm.action { SendString = "\x1bf" } },
    -- Make Option-Down go to start
    { key = "DownArrow", mods = "OPT", action = wezterm.action{ SendString = "\x01" } },
    -- Make Option-Up go to end
    { key = "UpArrow", mods = "OPT", action = wezterm.action { SendString = "\x05" } },
  }
end

return M
