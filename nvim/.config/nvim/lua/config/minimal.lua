return {
  {
    "evanmcneely/enlighten.nvim",
    dir = "~/dev/personal/enlighten.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "\\e", function() require("enlighten").edit() end, desc = "Enlighten Edit", mode = { "n", "v" } },
      { "\\c", function() require("enlighten").chat() end, desc = "Enlighten Chat", mode = { "n", "v" } },
      { "\\y", function() require("enlighten").keep() end, mode = { "n", "v" } },
      { "\\Y", function() require("enlighten").keep_all() end,mode = { "n" } },
      { "\\n", function() require("enlighten").discard() end, mode = { "n", "v" } },
      { "\\N", function() require("enlighten").discard_all() end,mode = { "n" } },
      { "\\l", function() require("enlighten").logger:show() end, desc = "Enlighten Logs" },
      { "\\p", function() require("enlighten").picker:open() end },
    },
  },

    {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "VeryLazy",
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        mapping = cmp.mapping.preset.insert {
          ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ["<C-Y>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
        },
      }
    end,
  }
}
