return {
  "folke/trouble.nvim",
  event = "BufReadPre",
  dependencies = "nvim-web-devicons",
  cmd = { "TroubleToggle", "Trouble" },
  opts = { use_diagnostic_signs = true },
  keys = {
    { "<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>cD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>ct", "<cmd>TroubleToggle<cr>", desc = "TroubleToggle" },
  },
}
