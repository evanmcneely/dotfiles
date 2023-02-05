local M = {}

local Terminal = require("toggleterm.terminal").Terminal

-- Docker
local docker_tui = "lazydocker"

local docker_client = Terminal:new {
  cmd = docker_tui,
  dir = "git_dir",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
}

function M.docker_client_toggle()
  docker_client:toggle()
end

-- navi
local navi = "navi fn welcome"

local interactive_cheatsheet = Terminal:new {
  cmd = navi,
  dir = "git_dir",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
  close_on_exit = true,
}

function M.interactive_cheatsheet_toggle()
  interactive_cheatsheet:toggle()
end

return M
