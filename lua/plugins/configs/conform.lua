local conform = require "conform"

conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofmt" },
    python = { "black" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    yaml   = { "yamlfmt" },
    rust   = { "rustfmt" },
    c      = { "clang-format" },
    cpp    = { "clang-format" },
    zig    = { "zigfmt" },
  },
}
