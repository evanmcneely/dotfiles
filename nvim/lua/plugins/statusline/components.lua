local icons = require "config.icons"

local function get_repo()
  if vim.fn.trim(vim.fn.system "git rev-parse --is-inside-work-tree") == "true" then
    return vim.fn.trim(vim.fn.system "basename `git rev-parse --show-toplevel`")
  end
  return ""
end
-- CURRENT_GIT_REPO = get_repo()

local function get_root_dir()
  return vim.fn.finddir(".git/..", vim.fn.expand "%:r:t" .. ";")
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
  git_repo = {
    "CURRENT_GIT_REPO",
    icon = icons.git.Repo,
  },
  git_repo_exp = {
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
    -- path = 1,
    -- show_filename_only = true,
    file_status = false,
    -- hide_filename_extension = true,
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
  diff = {
    "diff",
    source = diff_source,
    colored = true,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    -- diagnostics_color = {
    -- error = "DiagnosticError",
    -- warn = "DiagnosticWarn",
    -- info = "DiagnosticInfo",
    -- hint = "DiagnosticHint",
    -- },
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
      return icons.ui.Code .. " " .. table.concat(client_names, ", ") .. " " .. icons.ui.Code
    end,
    -- icon = icons.ui.Code,
    colored = true,
    on_click = function()
      vim.cmd [[LspInfo]]
    end,
  },
}
