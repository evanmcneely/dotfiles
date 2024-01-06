local icons = require "utils.icons"
local Job = require "plenary.job"
local tokyonight = require("tokyonight.colors").default

-- async get the git repo the current file is in
local function get_repo()
  local results = {}
  local job = Job:new {
    command = "git",
    args = { "rev-parse", "--show-toplevel" },
    cwd = vim.fn.expand "%:p:h",
    on_stdout = function(_, line)
      table.insert(results, line)
    end,
  }
  job:sync()
  if results[1] ~= nil then
    return vim.fn.fnamemodify(results[1], ":t")
  else
    return "no git"
  end
end

return {
  repo = {
    get_repo,
    icon = icons.git.Repo,
  },
  branch = {
    "branch",
    separator = "",
  },
  diff = {
    "diff",
    symbols = {
      added = icons.git.added,
      modified = icons.git.modified,
      removed = icons.git.removed,
    },
    diff_color = {
      added = { fg = tokyonight.git.add },
      modified = { fg = tokyonight.git.change },
      removed = { fg = tokyonight.git.delete },
    },
    source = function()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end,
    draw_empty = true,
  },
  filetype = { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
  pretty_path = {
    function()
      -- modified and simplfied from LazyVim pretty path
      local path = vim.fn.expand "%:p"
      local repo = get_repo()
      local cwd = vim.loop.cwd()

      if repo == "no git" then
        repo = ""
      end

      if path == "" then
        return "…?"
      end

      -- path from cwd split into table
      path = path:sub(#cwd + 2)
      local parts = vim.split(path, "[\\/]")
      -- use only the last two parts of the path if it is long
      if #parts >= 3 then
        parts = { "…", parts[#parts - 1], parts[#parts] }
      end
      -- join it all together
      return repo .. "/" .. table.concat(parts, "/")
    end,
  },
  diagnostics = {
    "diagnostics",
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    },
  },
  noice_command = {
    function()
      return require("noice").api.status.command.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.command.has()
    end,
    color = { fg = tokyonight.magenta },
  },
  noice_mode = {
    function()
      return require("noice").api.status.mode.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.mode.has()
    end,
    color = { fg = tokyonight.orange },
  },
  debug_status = {
    function()
      return "  " .. require("dap").status()
    end,
    cond = function()
      return package.loaded["dap"] and require("dap").status() ~= ""
    end,
    color = { fg = tokyonight.green },
  },
  shift_width = {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
      return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
  },
  progress = { "progress" },
  location = { "location" },
  mode = {
    "mode",
    color = function()
      -- auto change color according to neovims mode
      local mode_color = {
        n = tokyonight.blue,
        i = tokyonight.green,
        v = tokyonight.purple,
        [""] = tokyonight.purple,
        V = tokyonight.purple,
        c = tokyonight.magenta,
        no = tokyonight.red,
        s = tokyonight.orange,
        S = tokyonight.orange,
        [""] = tokyonight.orange,
        ic = tokyonight.yellow,
        R = tokyonight.purple,
        Rv = tokyonight.purple,
        cv = tokyonight.red,
        ce = tokyonight.red,
        r = tokyonight.cyan,
        rm = tokyonight.cyan,
        ["r?"] = tokyonight.cyan,
        ["!"] = tokyonight.red,
        t = tokyonight.red,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
  },
}
