return {
  -- open ai comlpetion
  {
    "jameshiew/nvim-magic",
    disabled = true,
    event = "BufReadPre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>ac", "<Plug>nvim-magic-append-completion", mode = "v", desc = "Completion" },
      { "<leader>aa", "<Plug>nvim-magic-suggest-alteration", mode = "v", desc = "Alteration" },
      { "<leader>ad", "<Plug>nvim-magic-suggest-docstring", mode = "v", desc = "Docstring" },
    },
    config = function()
      require("nvim-magic").setup {
        use_default_keymap = false,
      }
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup {
        welcome_message = "",
        openai_params = {
          -- model = "text-davinci-003",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 300,
          temperature = 0.7,
          top_p = 1,
          n = 1,
        },
        openai_edit_params = {
          model = "code-davinci-edit-001",
          temperature = 0,
          top_p = 1,
          n = 1,
        },
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>ag", "<cmd>ChatGPT<cr>", desc = "GPT chat" },
      { "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", desc = "GPT edit" },
    },
  },
  {
    -- copilot in cmp menu
    {
      "zbirenbaum/copilot-cmp",
      event = "InsertEnter",
      enabled = false,
      config = function()
        require("copilot_cmp").setup()
      end,
      dependencies = {
        "zbirenbaum/copilot.lua",
        config = function()
          vim.schedule(function()
            require("copilot").setup()
          end)
        end,
      },
    },
  },
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    -- enabled = false,
    -- stylua: ignore
    config = function ()
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<C-;>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<C-a>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
      vim.keymap.set("i", "<C-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<C-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
    end,
  },
}
