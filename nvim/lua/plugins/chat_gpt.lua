return {
  "jackMort/ChatGPT.nvim",
  config = function()
    require("chatgpt").setup {
      welcome_message = "",
      openai_params = {
        model = "text-davinci-003",
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
    { "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", desc = "GPT Edit" },
  },
}
