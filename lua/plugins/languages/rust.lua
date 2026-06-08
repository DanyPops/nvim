local km = require("config.keymaps")

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy    = false,
    init    = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr) km.rust(bufnr) end,
        },
      }
    end,
  },
}
