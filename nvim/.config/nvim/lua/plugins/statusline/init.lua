return {
  "nvim-lualine/lualine.nvim",
  -- do not start lualine in the browser
  enabled = not vim.g.started_by_firenvim,
  opts = function(_, opts)
    local components = require "plugins.statusline.components"

    -- override separators
    opts.options.component_separators = { left = "  ", right = "" }
    opts.options.section_separators = ""

    -- override lualine sections with custom statusline
    opts.sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        components.mode,
        components.branch,
        components.diff,
        components.filetype,
        components.pretty_path,
        components.diagnostics,
      },
      lualine_x = {
        components.noice_mode,
        components.noice_command,
        components.debug_status,
        components.shift_width,
        components.location,
        components.progress,
      },
      lualine_y = {},
      lualine_z = {},
    }
  end,
}
