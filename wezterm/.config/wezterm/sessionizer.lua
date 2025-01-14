local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local M = {}

local fd = "/opt/homebrew/bin/fd"

M._cached_projects = nil

M.search = function(win, pane)
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
			table.insert(projects, { label = label, id = tostring(id) })
		end
		M._cached_projects = projects
	else
		projects = M._cached_projects
	end

	win:perform_action(
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

M.switch = function(win, pane)
	local choices = {}
	for _, workspace in ipairs(mux.get_workspace_names()) do
		table.insert(choices, {
			id = workspace,
			label = wezterm.format({
				{ Text = workspace },
			}),
		})
	end

	win:perform_action(
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

M._handle_selection = function(win, pane, id, label)
	if not id and not label then
		wezterm.log_info("Cancelled")
	else
		wezterm.log_info("Selected " .. label)
		M._switch_workspace(win, pane, id, label)
	end
end

M._switch_workspace = function(win, pane, id, label)
	local current_workspace = win:active_workspace()
	if current_workspace == id then
		return
	end

	win:perform_action(
		act.SwitchToWorkspace({
			name = id,
			spawn = { cwd = label },
		}),
		pane
	)
	wezterm.GLOBAL.previous_workspace = current_workspace
end

M.previous = function(win, pane)
	local current_workspace = win:active_workspace()
	local workspace = wezterm.GLOBAL.previous_workspace

	if
		wezterm.to_string(current_workspace) == wezterm.to_string(workspace)
		or wezterm.GLOBAL.previous_workspace == nil
	then
		return
	end

	M._switch_workspace(win, pane, workspace)
end

M.list_add = function(win, _)
	if not wezterm.GLOBAL.workspace_list then
		wezterm.GLOBAL.workspace_list = {}
	end

	local list = wezterm.GLOBAL.workspace_list
	local current_workspace = win:active_workspace()
	for _, workspace in pairs(list) do
		if wezterm.to_string(workspace) == wezterm.to_string(current_workspace) then
			return -- workspace is already added
		end
	end

	list[tostring(#list + 1)] = current_workspace
end

M.list_remove = function(win, _)
	local list = wezterm.GLOBAL.workspace_list
	if not list then
		return
	end

	local current_workspace = win:active_workspace()
	local new_list = {}
	local index = 1
	for _, workspace in list do
		if wezterm.to_string(workspace) ~= wezterm.to_string(current_workspace) then
			new_list[tostring(index)] = workspace
			index = index + 1
		end
	end

	wezterm.GLOBAL.workspace_list = new_list
end

M.list_clear = function(_, _)
	wezterm.GLOBAL.workspace_list = {}
end

M.list_goto = function(index)
	return wezterm.action_callback(function(win, pane)
		local list = wezterm.GLOBAL.workspace_list
		if not list then
			return
		end

		local target_workspace = list[tostring(index)]
		if not target_workspace then
			return
		end
		M._switch_workspace(win, pane, target_workspace)
	end)
end

return M
