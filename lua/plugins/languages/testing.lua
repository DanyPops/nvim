local km = require("config.keymaps")

return {
  -- Rust: rustaceanvim.neotest (LSP-based discovery, no extra plugin needed).
  -- Go:   neotest-go.
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go"),
          require("rustaceanvim.neotest"),
        },
      })
    end,
    keys = km.neotest,
  },

  -- Go:   needs delve in PATH  —  go install github.com/go-delve/delve/cmd/dlv@latest
  -- Rust: needs codelldb       —  :MasonInstall codelldb  (rustaceanvim auto-detects)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap   = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("dap-go").setup()

      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
    end,
    keys = km.dap,
  },
}
