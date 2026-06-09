-- Tests that Snacks picker layout configs are structurally valid.
-- Catches the "no root box found" class of error before runtime.
--
-- Run: make test  (or the nvim --headless invocation in the Makefile)

local T     = MiniTest.new_set()
local child = MiniTest.new_child_neovim()
local eq    = MiniTest.expect.equality

-- Boot the real config once per test set.
T = MiniTest.new_set({
  hooks = {
    pre_once = function()
      child.restart({ "-u", vim.fn.stdpath("config") .. "/init.lua" })
    end,
    post_once = child.stop,
  },
})

-- layout.layout must exist and have at least one child for Snacks' resolver
-- to skip preset fallback and go straight to Layout.new.
T["lsp_workspace_symbols layout has root box"] = function()
  local ok = child.lua_get([[
    local cfg = require("snacks.picker.config")
    local opts = cfg.get({ source = "lsp_workspace_symbols" })
    local layout = cfg.layout(opts)
    -- layout.layout is the root box; layout.layout[1] is its first child
    return type(layout.layout) == "table" and layout.layout[1] ~= nil
  ]])
  eq(ok, true)
end

-- Calling lsp_workspace_symbols() must not raise (no UI shown in headless).
T["lsp_workspace_symbols() does not error"] = function()
  local ok, err = child.lua_get([[
    local ok, err = pcall(function()
      -- resolve layout only, don't open UI
      local cfg  = require("snacks.picker.config")
      local opts = cfg.get({ source = "lsp_workspace_symbols" })
      cfg.layout(opts)   -- this is what triggers "no root box found"
    end)
    return ok, err
  ]])
  eq(ok, true)
end

return T
