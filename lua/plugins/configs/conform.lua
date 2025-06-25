local conform = require("conform")

conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofmt" },
    python = { "black" },
    javascript = { "prettier" },
  },
}
