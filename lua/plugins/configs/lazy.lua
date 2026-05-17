return {
  ui = {
    -- Rounded border makes the popup visually distinct from the editor
    border = "rounded",
    -- backdrop = 100 disables the full-screen dim window that Lazy creates
    -- when Normal.bg is set. With our transparent editor, the dimming effect
    -- comes naturally from the themed LazyNormal bg standing out.
    backdrop = 100,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
