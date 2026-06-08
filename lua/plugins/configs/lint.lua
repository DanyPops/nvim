local langs = require("config.languages")
local lint  = require("lint")

lint.linters_by_ft = langs.linters_by_ft()

local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group    = group,
  callback = function() lint.try_lint() end,
  desc     = "Lint on save",
})
