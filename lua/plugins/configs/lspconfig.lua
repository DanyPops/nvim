local km    = require("config.keymaps")
local langs = require("config.languages")

vim.api.nvim_create_autocmd("LspAttach", {
  group    = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    km.lsp(ev.buf, client)
  end,
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace   = { library = vim.api.nvim_get_runtime_file("", true) },
    },
  },
})

local servers = langs.lspconfig_servers()

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, { capabilities = capabilities })
end

vim.lsp.enable(vim.list_extend({ "lua_ls" }, servers))

-- Eager LSP: start servers at boot so the first file open is instant and the
-- workspace symbol index is already warm. Mirrors how VSCode works: server
-- starts with workspace root when the folder is recognised, not when a file
-- is opened. reuse_client deduplicates when the FileType autocmd fires later.
vim.schedule(function()
  local cwd = assert(vim.uv.cwd())
  local entries = vim.list_extend(
    { { lsp = "lua_ls", ft = "lua", root_hint = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml" } } },
    langs.servers_with_ft()
  )

  for _, e in ipairs(entries) do
    if not vim.lsp.is_enabled(e.lsp) then goto continue end
    local root = vim.fs.root(cwd, e.root_hint)
    if not root then goto continue end

    local cfg = vim.deepcopy(vim.lsp.config[e.lsp])
    cfg.root_dir = root  -- override function-based root_dir with resolved string
    vim.lsp.start(cfg, { attach = false })

    ::continue::
  end
end)
