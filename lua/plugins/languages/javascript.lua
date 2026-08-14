local km = require("config.keymaps")

return {
  -- Run Bun files in Neovim. bun.tests still depends on the removed
  -- nvim-treesitter.ts_utils module, so only run_current is enabled.
  {
    "Fire-The-Fox/bun.nvim",
    ft           = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = { "akinsho/toggleterm.nvim" },
    config       = function()
      require("bun").setup({
        close_on_exit = true,
        direction     = "horizontal",
      })
    end,
    keys = km.bun,
  },
}
