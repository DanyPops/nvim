local opt = vim.opt

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
  },
})

opt.laststatus = 3 -- global statusline
opt.showmode = false

-- Centering
opt.scrolloff = 999

-- Use tmux clipboard only when no display server is available.
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

-- Hybrid line numbers.
opt.number         = true
opt.relativenumber = true
opt.ruler          = false

-- Visual anchoring
opt.cursorline = true   -- horizontal highlight: always know which line you're on

-- Wrap at word boundaries and preserve indentation.
opt.linebreak   = true
opt.breakindent = true

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

opt.updatetime = 250

-- Cursor blink in all modes.
opt.guicursor = table.concat({
  "n-v-c-sm:block-blinkwait700-blinkoff400-blinkon250",
  "i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250",
  "r-cr-o:hor20-blinkwait700-blinkoff400-blinkon250",
}, ",")

-- Geometric diagnostic signs.
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

-- Background-only diff highlights preserve syntax colours.
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern  = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "DiffAdd",    { bg = "#1b2820" })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#28231b" })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#281b1c" })
    vim.api.nvim_set_hl(0, "DiffText",   { bg = "#352c1d", bold = true })

    -- Akko palette gradient for nested delimiters.
    vim.api.nvim_set_hl(0, "RainbowDelimiterGreen",  { fg = "#72b89e" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterBlue",   { fg = "#74a2c0" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#d09e48" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterRed",    { fg = "#d4728a" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterCyan",   { fg = "#a4bccc" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#9dc4b8" })

    -- Distinguish the sticky Treesitter context header.
    vim.api.nvim_set_hl(0, "TreesitterContext",           { bg = "#261a20" })
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#261a20", fg = "#a29098" })
    vim.api.nvim_set_hl(0, "TreesitterContextSeparator",  { fg = "#4e3a44" })
  end,
})

-- Render files containing ANSI colours as read-only terminal views.
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern  = "*",
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype ~= "" then return end

    -- Bound detection for large logs.
    local sample = vim.api.nvim_buf_get_lines(buf, 0, 200, false)
    local has_ansi_color = false
    for _, line in ipairs(sample) do
      if line:find("\27%[[%d;]*m") then
        has_ansi_color = true
        break
      end
    end
    if not has_ansi_color then return end

    vim.bo[buf].swapfile = false
    vim.api.nvim_open_term(buf, {})
    vim.bo[buf].modified = false
    vim.keymap.set("n", "q", "<cmd>bwipeout!<cr>", { buffer = buf, silent = true, nowait = true })
  end,
})
