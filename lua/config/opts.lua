local opt = vim.opt

opt.laststatus = 3 -- global statusline
opt.showmode = false

-- Centering
opt.scrolloff = 999

-- In TTY with tmux: use tmux buffer as clipboard provider.
-- In Wayland/X11: wl-paste / xclip handle it via OSC 52 / unnamedplus.
if vim.env.TMUX and not vim.env.WAYLAND_DISPLAY and not vim.env.DISPLAY then
  vim.g.clipboard = {
    name  = "tmux",
    copy  = { ["+"] = "tmux load-buffer -",  ["*"] = "tmux load-buffer -" },
    paste = { ["+"] = "tmux save-buffer -",  ["*"] = "tmux save-buffer -" },
    cache_enabled = 0,
  }
end
opt.clipboard = "unnamedplus"

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
-- Hybrid mode: absolute on the current line, relative on others.
-- Relative numbers make vertical jumps spatial rather than arithmetic.
opt.number         = true
opt.relativenumber = true
opt.ruler          = false

-- Visual anchoring
opt.cursorline = true   -- horizontal highlight: always know which line you're on

-- Word-boundary wrapping: long lines wrap at word edges and re-indent to
-- match the start column, so wrapped prose/comments stay legible as blocks.
opt.linebreak   = true
opt.breakindent = true

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

opt.updatetime = 250

-- Cursor blink in all modes
-- blinkwait: delay before blinking starts  (ms)
-- blinkon:   time cursor is visible         (ms)
-- blinkoff:  time cursor is invisible       (ms)
opt.guicursor = table.concat({
  "n-v-c-sm:block-blinkwait700-blinkoff400-blinkon250",
  "i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250",
  "r-cr-o:hor20-blinkwait700-blinkoff400-blinkon250",
}, ",")

-- Geometric diagnostic signs — mirrors tmux Bauhaus glyph vocabulary:
--   ■ solid square · ▲ triangle · ● circle · ◆ diamond · ▪ small square
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "■",
      [vim.diagnostic.severity.WARN]  = "▲",
      [vim.diagnostic.severity.INFO]  = "●",
      [vim.diagnostic.severity.HINT]  = "◆",
    },
  },
  virtual_text = { prefix = "▪" },
  float        = { border = "rounded", header = "", source = "if_many" },
}

-- Diff highlights: background-only, so syntax colours stay visible.
--
-- Colour derivation (all HSL, akko palette hues, S=20 L=13 — darker than
-- the theme's darken(60) which lands at S=38 L=20 and fights the text):
--
--   bg1 editor          hsl(342, 28, 10) #1c1117  baseline
--   DiffAdd   leaf hue  hsl(145, 20, 13) #1b2820  +3L green tint
--   DiffChange gold hue hsl( 38, 20, 13) #28231b  +3L amber tint
--   DiffDelete blossom  hsl(352, 20, 13) #281b1c  +3L pink  tint
--   DiffText   gold hue hsl( 38, 30, 16) #352c1d  +6L S+10  word-level
--
-- Principle (Tonsky): background covers large area, so hue is perceptible
-- even at L=13. The tint whispers semantic meaning without shouting.
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern  = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "DiffAdd",    { bg = "#1b2820" })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#28231b" })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#281b1c" })
    vim.api.nvim_set_hl(0, "DiffText",   { bg = "#352c1d", bold = true })

    -- Rainbow delimiter hues — nesting depth reads as a colour gradient.
    -- Colours are akko palette anchors (same hue family as syntax tokens):
    --   depth 1  leaf      hsl(155,30,62)  #72b89e
    --   depth 2  sky       hsl(207,35,62)  #74a2c0
    --   depth 3  gold      hsl( 38,55,60)  #d09e48
    --   depth 4  blossom   hsl(352,55,65)  #d4728a
    --   depth 5  cloud     hsl(207,20,74)  #a4bccc
    --   depth 6  frond     hsl(155,22,72)  #9dc4b8
    vim.api.nvim_set_hl(0, "RainbowDelimiterGreen",  { fg = "#72b89e" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterBlue",   { fg = "#74a2c0" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#d09e48" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterRed",    { fg = "#d4728a" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterCyan",   { fg = "#a4bccc" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#9dc4b8" })

    -- Treesitter context header: bg2 strip gives the sticky header a distinct
    -- panel feel without competing with syntax colours below it.
    vim.api.nvim_set_hl(0, "TreesitterContext",           { bg = "#261a20" })
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#261a20", fg = "#a29098" })
    vim.api.nvim_set_hl(0, "TreesitterContextSeparator",  { fg = "#4e3a44" })
  end,
})

