local icons = require "config.icons"
local colors = require "config.colors"
local Job = require "plenary.job"
-- local noice_status = require("noice").api.status

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
    return ""
  end
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

return {
  spaces = {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
      return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
  },
  line = {
    function()
      return "|"
    end,
  },
  git_repo = {
    get_repo,
    icon = icons.git.Repo,
  },
  buffer = {
    "buffers",
    show_modified_status = false,
    mode = 3,
    icon = icons.ui.File,
  },
  filename = {
    "filename",
    file_status = false,
  },
  separator = {
    function()
      return "%="
    end,
  },
  gitsigns_root = { "b:gitsigns_status_dict.root" },
  gitsigns_status = { "b:gitsigns_status" },
  window = {
    function()
      return vim.api.nvim_win_get_number(0)
    end,
    icon = icons.ui.Window,
  },
  branch = {
    "branch",
    icon = icons.git.Branch,
  },
  codeium = {
    function()
      return vim.fn["codeium#GetStatusString"]()
    end,
    icon = icons.misc.Robot,
  },
  diff = {
    "diff",
    source = diff_source,
    colored = true,
    symbols = {
      added = "+",
      modified = "~",
      removed = "-",
    },
    diff_color = {
      added = { fg = colors.git.green },
      modified = { fg = colors.git.steal },
      removed = { fg = colors.git.red },
    },
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warning,
      info = icons.diagnostics.Information,
      hint = icons.diagnostics.Question,
    },
    colored = true,
  },
  lsp_client = {
    function(msg)
      msg = msg or ""
      local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }

      if next(buf_clients) == nil then
        if type(msg) == "boolean" or #msg == 0 then
          return ""
        end
        return msg
      end

      local buf_ft = vim.bo.filetype
      local buf_client_names = {}

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
          table.insert(buf_client_names, client.name)
        end
      end

      -- add formatter
      local lsp_utils = require "plugins.lsp.utils"
      local formatters = lsp_utils.list_formatters(buf_ft)
      vim.list_extend(buf_client_names, formatters)

      -- add linter
      local linters = lsp_utils.list_linters(buf_ft)
      vim.list_extend(buf_client_names, linters)

      -- add hover
      local hovers = lsp_utils.list_hovers(buf_ft)
      vim.list_extend(buf_client_names, hovers)

      -- add code action
      local code_actions = lsp_utils.list_code_actions(buf_ft)
      vim.list_extend(buf_client_names, code_actions)

      local hash = {}
      local client_names = {}
      for _, v in ipairs(buf_client_names) do
        if not hash[v] then
          client_names[#client_names + 1] = v
          hash[v] = true
        end
      end
      table.sort(client_names)
      return table.concat(client_names, ", ")
    end,
    colored = true,
    on_click = function()
      vim.cmd [[LspInfo]]
    end,
  },
}
