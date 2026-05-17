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
-- Clear bg from every surface that should show the wallpaper through.
-- The Lush theme sets explicit bg values on all groups so it works as a
-- standalone opaque theme — this layer peels those back for transparency.
--
-- Groups intentionally kept opaque:
--   Pmenu / PmenuSel   — completion menu needs contrast to be usable
--   Cursor / Visual    — selection and cursor must be visible
--   Search / IncSearch — search highlights must stand out
--   DiagnosticVirtualText* — coloured bg is part of the design

local transparent = {
  -- ── Editor chrome ──────────────────────────────────────────────────
  "Normal", "NormalNC",
  "SignColumn", "FoldColumn",
  "LineNr", "CursorLineNr",
  "EndOfBuffer", "NonText",
  "WinSeparator", "VertSplit",
  "StatusLine", "StatusLineNC",
  "TabLine", "TabLineFill",
  "WinBar", "WinBarNC",

  -- ── Floats (base — covers LSP hover, diagnostics float, etc.) ──────
  "NormalFloat", "FloatBorder", "FloatTitle",

  -- ── Telescope ──────────────────────────────────────────────────────
  "TelescopeNormal",
  "TelescopeBorder",
  "TelescopePromptNormal",
  "TelescopePromptBorder",
  "TelescopeResultsNormal",
  "TelescopeResultsBorder",
  "TelescopePreviewNormal",
  "TelescopePreviewBorder",

  -- ── Noice ──────────────────────────────────────────────────────────
  "NoiceCmdlinePopup",
  "NoiceCmdlinePopupBorder",
  "NoiceConfirm",
  "NoiceConfirmBorder",
  "NoiceMini",

  -- ── Snacks ─────────────────────────────────────────────────────────
  "SnacksDashboard",
  "SnacksDashboardNormal",

  -- ── Trouble ────────────────────────────────────────────────────────
  "TroubleNormal",

  -- ── Bufferline (top tab bar) ────────────────────────────────────────
  "BufferLineFill",        -- bar background — was #180c0f, the black bar
  "BufferLineBackground",  -- inactive buffer bg

  -- ── Lazy / Mason (plugin manager UIs) ──────────────────────────────
  "LazyNormal",
  "MasonNormal",
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
