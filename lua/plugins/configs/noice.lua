require("noice").setup {
  -- Geometric cmdline icons — geometry only, no pictograms
  cmdline = {
    format = {
      cmdline     = { icon = "▪" },
      search_down = { icon = "●" },
      search_up   = { icon = "●" },
      filter      = { icon = "◆" },
      lua         = { icon = "▸" },
      help        = { icon = "■" },
    },
  },

  views = {
    cmdline       = { position = "40%" },
    cmdline_popup = { position = "40%" },
    confirm       = { position = "40%" },
  },

  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"]                = true,
    },
  },

  notify = { enabled = false },

  presets = {
    bottom_search         = true,  -- classic bottom cmdline for search
    command_palette       = true,  -- cmdline + popupmenu together
    long_message_to_split = true,  -- long messages → split
    inc_rename            = false,
    lsp_doc_border        = false,
  },
}
