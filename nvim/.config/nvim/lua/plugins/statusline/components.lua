local icons = require "utils.icons"
local Job = require "plenary.job"
local colors = require("tokyonight.colors").setup()

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
    return "?"
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
  pretty_path = {
    function()
      -- modified and simplified from LazyVim pretty path
      local path = vim.fn.expand "%:p"
      local repo = get_repo()
      local cwd = vim.loop.cwd()

      if path == "" then
        return repo .. "/?"
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
  filename = {
    "filetype",
    icons_enabled = false,
  },
  diagnostics = {
    "diagnostics",
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
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
  debug_status = {
    function()
      return "  " .. require("dap").status()
    end,
    cond = function()
      return package.loaded["dap"] and require("dap").status() ~= ""
    end,
    color = { fg = colors.green },
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
