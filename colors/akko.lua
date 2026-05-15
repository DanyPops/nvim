-- akko colorscheme loader
-- Source: ~/Pictures/akko_bllom.JPG (Fujifilm X100VI, Akko)
vim.g.colors_name = "akko"

local ok, lush = pcall(require, "lush")
if not ok then
  vim.notify("akko: lush.nvim is required", vim.log.levels.ERROR)
  return
end

-- Apply the full Lush theme (all groups with explicit colours)
lush(require("lush_theme.akko"))

-- ── Transparency ───────────────────────────────────────────────────────────
-- Neovim normally paints Normal.bg over the terminal, blocking the wallpaper.
-- Clearing these groups lets Alacritty's (neutral black) background show
-- through at whatever opacity the terminal window is set to.
--
-- Floats (NormalFloat, Pmenu, Telescope…) keep their bg — they should
-- be readable popups, not ghosted into the wallpaper.

local transparent = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "EndOfBuffer",
  "LineNr",
  "FoldColumn",
  "WinSeparator",
  "VertSplit",
  "StatusLine",
  "StatusLineNC",
}

local function apply()
  for _, name in ipairs(transparent) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    hl.bg      = nil
    hl.ctermbg = nil
    vim.api.nvim_set_hl(0, name, hl)
  end
end

apply()

-- Re-apply after any :colorscheme reload so transparency survives
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern  = "akko",
  callback = function() vim.schedule(apply) end,
  desc     = "akko: keep transparent groups clear after reload",
})
