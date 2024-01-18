local icons = require "utils.icons"
local Job = require "plenary.job"
local colors = require "nordic.colors"

local function apply_highlight(component, text)
  component.hl_cache = component.hl_cache or {}
  local hl = component.hl_cache["this_is_hack"]
  if not hl then
    hl = component:create_hl { fg = colors.blue1 }
    component.hl_cache["this_is_hack"] = hl
  end
  return component:format_hl(hl) .. text .. component:get_default_hl()
end

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
      added = { fg = colors.green.dim },
      modified = { fg = colors.cyan.dim },
      removed = { fg = colors.red.dim },
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
    function(self)
      -- modified and simplified from LazyVim pretty path
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
        parts = { "…", parts[#parts - 1], apply_highlight(self, parts[#parts]) }
      end
      -- join it all together
      return repo .. "/" .. table.concat(parts, "/")
    end,
  },
  filename = {
    "filetype",
    icons_enabled = false,
    -- color = { fg = colors.grey5 },
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
      error = colors.red.bright,
      warn = colors.yellow.bright,
      hint = colors.green.blue2,
      info = colors.blue3,
    },
  },
  noice_command = {
    function()
      return require("noice").api.status.command.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.command.has()
    end,
    color = { fg = colors.magenta.bright },
  },
  noice_mode = {
    function()
      return require("noice").api.status.mode.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.mode.has()
    end,
    color = { fg = colors.orange.bright },
  },
  debug_status = {
    function()
      return "  " .. require("dap").status()
    end,
    cond = function()
      return package.loaded["dap"] and require("dap").status() ~= ""
    end,
    color = { fg = colors.green.bright },
  },
  shift_width = {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
      return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
    -- color = { fg = colors.cyan.bright },
  },
  progress = { "progress" },
  location = { "location" },
  mode = {
    "mode",
    color = function()
      -- auto change color according to neovims mode
      local mode_color = {
        n = colors.blue1,
        i = colors.green.base,
        v = colors.magenta.base,
        [""] = colors.magenta.base,
        V = colors.magenta.base,
        c = colors.magenta.dim,
        no = colors.red.base,
        s = colors.orange.base,
        S = colors.orange.base,
        [""] = colors.orange.base,
        ic = colors.yellow.bese,
        R = colors.magenta.base,
        Rv = colors.magenta.base,
        cv = colors.red.base,
        ce = colors.red.base,
        r = colors.cyan.base,
        rm = colors.cyan.base,
        ["r?"] = colors.cyan.base,
        ["!"] = colors.red.base,
        t = colors.red.base,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
  },
}
