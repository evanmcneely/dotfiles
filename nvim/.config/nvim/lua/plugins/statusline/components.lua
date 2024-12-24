local icons = require "utils.icons"
local colors = require("tokyonight.colors").setup()

return {
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
      added = { fg = colors.git.add },
      modified = { fg = colors.git.change },
      removed = { fg = colors.git.delete },
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
  filename = {
    "filename",
    file_status = false,
    path = 3,
    padding = { left = 1, right = 0 },
  },
  diagnostics = {
    "diagnostics",
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warning,
      info = icons.diagnostics.Information,
      hint = icons.diagnostics.Information,
    },
    diagnostic_color = {
      error = colors.red,
      warn = colors.yellow,
      hint = colors.green,
      info = colors.blue,
    },
  },
  noice_command = {
    function()
      return require("noice").api.status.command.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.command.has()
    end,
    color = { fg = colors.magenta },
  },
  noice_mode = {
    function()
      return require("noice").api.status.mode.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.mode.has()
    end,
    color = { fg = colors.orange },
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
        n = colors.blue,
        i = colors.green,
        v = colors.magenta,
        [""] = colors.magenta,
        V = colors.magenta,
        c = colors.magenta2,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.magenta,
        Rv = colors.magenta,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
  },
}
