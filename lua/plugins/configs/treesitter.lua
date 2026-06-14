local km    = require("config.keymaps")

require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldmethod = "expr"
    end
  end,
})

local textobjects = km.treesitter_textobjects

require("nvim-treesitter-textobjects").setup {
  select = {
    lookahead = textobjects.select.lookahead,
  },
  move = {
    set_jumps = textobjects.move.set_jumps,
  },
}

local function query(spec)
  return type(spec) == "table" and spec.query or spec
end

local function desc(spec)
  return type(spec) == "table" and spec.desc or nil
end

local select = require("nvim-treesitter-textobjects.select")
for key, spec in pairs(textobjects.select.keymaps) do
  vim.keymap.set({ "x", "o" }, key, function()
    select.select_textobject(query(spec), "textobjects")
  end, { desc = desc(spec) })
end

local move = require("nvim-treesitter-textobjects.move")
for key, spec in pairs(textobjects.move.goto_next_start) do
  vim.keymap.set({ "n", "x", "o" }, key, function()
    move.goto_next_start(query(spec), "textobjects")
  end, { desc = desc(spec) })
end
for key, spec in pairs(textobjects.move.goto_next_end) do
  vim.keymap.set({ "n", "x", "o" }, key, function()
    move.goto_next_end(query(spec), "textobjects")
  end, { desc = desc(spec) })
end
for key, spec in pairs(textobjects.move.goto_previous_start) do
  vim.keymap.set({ "n", "x", "o" }, key, function()
    move.goto_previous_start(query(spec), "textobjects")
  end, { desc = desc(spec) })
end
for key, spec in pairs(textobjects.move.goto_previous_end) do
  vim.keymap.set({ "n", "x", "o" }, key, function()
    move.goto_previous_end(query(spec), "textobjects")
  end, { desc = desc(spec) })
end

local swap = require("nvim-treesitter-textobjects.swap")
for key, spec in pairs(textobjects.swap.swap_next) do
  vim.keymap.set("n", key, function()
    swap.swap_next(query(spec))
  end, { desc = desc(spec) })
end
for key, spec in pairs(textobjects.swap.swap_previous) do
  vim.keymap.set("n", key, function()
    swap.swap_previous(query(spec))
  end, { desc = desc(spec) })
end
