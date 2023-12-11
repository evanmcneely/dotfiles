return {
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    -- stylua: ignore
    config = function ()
      -- TODO: add to keys
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<S-Tab>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<C-a>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
      vim.keymap.set("i", "<C-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<C-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
    end,
  },
  {
    "evanmcneely/neural-hack",
    branch = "evan/main",
    event = "BufReadPost",
    keys = {
      { "<leader>an", "<cmd>Neural<cr>", desc = "Neural with selection", mode = { "n", "v" } },
      { "<leader>ab", "<cmd>NeuralWithBuffers<cr>", desc = "Neural with buffers", mode = "n" },
      { "<leader>ae", "<cmd>NeuralExplain<cr>", desc = "Neural explain", mode = "v" },
    },
    config = function()
      local icons = require "config.icons"
      require("neural").setup {
        ui = {
          prompt_icon = icons.misc.Robot,
          animated_sign_enabled = true,
        },
        selected = "chatgpt",
        source = {
          openai = {
            api_key = vim.env.OPENAI_API_KEY,
            max_tokens = 2048,
          },
        },
      }
    end,
  },
}
