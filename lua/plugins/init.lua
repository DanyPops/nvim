local function merge(tables)
  local out = {}
  for _, t in ipairs(tables) do
    for _, v in ipairs(t) do out[#out + 1] = v end
  end
  return out
end

require("lazy").setup(
  merge {
    require "plugins.colorscheme",
    require "plugins.editing",
    require "plugins.git",
    require "plugins.languages.javascript",
    require "plugins.languages.rust",
    require "plugins.languages.testing",
    require "plugins.lsp",
    require "plugins.ui",
    require "plugins.visual",
  },
  require "plugins.configs.lazy"
)
