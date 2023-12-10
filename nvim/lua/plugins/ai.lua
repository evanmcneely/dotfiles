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
}
