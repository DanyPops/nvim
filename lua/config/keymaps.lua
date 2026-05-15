local map = vim.keymap.set

vim.g.mapleader = ","

--- Wrap an Ex command into a <cmd>…<cr> string (no closure overhead)
local cmd = function(c)
  return "<cmd>" .. c .. "<cr>"
end

-- General
map("n", "<C-s>",     cmd "w",             { desc = "Write file" })
map("n", "<C-S-s>",   cmd "wa",            { desc = "Write all files" })
map("i", "jk",        "<ESC>",             { desc = "Exit insert mode" })
map("n", "<C-c>",     cmd "%y+",           { desc = "Copy file to clipboard" })
map("n", "<leader>h", cmd "set hlsearch!", { desc = "Toggle search highlight" })

-- Floating terminal (FTerm) — lazy-loaded via Lua closure
map("n", "<leader>e", function() require("FTerm").toggle() end, { desc = "Toggle floating terminal" })
map("t", "<leader>e", function() require("FTerm").toggle() end, { desc = "Toggle floating terminal" })

-- Zen mode
map("n", "<leader>z", cmd "ZenMode", { desc = "Toggle Zen mode" })

-- Oil – file explorer
map("n", "<leader>p", cmd "Oil", { desc = "Open Oil file explorer" })

-- Telescope
map("n", "<leader>ff", cmd "Telescope find_files", { desc = "Telescope: find files" })
map("n", "<leader>fo", cmd "Telescope oldfiles",   { desc = "Telescope: recent files" })
map("n", "<leader>fw", cmd "Telescope live_grep",  { desc = "Telescope: live grep" })
map("n", "<leader>gt", cmd "Telescope git_status", { desc = "Telescope: git status" })

-- Bufferline – cycle & close
map("n", "<Tab>",   cmd "BufferLineCycleNext", { desc = "Next buffer" })
map("n", "<S-Tab>", cmd "BufferLineCyclePrev", { desc = "Prev buffer" })
map("n", "<C-q>",   cmd "bd",                 { desc = "Close buffer" })

-- Comment.nvim
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle line comment" })

map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Toggle line comment (visual)" })

-- Format
map("n", "<leader>fm", function()
  require("conform").format()
end, { desc = "Format file" })
