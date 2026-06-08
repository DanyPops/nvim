return {
  { lazy = true, "nvim-lua/plenary.nvim" },

  {
    "nvim-tree/nvim-web-devicons",
    config = function() require("nvim-web-devicons").setup() end,
  },

  { "rktjmp/lush.nvim",            lazy = false, priority = 1001 },
  { dir = vim.fn.stdpath("config"), name = "akko", lazy = false, priority = 1000 },
  { "loctvl842/monokai-pro.nvim",   lazy = true },
}
