local km = require("config.keymaps")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch       = "main",
    lazy         = false,
    build        = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config       = function() require "plugins.configs.treesitter" end,
  },

  {
    "stevearc/oil.nvim",
    opts         = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Project-wide search + replace with human-in-the-loop preview.
  -- Pi proposes changes; human reviews every match before anything is written.
  {
    "MagicDuck/grug-far.nvim",
    cmd  = { "GrugFar", "GrugFarWithin" },
    keys = km.grug_far,
    opts = {
      startInInsertMode        = false,
      resultsSeparatorLineChar = "-",
    },
  },

  {
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup({
        create_commands             = true,
        create_keymaps              = true,
        notify_on_switch            = true,
        auto_set_mode_heuristically = true,
      })
    end,
    ft = { "markdown", "gitcommit", "text", "rst", "asciidoc" },
  },

  -- Symbol outline — agents can call aerial.get_location() to know where
  -- they are in the code structure without raw treesitter queries.
  {
    "stevearc/aerial.nvim",
    opts         = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys         = km.aerial,
  },

  {
    "folke/todo-comments.nvim",
    event        = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {},
    keys         = km.todo,
  },

  {
    "folke/trouble.nvim",
    opts = {},
    cmd  = "Trouble",
    keys = km.trouble,
  },
}
