local M = {}

-- Each entry defines one language's full tooling surface.
--   ft        — Neovim filetype; key in conform/lint tables
--   grammar   — treesitter parser name(s), string or list
--   formatter — conform.nvim formatter
--   linter    — nvim-lint linter
--   lsp       — configured via vim.lsp.config AND installed by mason
--   mason     — installed by mason, NOT configured via lspconfig (plugin owns it)
local specs = {
  { ft = "lua",        grammar = "lua",                    formatter = "stylua",       lsp = "lua_ls"       },
  { ft = "go",         grammar = "go",                     formatter = "gofmt",        lsp = "gopls",         linter = "golangcilint" },
  { ft = "rust",       grammar = "rust",                   formatter = "rustfmt",      mason = "rust_analyzer" },
  { ft = "python",     grammar = "python",                 formatter = "black",        lsp = "basedpyright"  },
  { ft = "typescript", grammar = { "typescript", "tsx" },  formatter = "prettierd",    lsp = "ts_ls"        },
  { ft = "javascript", grammar = "javascript",             formatter = "prettierd"     },
  { ft = "c",          grammar = "c",                      formatter = "clang-format", lsp = "clangd"       },
  { ft = "cpp",        grammar = "cpp",                    formatter = "clang-format"  },
  { ft = "zig",        grammar = "zig",                    formatter = "zigfmt",       lsp = "zls"          },
  { ft = "yaml",       grammar = "yaml",                   formatter = "yamlfmt",      linter = "yamllint",   mason = "yamlls" },
  { ft = "html",       grammar = "html",                                               lsp = "html"         },
  { ft = "css",        grammar = "css",                                                lsp = "cssls"        },
  -- Grammar-only: treesitter highlighting with no separate filetype tooling
  { grammar = "bash"            },
  { grammar = "markdown"        },
  { grammar = "markdown_inline" },
  { grammar = "json"            },
  { grammar = "toml"            },
  { grammar = "vim"             },
  { grammar = "vimdoc"          },
}

-- Flat list of all treesitter parser names.
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

-- { ft = { "formatter" } } for conform.nvim formatters_by_ft.
function M.formatters_by_ft()
  local out = {}
  for _, s in ipairs(specs) do
    if s.ft and s.formatter then
      out[s.ft] = { s.formatter }
    end
  end
  return out
end

-- { ft = { "linter" } } for nvim-lint linters_by_ft.
function M.linters_by_ft()
  local out = {}
  for _, s in ipairs(specs) do
    if s.ft and s.linter then
      out[s.ft] = { s.linter }
    end
  end
  return out
end

-- LSP servers for vim.lsp.config + vim.lsp.enable.
-- Excludes lua_ls (custom config in lspconfig.lua) and mason-only entries.
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

-- All names for mason-lspconfig ensure_installed.
-- Includes both `lsp` (lspconfig-managed) and `mason` (plugin-managed).
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
