require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofmt" },
    javascript = { { "prettier" } },
  },
}
