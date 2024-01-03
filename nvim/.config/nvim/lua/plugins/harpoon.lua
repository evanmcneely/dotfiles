return {
  -- slick navigation, like marks but for files
  {
    "ThePrimeagen/harpoon",
    --stylua: ignore
    keys = {
      { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Harpoon add" },
      { "<leader>m", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
      { "<leader>h", function() require("harpoon.ui").nav_prev() end, desc = "Harpoon prev" },
      { "<leader>l", function() require("harpoon.ui").nav_next() end, desc = "Harpoon next" },
      { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "File 1" },
      { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "File 2" },
      { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "File 3" },
      { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "File 4" },
      -- TODO: commands?
    },
    opts = {
      global_settings = {
        save_on_toggle = true,
        enter_on_sendcmd = true,
      },
    },
  },
}