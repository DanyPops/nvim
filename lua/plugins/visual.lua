-- Visual ergonomics for spatial/pattern-based reading.
--
-- Three layers:
--   1. Sticky context header  — always know which function/class you are inside
--   2. Nesting depth as colour — bracket depth → akko palette hue, no counting
--   3. Skeleton folding        — collapse bodies to see the file's shape

return {
  -- Structural anchor: enclosing function/class floats at the top of the
  -- window when scrolled deep into a block. Prevents the "where am I in
  -- this 300-line function?" context collapse that tanks ADD focus.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    opts = {
      max_lines  = 3,
      trim_scope = "outer",
      mode       = "cursor",
      separator  = "─",
    },
  },

  -- Each additional nesting level gets the next akko palette hue.
  -- Structure reads as a colour gradient; you count depth by colour,
  -- not by scanning for matching brackets.
  --
  -- Depth → colour mapping (defined in opts.lua ColorScheme autocmd):
  --   1 leaf  #72b89e   2 sky  #74a2c0   3 gold   #d09e48
  --   4 blossom #d4728a  5 cloud #a4bccc  6 frond  #9dc4b8
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPre",
    config = function()
      local rd = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy  = { [""] = rd.strategy["global"] },
        query     = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
        priority  = { [""] = 110 },
        highlight = {
          "RainbowDelimiterGreen",
          "RainbowDelimiterBlue",
          "RainbowDelimiterYellow",
          "RainbowDelimiterRed",
          "RainbowDelimiterCyan",
          "RainbowDelimiterViolet",
        },
      }
    end,
  },

  -- Skeleton folding: collapse every function body to reveal the file's
  -- structural shape. Provider chain: LSP (precise) → indent.
  --
  --   zM — skeleton view (close all)
  --   zR — full expand (open all)
  --   zK — peek a fold without committing to it
  --   za — toggle fold under cursor
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event        = "BufReadPre",
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,  desc = "Folds: open all" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Folds: skeleton view" },
      { "zK", function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then vim.lsp.buf.hover() end
        end, desc = "Folds: peek or hover" },
    },
    opts = {
      -- Fold label: first line + " ⋯ N lines" keeps collapsed blocks informative.
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local suffix      = ("  ⋯ %d lines"):format(endLnum - lnum)
        local targetWidth = width - vim.fn.strdisplaywidth(suffix)
        local curWidth    = 0
        local out         = {}
        for _, chunk in ipairs(virtText) do
          local text = chunk[1]
          local tw   = vim.fn.strdisplaywidth(text)
          if curWidth + tw <= targetWidth then
            out[#out + 1] = chunk
          else
            out[#out + 1] = { truncate(text, targetWidth - curWidth), chunk[2] }
            break
          end
          curWidth = curWidth + tw
        end
        out[#out + 1] = { suffix, "Comment" }
        return out
      end,
      -- treesitter excluded: its synchronous parser:parse() conflicts with
      -- snacks.scope's async parser:parse(range, on_parse) on the same LanguageTree,
      -- invalidating in-flight trees and producing nil nodes in the async callback.
      provider_selector = function() return { "lsp", "indent" } end,
    },
    config = function(_, opts)
      vim.o.foldcolumn     = "1"
      vim.o.foldlevel      = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable     = true
      require("ufo").setup(opts)
    end,
  },
}
