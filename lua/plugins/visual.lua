-- Context, nesting, folding, and log highlighting.

return {
  -- Filetype detection and syntax for plain logs.
  {
    "fei6409/log-highlight.nvim",
    event = "BufReadPre",
    config = function()
      require("log-highlight").setup({})
    end,
  },
  -- Keep the enclosing function or class visible.
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

  -- Colour delimiters by nesting depth.
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

  -- LSP/indent folding with zM, zR, zK, and za.
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    -- BufReadPre lets UFO cache the temporary one-line buffer before file load.
    event        = "BufReadPost",
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,  desc = "Folds: open all" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Folds: skeleton view" },
      { "zK", function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then vim.lsp.buf.hover() end
        end, desc = "Folds: peek or hover" },
    },
    opts = {
      -- Include the folded line count.
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
      -- Avoid Treesitter's sync parser conflicting with snacks.scope.
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
