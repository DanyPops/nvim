local km = require("config.keymaps")

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "lua", "vim", "vimdoc",
    "typescript", "tsx", "javascript",
    "html", "css",
    "go", "python",
    "rust",
    "c", "cpp", "zig",
    "bash",
    "markdown", "markdown_inline",
    "json", "yaml", "toml",
  },

  highlight = {
    enable           = true,
    use_languagetree = true,
  },

  indent = { enable = true },

  textobjects = km.treesitter_textobjects,
}
