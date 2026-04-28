return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
    keys = { { "<leader>zm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "phpcs",
        "goimports",
        "gofumpt",
        "staticcheck",
      },
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      -- "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require "cmp"
      local defaults = require "cmp.config.default"()

      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "snippets" },
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        preselect = cmp.PreselectMode.Item,
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          -- ["<C-Y>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
          ["<C-Y>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
        },
        formatting = {
          format = function(_, item)
            local icons = require "utils.icons"
            if icons.kind[item.kind] then
              item.kind = icons.kind[item.kind] .. " " .. item.kind
            end
            return item
          end,
        },
        sorting = defaults.sorting,
      }
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      vim.lsp.log.set_level "off"
      -- vim.lsp.log.set_level "debug"

      vim.diagnostic.config {
        signs = false,
        underline = true,
        virtual_text = false,
      }

      -- Keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
        end,
      })

      -- Default capabilities (with cmp-nvim-lsp)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configure the wildcard '*' to apply defaults to all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Server-specific overrides
      vim.lsp.config("html", {
        filetypes = { "html", "gotmpl" },
      })

      -- Let mason-lspconfig handle installing & enabling servers
      require("mason-lspconfig").setup {
        ensure_installed = {},
      }
    end,
  },
}
