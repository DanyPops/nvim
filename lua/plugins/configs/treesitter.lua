local km    = require("config.keymaps")
local langs = require("config.languages")

require("nvim-treesitter.configs").setup {
  ensure_installed = langs.grammars(),

  highlight = {
    enable           = true,
    use_languagetree = true,
  },

  indent = { enable = true },

  textobjects = km.treesitter_textobjects,
}
