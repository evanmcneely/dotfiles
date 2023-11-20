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

local lazygit = "lazygit"

local lazygit_term = Terminal:new {
  cmd = lazygit,
  dir = "git_dir",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
  close_on_exit = true,
}

function M.lazygit_toggle()
  lazygit_term:toggle()
end

return M
