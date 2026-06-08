local km = require("config.keymaps")

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

local servers = {
  "ts_ls",
  "html",
  "cssls",
  "gopls",
  "zls",
  "basedpyright",
  "clangd",
}

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, { capabilities = capabilities })
end

vim.lsp.enable(vim.list_extend({ "lua_ls" }, servers))
