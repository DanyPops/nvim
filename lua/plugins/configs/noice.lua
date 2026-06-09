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

  -- Route search count (1/N shown when cycling n/N) to a mini popup so it
  -- doesn't collide with diagnostic virtual text at end-of-line.
  routes = {
    {
      filter = { event = "msg_show", kind = "search_count" },
      opts   = { view = "mini" },
    },
  },

  presets = {
    bottom_search         = false, -- use noice-styled search popup for /
    command_palette       = true,  -- cmdline + popupmenu together
    long_message_to_split = true,  -- long messages → split
    inc_rename            = false,
    lsp_doc_border        = false,
  },
}
