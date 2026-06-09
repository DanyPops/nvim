-- Minimal init for headless test runs.
-- Resolves deps/mini.nvim relative to the config root, not stdpath("data"),
-- so this works before lazy.nvim has run or synced anything.

local config_root = vim.fn.fnamemodify(
  debug.getinfo(1, "S").source:sub(2), -- strip leading "@"
  ":p:h:h:h"                           -- file → scripts/ → tests/ → config/
)

vim.opt.rtp:prepend(config_root .. "/deps/mini.nvim")
require("mini.test").setup()
