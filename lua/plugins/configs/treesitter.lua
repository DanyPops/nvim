require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "lua", "vim", "vimdoc",
    "typescript", "tsx", "javascript",
    "html", "css",
    "go",
    "rust",
    "c", "zig",
    "markdown", "markdown_inline",
    "json", "yaml", "toml",
  },

  highlight = {
    enable         = true,
    use_languagetree = true,
  },

  indent = { enable = true },

  -- ── Textobjects ───────────────────────────────────────────────────────
  -- Semantic text objects and navigation based on the AST.
  -- Useful for humans AND for Pi agent — navigate by structure, not line numbers.

  textobjects = {
    select = {
      enable    = true,
      lookahead = true,   -- jump forward to the next textobject
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "around function" },
        ["if"] = { query = "@function.inner", desc = "inside function" },
        ["ac"] = { query = "@class.outer",    desc = "around class" },
        ["ic"] = { query = "@class.inner",    desc = "inside class" },
        ["ab"] = { query = "@block.outer",    desc = "around block" },
        ["ib"] = { query = "@block.inner",    desc = "inside block" },
        ["aa"] = { query = "@parameter.outer", desc = "around argument" },
        ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
      },
    },

    move = {
      enable     = true,
      set_jumps  = true,   -- add to jumplist
      goto_next_start = {
        ["]f"] = { query = "@function.outer", desc = "Next function start" },
        ["]c"] = { query = "@class.outer",    desc = "Next class start" },
      },
      goto_next_end = {
        ["]F"] = { query = "@function.outer", desc = "Next function end" },
        ["]C"] = { query = "@class.outer",    desc = "Next class end" },
      },
      goto_previous_start = {
        ["[f"] = { query = "@function.outer", desc = "Prev function start" },
        ["[c"] = { query = "@class.outer",    desc = "Prev class start" },
      },
      goto_previous_end = {
        ["[F"] = { query = "@function.outer", desc = "Prev function end" },
        ["[C"] = { query = "@class.outer",    desc = "Prev class end" },
      },
    },

    swap = {
      enable = true,
      swap_next     = { ["<leader>sp"] = { query = "@parameter.inner", desc = "Swap next parameter" } },
      swap_previous = { ["<leader>sP"] = { query = "@parameter.inner", desc = "Swap prev parameter" } },
    },
  },
}
