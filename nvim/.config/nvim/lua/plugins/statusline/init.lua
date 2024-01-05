return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local components = require "plugins.statusline.components"

    opts.options.component_separators = " "
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
        components.command,
        components.debug_status,
        components.shift_width,
        components.progress,
        components.location,
      },
      lualine_y = {},
      lualine_z = {},
    }
  end,
}
