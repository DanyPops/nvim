local km = require("config.keymaps")

return {
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local cfg = require("yaml-companion").setup({
        builtin_matchers = { kubernetes = { enabled = true } },
      })
      require("lspconfig").yamlls.setup(cfg)
    end,
    keys = km.yaml_companion,
  },
}
