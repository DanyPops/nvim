local M = {}

-- Language tooling shared by Treesitter, Conform, nvim-lint, LSP, and Mason.
local specs = {
  { ft = "c",          grammar = "c",                     formatter = "clang-format", lsp = "clangd" },
  { ft = "cpp",        grammar = "cpp",                   formatter = "clang-format" },
  { ft = "css",        grammar = "css",                                               lsp = "cssls" },
  { ft = "go",         grammar = "go",                    formatter = "gofmt",        linter = "golangcilint", lsp = "gopls" },
  { ft = "html",       grammar = "html",                                              lsp = "html" },
  { ft = "javascript", grammar = "javascript",            formatter = "prettierd",    linter = "eslint_d" },
  { ft = "lua",        grammar = "lua",                   formatter = "stylua",       lsp = "lua_ls" },
  { ft = "python",     grammar = "python",                formatter = "black",        lsp = "basedpyright" },
  { ft = "rust",       grammar = "rust",                  formatter = "rustfmt",      mason = "rust_analyzer" },
  { ft = "typescript", grammar = { "typescript", "tsx" }, formatter = "prettierd",    linter = "eslint_d", lsp = "ts_ls" },
  { ft = "yaml",       grammar = "yaml",                  formatter = "yamlfmt",      linter = "yamllint", lsp = "yamlls" },
  { ft = "zig",        grammar = "zig",                   formatter = "zigfmt",       lsp = "zls" },

  -- Treesitter-only grammars.
  { grammar = "bash" },
  { grammar = "json" },
  { grammar = "markdown" },
  { grammar = "markdown_inline" },
  { grammar = "toml" },
  { grammar = "vim" },
  { grammar = "vimdoc" },
}

function M.grammars()
  local out = {}
  for _, s in ipairs(specs) do
    if type(s.grammar) == "table" then
      for _, g in ipairs(s.grammar) do out[#out + 1] = g end
    elseif s.grammar then
      out[#out + 1] = s.grammar
    end
  end
  return out
end

function M.formatters_by_ft()
  local out = {}
  for _, s in ipairs(specs) do
    if s.ft and s.formatter then
      out[s.ft] = { s.formatter }
    end
  end
  return out
end

function M.linters_by_ft()
  local out = {}
  for _, s in ipairs(specs) do
    if s.ft and s.linter then
      out[s.ft] = { s.linter }
    end
  end
  return out
end

-- lua_ls has custom config; Mason-only servers are plugin-managed.
function M.lspconfig_servers()
  local out, seen = {}, {}
  for _, s in ipairs(specs) do
    if s.lsp and s.lsp ~= "lua_ls" and not seen[s.lsp] then
      seen[s.lsp] = true
      out[#out + 1] = s.lsp
    end
  end
  return out
end

function M.mason_ensure_installed()
  local out, seen = {}, {}
  for _, s in ipairs(specs) do
    for _, key in ipairs({ "lsp", "mason" }) do
      local v = s[key]
      if v and not seen[v] then
        seen[v] = true
        out[#out + 1] = v
      end
    end
  end
  return out
end

return M
