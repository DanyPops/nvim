-- Minimal init for headless test runs.
-- Loads the real config but skips interactive startup side-effects.
-- Run via: nvim --headless --noplugin -u tests/scripts/minimal_init.lua

vim.env.LAZY_STDPATH = "/tmp/nvim-test-data"
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/mini.nvim")

require("mini.test").setup()
