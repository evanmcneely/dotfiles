local icons = require "utils.icons"
local colors = require "utils.colors"
local Job = require "plenary.job"
local Util = require "lazyvim.util"

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
      added = { fg = colors.tokyonight.gitSigns.add },
      modified = { fg = colors.tokyonight.gitSigns.change },
      removed = { fg = colors.tokyonight.gitSigns.delete },
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
  pretty_path = { Util.lualine.pretty_path(), separator = "" },
  diagnostics = {
    "diagnostics",
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    },
  },
  command = {
    function()
      return require("noice").api.status.command.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.command.has()
    end,
    color = Util.ui.fg "Statement",
  },
  debug_status = {
    function()
      return "  " .. require("dap").status()
    end,
    cond = function()
      return package.loaded["dap"] and require("dap").status() ~= ""
    end,
    color = Util.ui.fg "Debug",
  },
  shift_width = {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
      return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
  },
  progress = { "progress", separator = " ", padding = { left = 1, right = 0 } },
  location = { "location", padding = { left = 0, right = 1 } },
  mode = {
    "mode",
    color = function()
      -- auto change color according to neovims mode
      local mode_color = {
        n = colors.tokyonight.red,
        i = colors.tokyonight.green,
        v = colors.tokyonight.blue,
        [""] = colors.tokyonight.blue,
        V = colors.tokyonight.blue,
        c = colors.tokyonight.magenta,
        no = colors.tokyonight.red,
        s = colors.tokyonight.orange,
        S = colors.tokyonight.orange,
        [""] = colors.tokyonight.orange,
        ic = colors.tokyonight.yellow,
        R = colors.tokyonight.violet,
        Rv = colors.tokyonight.violet,
        cv = colors.tokyonight.red,
        ce = colors.tokyonight.red,
        r = colors.tokyonight.cyan,
        rm = colors.tokyonight.cyan,
        ["r?"] = colors.tokyonight.cyan,
        ["!"] = colors.tokyonight.red,
        t = colors.tokyonight.red,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
  },
}
