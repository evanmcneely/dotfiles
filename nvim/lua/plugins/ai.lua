return {
  {
    "jackMort/ChatGPT.nvim",
    -- enabled = false,
    config = function()
      require("chatgpt").setup {
        welcome_message = "",
        openai_params = {
          model = "gpt-4",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4000,
          temperature = 0.5,
          top_p = 1,
          n = 1,
        },
        openai_edit_params = {
          model = "code-davinci-edit-001",
          temperature = 0.5,
          top_p = 1,
          n = 1,
        },
        keymaps = {
          close = { "<C-c>" },
          submit = "<C-Enter>",
          yank_last = "<C-y>",
          yank_last_code = "<C-k>",
          scroll_up = "<C-u>",
          scroll_down = "<C-d>",
          toggle_settings = "<C-o>",
          new_session = "<C-n>",
          cycle_windows = "<Tab>",
          -- in the Sessions pane
          select_session = "<Space>",
          rename_session = "r",
          delete_session = "d",
        },
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>ac", "<cmd>ChatGPT<cr>", desc = "GPT chat" },
      { "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", desc = "GPT edit" },
    },
  },
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    -- stylua: ignore
    config = function ()
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<S-Tab>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<C-a>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
      vim.keymap.set("i", "<C-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<C-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
    end,
  },
  {
    -- "dense-analysis/neural",
    dir = "~/dev/neural-hack",
    event = "BufReadPost",
    keys = {
      { "<leader>an", "<cmd>Neural<cr>", desc = "Neural with selection", mode = { "n", "v" } },
      { "<leader>ab", "<cmd>NeuralWithBuffers<cr>", desc = "Neural with buffers", mode = "n" },
    },
    config = function()
      local icons = require "config.icons"
      require("neural").setup {
        ui = {
          prompt_icon = icons.misc.Robot,
          animated_sign_enabled = true,
        },
        -- pre_process = false,
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
