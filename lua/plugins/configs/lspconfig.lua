-- Global diagnostic mappings
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "LSP: show diagnostics" })
vim.keymap.set("n", "[d",       vim.diagnostic.goto_prev,  { desc = "LSP: previous diagnostic" })
vim.keymap.set("n", "]d",       vim.diagnostic.goto_next,  { desc = "LSP: next diagnostic" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "LSP: diagnostics to loclist" })

-- Buffer-local mappings set on LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD",        vim.lsp.buf.declaration,    vim.tbl_extend("force", opts, { desc = "LSP: go to declaration" }))
    vim.keymap.set("n", "gd",        vim.lsp.buf.definition,     vim.tbl_extend("force", opts, { desc = "LSP: go to definition" }))
    vim.keymap.set("n", "K",         vim.lsp.buf.hover,          vim.tbl_extend("force", opts, { desc = "LSP: hover docs" }))
    vim.keymap.set("n", "gi",        vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP: go to implementation" }))
    vim.keymap.set("n", "<C-k>",     vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP: signature help" }))
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder,    vim.tbl_extend("force", opts, { desc = "LSP: add workspace folder" }))
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "LSP: remove workspace folder" }))
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend("force", opts, { desc = "LSP: list workspace folders" }))
    vim.keymap.set("n",       "<space>D",  vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "LSP: type definition" }))
    vim.keymap.set("n",       "<space>rn", vim.lsp.buf.rename,          vim.tbl_extend("force", opts, { desc = "LSP: rename symbol" }))
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action,  vim.tbl_extend("force", opts, { desc = "LSP: code action" }))
    vim.keymap.set("n",       "gr",        vim.lsp.buf.references,      vim.tbl_extend("force", opts, { desc = "LSP: references" }))
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat    = { "markdown", "plaintext" },
  snippetSupport         = true,
  preselectSupport       = true,
  insertReplaceSupport   = true,
  labelDetailsSupport    = true,
  deprecatedSupport      = true,
  commitCharactersSupport = true,
  tagSupport             = { valueSet = { 1 } },
  resolveSupport         = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})

-- Setup multiple servers with the same default options
local servers = {
  "ts_ls",
  "html",
  "cssls",
  "gopls",
  "zls",
  "basedpyright",
  "clangd",
  "yamlls",
  "rust_analyzer",
}

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    capabilities = capabilities,
  })
end

vim.lsp.enable(vim.list_extend({ "lua_ls" }, servers))
