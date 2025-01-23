return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v4.x",
    lazy = true,
    config = false,
  },

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
      "hrsh7th/cmp-buffer",
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
      local lsp_zero = require "lsp-zero"
      local icons = require "utils.icons"

      -- lsp_attach is where you enable features that only work
      -- if there is a language server active in the file
      local lsp_attach = function(_, bufnr)
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

        vim.diagnostic.config {
          signs = false,
          underline = true,
        }
      end

      lsp_zero.extend_lspconfig {
        sign_text = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warning,
          hint = icons.diagnostics.Information,
          info = icons.diagnostics.Information,
        },
        lsp_attach = lsp_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }

      vim.lsp.set_log_level("off")
      -- vim.lsp.set_log_level("debug")

      require("lspconfig").html.setup {
        filetypes = { "html", "gotmpl" },
      }

      require("mason-lspconfig").setup {
        ensure_installed = {},
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require("lspconfig")[server_name].setup {}
          end,
        },
      }
    end,
  },
}

-- old PHP config
-- {
--   "neovim/nvim-lspconfig",
--   opts = {
--     servers = {
--       intelephense = {
--         files = {
--           maxSize = 5000000,
--         },
--         stubs = {
--           "wordpress",
--           "wordpress-tests",
--           "apache",
--           "bcmath",
--           "bz2",
--           "calendar",
--           "com_dotnet",
--           "Core",
--           "ctype",
--           "curl",
--           "date",
--           "dba",
--           "dom",
--           "enchant",
--           "exif",
--           "FFI",
--           "fileinfo",
--           "filter",
--           "fpm",
--           "ftp",
--           "gd",
--           "gettext",
--           "gmp",
--           "hash",
--           "iconv",
--           "imap",
--           "intl",
--           "json",
--           "ldap",
--           "libxml",
--           "mbstring",
--           "meta",
--           "mysqli",
--           "oci8",
--           "odbc",
--           "openssl",
--           "pcntl",
--           "pcre",
--           "PDO",
--           "pdo_ibm",
--           "pdo_mysql",
--           "pdo_pgsql",
--           "pdo_sqlite",
--           "pgsql",
--           "Phar",
--           "posix",
--           "pspell",
--           "random",
--           "readline",
--           "Reflection",
--           "session",
--           "shmop",
--           "SimpleXML",
--           "snmp",
--           "soap",
--           "sockets",
--           "sodium",
--           "SPL",
--           "sqlite3",
--           "standard",
--           "superglobals",
--           "sysvmsg",
--           "sysvsem",
--           "sysvshm",
--           "tidy",
--           "tokenizer",
--           "xml",
--           "xmlreader",
--           "xmlrpc",
--           "xmlwriter",
--           "xsl",
--           "Zend OPcache",
--           "zip",
--           "zlib",
--         },
--       },
--     },
--   },
-- },
--
