-- Structural tests that run fast (no full config load, no plugin network calls).
-- child.lua()     — executes a Lua block, sets globals
-- child.lua_get() — evaluates a single expression and returns the value

local T     = MiniTest.new_set()
local child = MiniTest.new_child_neovim()
local eq    = MiniTest.expect.equality

T = MiniTest.new_set({
  hooks = {
    pre_once  = function() child.start() end,
    post_once = child.stop,
  },
})

-- ── Layout structure ──────────────────────────────────────────────────────────

T["lsp_workspace_symbols layout is double-wrapped"] = function()
  -- dofile() the spec table without executing any plugin setup
  child.lua(([[
    local specs = dofile("%s/lua/plugins/ui.lua")
    for _, s in ipairs(specs) do
      if type(s) == "table" and s[1] == "folke/snacks.nvim" then
        _G._snacks = s; break
      end
    end
  ]]):format(vim.fn.stdpath("config")))

  local src = "_G._snacks.opts.picker.sources.lsp_workspace_symbols"

  -- outer layout config object must exist
  eq(child.lua_get(src .. " ~= nil"), true)
  -- inner root box must exist (Snacks checks layout.layout)
  eq(child.lua_get(src .. ".layout.layout ~= nil"), true)
  -- root box must have at least one child (Snacks checks layout.layout[1])
  eq(child.lua_get(src .. ".layout.layout[1] ~= nil"), true)
end

-- ── Gitsigns API surface ──────────────────────────────────────────────────────
-- Validates every function name referenced in M.gitsigns() actually exists on
-- the installed gitsigns module. Catches diff_this vs diffthis class of typos.

T["gitsigns functions referenced in keymaps all exist"] = function()
  child.lua(([[
    vim.opt.rtp:prepend("%s")
    _G.gs = require("gitsigns")
  ]]):format(vim.fn.stdpath("data") .. "/lazy/gitsigns.nvim"))

  local fns = {
    "nav_hunk", "preview_hunk", "preview_hunk_inline",
    "stage_hunk", "reset_hunk", "stage_buffer", "reset_buffer",
    "blame_line", "setloclist", "diffthis", "select_hunk",
  }
  for _, fn in ipairs(fns) do
    eq(child.lua_get(("_G.gs.%s ~= nil"):format(fn)), true)
  end
end

return T
