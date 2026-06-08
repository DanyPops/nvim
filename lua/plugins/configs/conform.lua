local langs = require("config.languages")

require("conform").setup {
  formatters_by_ft = langs.formatters_by_ft(),
}
