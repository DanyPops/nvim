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
-- Clear bg from editor surfaces so the terminal/wallpaper shows through.
--
-- Rule: EDITOR surfaces (where you write code) → transparent.
--       TOOL WINDOWS (Lazy, Mason, Telescope…) → keep themed bg for readability.
--
-- Intentionally kept opaque:
--   Pmenu/PmenuSel     — completion popup needs contrast
--   Cursor/Visual      — must always be visible
--   Search/IncSearch   — must stand out
--   LazyNormal         — tool modal: needs bg so text is readable over wallpaper
--   MasonNormal        — same

local transparent = {
  -- ── Editor chrome ─────────────────────────────────────────────────
  "Normal", "NormalNC",
  "SignColumn", "FoldColumn",
  "LineNr", "CursorLineNr",
  "EndOfBuffer", "NonText",
  "WinSeparator", "VertSplit",
  "StatusLine", "StatusLineNC",
  "TabLine", "TabLineFill",
  "WinBar", "WinBarNC",

  -- ── Generic floats (LSP hover, diagnostics, etc.) ─────────────────
  -- Note: NormalFloat is cleared so lightweight floats blend in,
  -- but specific tool windows override this with their own bg.
  "NormalFloat", "FloatBorder", "FloatTitle",

  -- ── Telescope ─────────────────────────────────────────────────────
  "TelescopeNormal",
  "TelescopeBorder",
  "TelescopePromptNormal",
  "TelescopePromptBorder",
  "TelescopeResultsNormal",
  "TelescopeResultsBorder",
  "TelescopePreviewNormal",
  "TelescopePreviewBorder",

  -- ── Noice ─────────────────────────────────────────────────────────
  "NoiceCmdlinePopup",
  "NoiceCmdlinePopupBorder",
  "NoiceConfirm",
  "NoiceConfirmBorder",
  "NoiceMini",

  -- ── Snacks dashboard ──────────────────────────────────────────────
  "SnacksDashboard",
  "SnacksDashboardNormal",

  -- ── Trouble ───────────────────────────────────────────────────────
  "TroubleNormal",

  -- ── Bufferline top bar ────────────────────────────────────────────
  "BufferLineFill",
  "BufferLineBackground",
}

-- ── Tool window surfaces — themed bg, NOT transparent ─────────────────────
-- These are modal/panel windows. Making them transparent causes them to float
-- over the wallpaper with no visual depth, making text hard to read.
-- We pin them to our theme's popup background (bg2).

local themed = {
  -- Lazy.nvim: without a bg, Normal.bg=nil triggers has_bg=false in Lazy's
  -- float.lua and disables the backdrop entirely; the popup then shows pure
  -- terminal black rather than our palette.
  "LazyNormal",
  "LazyBackdrop",

  -- Mason package manager
  "MasonNormal",
}

local function apply()
  -- Clear bg from editor surfaces
  for _, name in ipairs(transparent) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    hl.bg      = nil
    hl.ctermbg = nil
    vim.api.nvim_set_hl(0, name, hl)
  end

  -- Pin tool windows to our popup bg so they look themed, not black voids.
  -- bg2 = hsl(342, 24, 14) ≈ #261a20 — our popup/float background colour.
  local bg2 = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false }).bg
  -- NormalFloat bg was just cleared, so grab bg2 from a group that keeps it.
  -- FloatTitle still has our blossom fg but its bg was set by Lush.
  -- Easiest: read it from the Lush theme's Pmenu which always keeps its bg.
  local popup_bg = vim.api.nvim_get_hl(0, { name = "Pmenu", link = false }).bg

  if popup_bg then
    for _, name in ipairs(themed) do
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      hl.bg      = popup_bg
      hl.ctermbg = nil
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

apply()

-- Re-apply after any :colorscheme reload
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern  = "akko",
  callback = function() vim.schedule(apply) end,
  desc     = "akko: transparency + tool-window theming after reload",
})
