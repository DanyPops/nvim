local map = vim.keymap.set

vim.g.mapleader = ","

--- Wrapper for commands
local cmdWrap = function(command)
  return function()
    vim.cmd(command)
  end
end

-- general mappings
map("n", "<C-s>", cmdWrap "w") -- Write to file
map("n", "<C-S-s>", cmdWrap "wa") -- Write all to file
map("i", "jk", "<ESC>") -- Insert to Normel
map("n", "<C-c>", cmdWrap "%y+") -- Copy file content
map("n", "<leader>h", cmdWrap "set hlsearch!") -- Toggle search highlight

-- Toggle floating terminal
map("n", "<leader>e", cmdWrap 'lua require("FTerm").toggle()')
map("t", "<leader>e", cmdWrap 'lua require("FTerm").toggle()')

-- Toggle the Zen
map("n", "<leader>z", cmdWrap "ZenMode")

-- Oil - File Explorer
map("n", "<leader>p", cmdWrap "Oil")

-- Telescope
map("n", "<leader>ff", cmdWrap "Telescope find_files")
map("n", "<leader>fo", cmdWrap "Telescope oldfiles")
map("n", "<leader>fw", cmdWrap "Telescope live_grep")
map("n", "<leader>gt", cmdWrap "Telescope git_status")

-- bufferline
-- cycle buffers
map("n", "<Tab>", cmdWrap "BufferLineCycleNext")
map("n", "<S-Tab>", cmdWrap "BufferLineCyclePrev")
-- Exit buffer
map("n", "<C-q>", cmdWrap "bd")

-- comment.nvim
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end)
-- comment visual
map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

-- Format file
map("n", "<leader>fm", function()
  require("conform").format()
end)

-- AI assistants (Avante enabled, CodeCompanion optional)
local function map_cmd_if_exists(mode, lhs, cmd, desc)
  if vim.fn.exists(":" .. cmd) == 2 then
    map(mode, lhs, "<cmd>" .. cmd .. "<CR>", { desc = desc })
  end
end

-- Avante
map_cmd_if_exists("n", "<leader>aa", "AvanteToggle", "Avante: Toggle sidebar")
map_cmd_if_exists("n", "<leader>aq", "AvanteAsk", "Avante: Ask")
map_cmd_if_exists("n", "<leader>ac", "AvanteChat", "Avante: Chat")
map_cmd_if_exists("n", "<leader>an", "AvanteChatNew", "Avante: New chat")
map_cmd_if_exists("n", "<leader>ah", "AvanteHistory", "Avante: History")
map_cmd_if_exists("n", "<leader>as", "AvanteStop", "Avante: Stop")
map_cmd_if_exists("n", "<leader>ar", "AvanteRefresh", "Avante: Refresh UI")

