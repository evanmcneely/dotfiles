local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local M = {}

local fd = "/opt/homebrew/bin/fd"

local function format_workspace(name)
	return "󱂬 : " .. tostring(name)
end

M._cached_projects = nil

M.search = function(window, pane)
	local projects = {}
	if not M._cached_projects then
		local success, stdout, stderr = wezterm.run_child_process({
			fd,
			"-HI",
			"^.git$",
			"--max-depth=4",
			"--prune",
			os.getenv("HOME") .. "/dev",
			os.getenv("HOME") .. "/.dotfiles",
		})

		if not success then
			wezterm.log_error("Failed to run fd: " .. stderr)
			return
		end

		for line in stdout:gmatch("([^\n]*)\n?") do
			local project = line:gsub("/.git.*$", "")
			local label = project
			local id = project:gsub(".*/", "")
			table.insert(projects, { label = format_workspace(label), id = tostring(id) })
		end
		M._cached_projects = projects
	else
		projects = M._cached_projects
	end

	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(M._handle_selection),
			fuzzy = true,
			title = "Select project",
			fuzzy_description = "Search for project: ",
			choices = projects,
		}),
		pane
	)
end

M.switch = function(window, pane)
	local choices = {}
	for _, workspace in ipairs(mux.get_workspace_names()) do
		table.insert(choices, {
			id = workspace,
			label = wezterm.format({
				{ Text = format_workspace(workspace) },
			}),
		})
	end

	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(M._handle_selection),
			title = "Choose Workspace",
			fuzzy_description = "Choose a workspace: ",
			choices = choices,
			fuzzy = true,
		}),
		pane
	)
end

M._handle_selection = function(window, pane, id, label)
	if not id and not label then
		wezterm.log_info("Cancelled")
	else
		wezterm.log_info("Selected " .. label)
		M._switch_workspace(window, pane, id)
	end
end

M._switch_workspace = function(window, pane, workspace)
	local current_workspace = window:active_workspace()
	if current_workspace == workspace then
		return
	end

	window:perform_action(
		act.SwitchToWorkspace({
			name = workspace,
		}),
		pane
	)
	wezterm.GLOBAL.previous_workspace = current_workspace
end

M.previous = function(window, pane)
	local current_workspace = window:active_workspace()
	local workspace = wezterm.GLOBAL.previous_workspace

	if current_workspace == workspace or wezterm.GLOBAL.previous_workspace == nil then
		return
	end

	M._switch_workspace(window, pane, workspace)
end

return M
