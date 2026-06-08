local lint = require "lint"

lint.linters_by_ft = {
  go   = { "golangcilint" },
  yaml = { "yamllint" },
  rust = { "clippy" },
}

local augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group    = augroup,
  callback = function()
    lint.try_lint()
  end,
  desc = "Lint on save",
})
