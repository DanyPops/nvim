-- akko colorscheme loader
-- Source: ~/Pictures/akko_bllom.JPG (Fujifilm X100VI, Akko)
vim.g.colors_name = "akko"

local ok, lush = pcall(require, "lush")
if not ok then
  vim.notify("akko: lush.nvim is required — add rktjmp/lush.nvim to your plugins", vim.log.levels.ERROR)
  return
end

lush(require("lush_theme.akko"))
