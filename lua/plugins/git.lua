local km = require("config.keymaps")

return {
  {
    "lewis6991/gitsigns.nvim",
    event  = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup {
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "▾" },
          topdelete    = { text = "▴" },
          changedelete = { text = "▎" },
          untracked    = { text = "▎" },
        },
        on_attach = function(buf)
          km.gitsigns(buf, package.loaded.gitsigns)
        end,
      }
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd  = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = km.diffview,
    opts = {
      -- q closes the whole Diffview from any pane.
      -- diff1/diff2 have no close key by default; file_panel's q only collapses it.
      keymaps = {
        diff1              = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
        diff2              = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
        file_panel         = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
        file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
      },
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config       = true,
    keys         = km.neogit,
  },

  {
    "pwntester/octo.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("octo").setup({ use_local_fs = true, picker = "snacks" })
    end,
    cmd  = { "Octo" },
    keys = km.octo,
  },
}
