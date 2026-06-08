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
opt.number = true
opt.ruler = false

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

