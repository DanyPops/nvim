-- Must be set before lazy.nvim initialises (runs at require time, not in setup()).
vim.g.mapleader      = ","
vim.g.maplocalleader = "\\"

local M   = {}
local map = vim.keymap.set

-- ── Global keymaps ────────────────────────────────────────────────────────────
-- Called once from init.lua before lazy loads plugins.

function M.setup()
  local cmd = function(c) return "<cmd>" .. c .. "<cr>" end

  -- General
  map("n", "<C-s>",     cmd "w",             { desc = "Write file" })
  map("n", "<C-S-s>",   cmd "wa",            { desc = "Write all files" })
  map("i", "jk",        "<ESC>",             { desc = "Exit insert mode" })
  map("n", "<C-c>",     cmd "%y+",           { desc = "Copy file to clipboard" })
  map("n", "<leader>h", cmd "set hlsearch!", { desc = "Toggle search highlight" })

  -- Terminal (snacks)
  map("n", "<leader>e", function() Snacks.terminal.toggle() end, { desc = "Toggle floating terminal" })
  map("t", "<leader>e", function() Snacks.terminal.toggle() end, { desc = "Toggle floating terminal" })

  -- Zen mode
  map("n", "<leader>z", cmd "ZenMode", { desc = "Toggle Zen mode" })

  -- File explorer
  map("n", "<leader>p", cmd "Oil", { desc = "Open Oil file explorer" })

  -- Snacks picker
  map("n", "<leader>ff", function() Snacks.picker.files() end,      { desc = "Find: files" })
  map("n", "<leader>fo", function() Snacks.picker.recent() end,     { desc = "Find: recent files" })
  map("n", "<leader>fw", function() Snacks.picker.grep() end,       { desc = "Find: live grep" })
  map("n", "<leader>gt", function() Snacks.picker.git_status() end, { desc = "Git: status (picker)" })

  -- Bufferline
  map("n", "<Tab>",   cmd "BufferLineCycleNext", { desc = "Next buffer" })
  map("n", "<S-Tab>", cmd "BufferLineCyclePrev", { desc = "Prev buffer" })
  map("n", "<C-q>",   cmd "bd",                 { desc = "Close buffer" })

  -- Comments — native 0.10+ (gc/gcc)
  map("n", "<leader>/", "gcc", { desc = "Toggle line comment",          remap = true })
  map("v", "<leader>/", "gc",  { desc = "Toggle line comment (visual)", remap = true })

  -- Format
  map("n", "<leader>fm", function() require("conform").format() end, { desc = "Format file" })

  -- Window navigation — <C-hjkl> is standard; without these the native <C-w>h etc.
  -- have no desc and are invisible to Snacks.picker.keymaps().
  map("n", "<C-h>", "<C-w>h", { desc = "Window: go left" })
  map("n", "<C-j>", "<C-w>j", { desc = "Window: go down" })
  map("n", "<C-k>", "<C-w>k", { desc = "Window: go up" })
  map("n", "<C-l>", "<C-w>l", { desc = "Window: go right" })

  -- Window resize / layout — re-registered to add desc and appear in picker.
  map("n", "<C-w>_", "<C-w>_", { desc = "Window: maximize height" })
  map("n", "<C-w>|", "<C-w>|", { desc = "Window: maximize width" })
  map("n", "<C-w>=", "<C-w>=", { desc = "Window: equalize all" })
  map("n", "<C-w>o", "<C-w>o", { desc = "Window: close others (only)" })
  map("n", "<C-w>s", "<C-w>s", { desc = "Window: split horizontal" })
  map("n", "<C-w>v", "<C-w>v", { desc = "Window: split vertical" })

  -- Discoverability — single tool (snacks picker) for all keymap lookup
  map("n", "<leader>?",  function() Snacks.picker.keymaps({ ["local"] = true, global = false }) end, { desc = "Find: buffer-local keymaps" })
  map("n", "<leader>fk", function() Snacks.picker.keymaps() end,                                    { desc = "Find: all keymaps" })
  map("n", "<leader>fh", function() Snacks.picker.help() end,                                       { desc = "Find: help tags" })

  -- Passive key history ring buffer — always on, inspect with ,K
  local _key_ring = {}
  local _ring_max  = 50
  vim.on_key(function(key)
    local k = vim.fn.keytrans(key)
    if k == "" then return end
    _key_ring[#_key_ring + 1] = k
    if #_key_ring > _ring_max then table.remove(_key_ring, 1) end
  end, vim.api.nvim_create_namespace("keylog"))
  map("n", "<leader>K", function()
    if #_key_ring == 0 then
      vim.notify("Key history: empty", vim.log.levels.INFO)
      return
    end
    local lines = {}
    for i = #_key_ring, 1, -1 do
      lines[#lines + 1] = string.format(" %3d  %s", #_key_ring - i, _key_ring[i])
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end, { desc = "Keys: show history" })

  -- Diagnostics (global — work in any buffer, not just LSP-attached ones)
  map("n", "<space>e", vim.diagnostic.open_float, { desc = "LSP: diagnostic float" })
  map("n", "[d",       vim.diagnostic.goto_prev,  { desc = "LSP: prev diagnostic" })
  map("n", "]d",       vim.diagnostic.goto_next,  { desc = "LSP: next diagnostic" })
end

-- ── LSP — buffer-local, called from LspAttach ─────────────────────────────────

function M.lsp(bufnr, client)
  local opts = function(desc) return { buffer = bufnr, desc = desc } end

  -- Navigation — snacks picker for multi-result; raw lsp for single-result
  map("n", "gd", function() Snacks.picker.lsp_definitions() end,      opts("LSP: definitions"))
  map("n", "gr", function() Snacks.picker.lsp_references() end,       opts("LSP: references"))
  map("n", "gi", function() Snacks.picker.lsp_implementations() end,  opts("LSP: implementations"))
  map("n", "gD", vim.lsp.buf.declaration,                             opts("LSP: declaration"))
  map("n", "K",  vim.lsp.buf.hover,                                   opts("LSP: hover"))

  -- Code actions
  map("n",        "<space>rn", vim.lsp.buf.rename,      opts("LSP: rename"))
  map({ "n","v" },"<space>ca", vim.lsp.buf.code_action, opts("LSP: code action"))

  -- Type definition via picker (shows parent type of symbol under cursor)
  map("n", "<space>D", function() Snacks.picker.lsp_type_definitions() end, opts("LSP: type definition"))

  -- clangd only: toggle between .h/.hpp and .c/.cpp
  if client and client.name == "clangd" then
    map("n", "<leader>ch", function()
      vim.lsp.buf_request(bufnr, "textDocument/clangd/switchSourceHeader",
        { uri = vim.uri_from_bufnr(bufnr) },
        function(err, result)
          if not err and result then vim.cmd("edit " .. vim.uri_to_fname(result)) end
        end)
    end, opts("C: switch header/source"))
  end
end

-- ── Rust — buffer-local, called from rustaceanvim on_attach ──────────────────

function M.rust(bufnr)
  local opts = function(desc) return { silent = true, buffer = bufnr, desc = desc } end
  -- K overrides the generic LSP hover for Rust buffers only.
  -- Press K twice to enter the float, <CR> on an action to invoke.
  map("n", "K",          function() vim.cmd.RustLsp { "hover", "actions" } end,        opts("Rust: hover actions"))
  map("n", "<leader>rr", function() vim.cmd.RustLsp "runnables" end,                   opts("Rust: runnables"))
  map("n", "<leader>rR", function() vim.cmd.RustLsp { "runnables", bang = true } end,  opts("Rust: re-run last runnable"))
  map("n", "<leader>rt", function() vim.cmd.RustLsp "testables" end,                   opts("Rust: testables"))
  map("n", "<leader>rm", function() vim.cmd.RustLsp "expandMacro" end,                 opts("Rust: expand macro"))
  map("n", "<leader>rc", function() vim.cmd.RustLsp "codeAction" end,                  opts("Rust: code action (grouped)"))
  map("n", "<leader>rd", function() vim.cmd.RustLsp "debuggables" end,                 opts("Rust: debuggables"))
  map("n", "<leader>re", function() vim.cmd.RustLsp "explainError" end,                opts("Rust: explain error"))
  map("n", "<leader>rp", function() vim.cmd.RustLsp "rebuildProcMacros" end,           opts("Rust: rebuild proc macros"))
end

-- ── Gitsigns — buffer-local, called from gitsigns on_attach ──────────────────

function M.gitsigns(bufnr, gs)
  local opts = function(desc) return { buffer = bufnr, desc = desc } end
  map("n", "]h",         function() gs.nav_hunk "next" end, opts("Git: next hunk"))
  map("n", "[h",         function() gs.nav_hunk "prev" end, opts("Git: prev hunk"))
  map("n", "<leader>hp", gs.preview_hunk,                   opts("Git: preview hunk"))
  map("n", "<leader>hl", gs.setloclist,                     opts("Git: hunks to loclist"))
end


-- ── Plugin key tables — consumed as `keys = km.X` in plugin specs ─────────────
-- lazy.nvim reads these at startup to know which keymaps should trigger loading.

M.diffview = {
  { "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "Git: diff view" },
  { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git: file history" },
  { "<leader>gD", function()
      local remotes = vim.fn.systemlist("git remote")
      local remote  = vim.tbl_contains(remotes, "upstream") and "upstream" or "origin"
      local base    = vim.fn.system("git rev-parse --abbrev-ref " .. remote .. "/HEAD 2>/dev/null"):gsub("%s+", "")
      if base == "" or base:match("^fatal") then base = remote .. "/main" end
      vim.cmd("DiffviewOpen " .. base .. "...HEAD")
    end, desc = "Git: PR diff vs upstream" },
  { "<leader>gH", function()
      local remotes = vim.fn.systemlist("git remote")
      local remote  = vim.tbl_contains(remotes, "upstream") and "upstream" or "origin"
      local base    = vim.fn.system("git rev-parse --abbrev-ref " .. remote .. "/HEAD 2>/dev/null"):gsub("%s+", "")
      if base == "" or base:match("^fatal") then base = remote .. "/main" end
      vim.cmd("DiffviewFileHistory --range=" .. base .. "..HEAD")
    end, desc = "Git: PR commits vs upstream" },
}

M.grug_far = {
  { "<leader>sr", function() require("grug-far").open() end,                                                     desc = "Search: replace (grug-far)" },
  { "<leader>sw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, desc = "Search: replace word under cursor" },
  { "<leader>sr", function() require("grug-far").with_visual_selection() end, mode = "v",                       desc = "Search: replace selection" },
}

M.trouble = {
  { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
  { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
  { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
  { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP (Trouble)" },
  { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
  { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
}

M.aerial = {
  { "<leader>ao", "<cmd>AerialToggle<cr>", desc = "Aerial: symbol outline" },
}

M.todo = {
  { "<leader>ft", "<cmd>TodoLocList<cr>", desc = "Find: TODOs" },
}

M.octo = {
  { "<leader>gpr", "<cmd>Octo pr list<cr>",      desc = "GitHub: list PRs" },
  { "<leader>gpi", "<cmd>Octo issue list<cr>",   desc = "GitHub: list issues" },
  { "<leader>gpc", "<cmd>Octo review start<cr>", desc = "GitHub: start review" },
}

M.neogit = {
  { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git: Neogit" },
}

M.yaml_companion = {
  { "<leader>ky", "<cmd>lua require('yaml-companion').open_ui_select()<cr>", desc = "YAML: select schema" },
}

M.neotest = {
  { "<leader>tr", function() require("neotest").run.run() end,                     desc = "Test: run nearest" },
  { "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Test: run file" },
  { "<leader>ts", function() require("neotest").summary.toggle() end,              desc = "Test: summary panel" },
  { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: output" },
  { "<leader>tO", function() require("neotest").output_panel.toggle() end,         desc = "Test: output panel" },
  { "<leader>tS", function() require("neotest").run.stop() end,                    desc = "Test: stop" },
}

M.dap = {
  { "<F5>",       function() require("dap").continue() end,                                  desc = "DAP: continue / start" },
  { "<F10>",      function() require("dap").step_over() end,                                 desc = "DAP: step over" },
  { "<F11>",      function() require("dap").step_into() end,                                 desc = "DAP: step into" },
  { "<F12>",      function() require("dap").step_out() end,                                  desc = "DAP: step out" },
  { "<leader>db", function() require("dap").toggle_breakpoint() end,                         desc = "DAP: toggle breakpoint" },
  { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "DAP: conditional breakpoint" },
  { "<leader>du", function() require("dapui").toggle() end,                                  desc = "DAP: toggle UI" },
  { "<leader>dr", function() require("dap").repl.open() end,                                 desc = "DAP: REPL" },
}

-- ── Treesitter textobject definitions ─────────────────────────────────────────
-- Not vim.keymap.set calls — these are treesitter query bindings consumed
-- by nvim-treesitter-textobjects. Returned as a table, used in treesitter config.

M.treesitter_textobjects = {
  select = {
    enable    = true,
    lookahead = true,
    keymaps = {
      ["af"] = { query = "@function.outer",  desc = "around function" },
      ["if"] = { query = "@function.inner",  desc = "inside function" },
      ["ac"] = { query = "@class.outer",     desc = "around class" },
      ["ic"] = { query = "@class.inner",     desc = "inside class" },
      ["ab"] = { query = "@block.outer",     desc = "around block" },
      ["ib"] = { query = "@block.inner",     desc = "inside block" },
      ["aa"] = { query = "@parameter.outer", desc = "around argument" },
      ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
    },
  },
  move = {
    enable    = true,
    set_jumps = true,
    goto_next_start = {
      ["]f"] = { query = "@function.outer", desc = "Next function start" },
      ["]c"] = { query = "@class.outer",    desc = "Next class start" },
    },
    goto_next_end = {
      ["]F"] = { query = "@function.outer", desc = "Next function end" },
      ["]C"] = { query = "@class.outer",    desc = "Next class end" },
    },
    goto_previous_start = {
      ["[f"] = { query = "@function.outer", desc = "Prev function start" },
      ["[c"] = { query = "@class.outer",    desc = "Prev class start" },
    },
    goto_previous_end = {
      ["[F"] = { query = "@function.outer", desc = "Prev function end" },
      ["[C"] = { query = "@class.outer",    desc = "Prev class end" },
    },
  },
  swap = {
    enable        = true,
    swap_next     = { ["<leader>sp"] = { query = "@parameter.inner", desc = "Swap next parameter" } },
    swap_previous = { ["<leader>sP"] = { query = "@parameter.inner", desc = "Swap prev parameter" } },
  },
}

return M
