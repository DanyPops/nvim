local lint = require "lint"

-- Configure golangci-lint for Go files
lint.linters_by_ft = {
  go = { "golangcilint" },
}

-- Automatically lint on read & write
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})
