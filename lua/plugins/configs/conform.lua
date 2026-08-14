local langs = require("config.languages")

require("conform").setup {
  formatters_by_ft = langs.formatters_by_ft(),
  format_on_save   = { timeout_ms = 500, lsp_fallback = true },
}
