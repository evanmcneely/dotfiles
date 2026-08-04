return {

  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old
    build = ":TSUpdate",
    lazy = false,
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "php",
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "gotmpl",
        "templ",
      },
    },
    config = function(_, opts)
      local treesitter = require "nvim-treesitter"
      treesitter.setup {
        install_dir = vim.fn.stdpath "data" .. "/site",
      }

      local group = vim.api.nvim_create_augroup("treesitter", { clear = true })
      local function start(buf)
        if pcall(vim.treesitter.start, buf) then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          start(args.buf)
        end,
      })

      treesitter.install(opts.ensure_installed):await(function(err)
        if err then
          vim.schedule(function()
            vim.notify(err, vim.log.levels.ERROR, { title = "nvim-treesitter" })
          end)
          return
        end
        vim.schedule(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
              start(buf)
            end
          end
        end)
      end)

      -- So Avante can render with markdown syntax
      vim.treesitter.language.register("markdown", "Avante")

      -- For detecting go template files
      vim.filetype.add {
        extension = {
          gotmpl = "gotmpl",
          gohtml = "gotmpl",
          gohtmltmpl = "gotmpl",
          gohtxttmpl = "gotmpl",
          gohtexttmpl = "gotmpl",
          templ = "templ",
        },
      }
      vim.treesitter.language.register("gotmpl", { "gohtmltmpl", "gotexttmpl", "gotmpl", "gotxttmpl", "gohtml" })
    end,
  },

  -- Show open brackets when not visible in buffer
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      enable = true,
      max_lines = 5,
    },
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {
      per_filetype = {
        ["gotmpl"] = {
          enable_close = true,
        },
        -- aliases = {
        --   ["gohtml"] = "html",
        -- },
      },
    },
  },
}
