return {
  "folke/trouble.nvim",
  event = "BufReadPre",
  dependencies = "nvim-web-devicons",
  cmd = { "TroubleToggle", "Trouble" },
  opts = { use_diagnostic_signs = true },
  keys = {
    { "<leader>ctd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>ctw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>ctl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
    { "<leader>ctq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },
    { "<leader>ctt", "<cmd>TroubleToggle<cr>", desc = "TroubleToggle" },
  },
}
