return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "php" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "phpcs" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local phpcs = require("lint").linters.phpcs
      -- phpcs.cmd = "./vendor/bin/phpcs"
      phpcs.args = {
        "-q",
        "--standard=phpcs.xml", -- wordpress plugin
        "--report=json",
        "-",
      }
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft, {
        php = { "phpcs" },
      })
    end,
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require "null-ls"
  --     opts.sources = opts.sources or {}
  --
  --     -- TODO: set this up on a project level?
  --     table.insert(
  --       opts.sources,
  --       nls.builtins.diagnostics.phpcs.with {
  --         command = "./vendor/bin/phpcs",
  --         extra_args = { "--standard=phpcs.xml" },
  --       }
  --     )
  --   end,
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          files = {
            maxSize = 5000000,
          },
          stubs = {
            "wordpress",
            "wordpress-tests",
            "apache",
            "bcmath",
            "bz2",
            "calendar",
            "com_dotnet",
            "Core",
            "ctype",
            "curl",
            "date",
            "dba",
            "dom",
            "enchant",
            "exif",
            "FFI",
            "fileinfo",
            "filter",
            "fpm",
            "ftp",
            "gd",
            "gettext",
            "gmp",
            "hash",
            "iconv",
            "imap",
            "intl",
            "json",
            "ldap",
            "libxml",
            "mbstring",
            "meta",
            "mysqli",
            "oci8",
            "odbc",
            "openssl",
            "pcntl",
            "pcre",
            "PDO",
            "pdo_ibm",
            "pdo_mysql",
            "pdo_pgsql",
            "pdo_sqlite",
            "pgsql",
            "Phar",
            "posix",
            "pspell",
            "random",
            "readline",
            "Reflection",
            "session",
            "shmop",
            "SimpleXML",
            "snmp",
            "soap",
            "sockets",
            "sodium",
            "SPL",
            "sqlite3",
            "standard",
            "superglobals",
            "sysvmsg",
            "sysvsem",
            "sysvshm",
            "tidy",
            "tokenizer",
            "xml",
            "xmlreader",
            "xmlrpc",
            "xmlwriter",
            "xsl",
            "Zend OPcache",
            "zip",
            "zlib",
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require "dap"
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { os.getenv "HOME" .. "/dev/vscode-php-debug/out/phpDebug.js" },
      }
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          pathMappings = {
            ["/var/www/html/wp-content/plugins/leadpages"] = "${workspaceFolder}/leadpages/",
            ["/var/www/html/wp-content/plugins/leadpages/tests"] = "${workspaceFolder}/tests/",
          },
        },
      }
    end,
  },
}
