-- Preserve both ends while fitting a string to n display columns.
local function middle_ellipsis(s, n)
  if vim.fn.strdisplaywidth(s) <= n then
    return s
  end
  if n <= 1 then
    return s:sub(1, math.max(n, 0))
  end
  local head = math.ceil((n - 1) / 2)
  local tail = (n - 1) - head
  if tail <= 0 then
    return s:sub(1, head) .. "…"
  end
  return s:sub(1, head) .. "…" .. s:sub(-tail)
end

-- Shorten the longest directory first, preserving informative short components.
local FLOOR = 1
local function fit_path(path, budget)
  if vim.fn.strdisplaywidth(path) <= budget then
    return path
  end
  if budget < 1 then
    budget = 1
  end

  local is_abs = path:sub(1, 1) == "/"
  local parts = vim.split(path, "/", { plain = true, trimempty = false })
  local filename = table.remove(parts, #parts)
  local start_idx = is_abs and 2 or 1 -- parts[1] is "" for a leading "/"

  local function total_width()
    return vim.fn.strdisplaywidth(table.concat(parts, "/") .. "/" .. filename)
  end

  while total_width() > budget do
    local over = total_width() - budget
    local longest_idx, longest_len, second_len = nil, FLOOR, FLOOR
    for i = start_idx, #parts do
      local len = vim.fn.strdisplaywidth(parts[i])
      if len > longest_len then
        second_len = longest_len
        longest_idx, longest_len = i, len
      elseif len > second_len then
        second_len = len
      end
    end
    if not longest_idx then
      break -- every directory component is already down to FLOOR
    end
    local shrink_by = math.max(1, math.min(over, longest_len - second_len))
    parts[longest_idx] = middle_ellipsis(parts[longest_idx], math.max(FLOOR, longest_len - shrink_by))
  end

  local result = table.concat(parts, "/") .. "/" .. filename
  if vim.fn.strdisplaywidth(result) <= budget then
    return result
  end

  -- Shorten the filename last and preserve its extension.
  local dirs = table.concat(parts, "/") .. "/"
  local ext = filename:match("%.[^./]+$") or ""
  local base = filename:sub(1, #filename - #ext)
  local room = budget - vim.fn.strdisplaywidth(dirs) - #ext
  if room > 2 then
    base = middle_ellipsis(base, room)
  end
  return dirs .. base .. ext
end

return {
  -- Dashboard ASCII art.
  {
    "MaximilianLloyd/ascii.nvim",
    lazy         = true,
    dependencies = { "MunifTanjim/nui.nvim" },
  },

  {
    "akinsho/bufferline.nvim",
    event  = "BufReadPre",
    config = function()
      require("bufferline").setup {
        options = {
          themable                = true,
          separator_style         = "slant",
          indicator               = { style = "icon", icon = "▎" },
          modified_icon           = "▪",
          show_buffer_close_icons = false,
          show_close_icon         = false,
        },
      }
    end,
  },

  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup {
        set_vim_settings = false,
        content = {
          active = function()
            local M            = require("mini.statusline")
            local mode, hl     = M.section_mode({ trunc_width = 120 })
            local git          = M.section_git({ trunc_width = 75, icon = "▪" })
            local diff         = M.section_diff({ trunc_width = 75 })
            local diagnostics  = M.section_diagnostics({
              trunc_width = 75,
              signs       = { ERROR = "■", WARN = "▲", INFO = "●", HINT = "◆" },
            })
            -- Show workspace indexing progress when available.
            local indexing     = vim.lsp.status():gsub("%%", "%%%%")
            local lsp          = indexing ~= "" and indexing or M.section_lsp({ trunc_width = 75 })
            local finfo        = M.section_fileinfo({ trunc_width = 120 })
            local location     = M.section_location({ trunc_width = 75 })
            local search       = M.section_searchcount({ trunc_width = 75 })

            local function fname_raw()
              if vim.bo.buftype == "terminal" then return "%t" end
              local full = vim.api.nvim_buf_get_name(0)
              if full == "" then return "[No Name]%m%r" end
              -- Do not shorten URI-backed buffers.
              if full:match("^%a+://") then return "%f%m%r" end
              return { full = vim.fn.fnamemodify(full, ":~") }
            end

            local groups = {
              { hl = hl,                       strings = { mode } },
              { hl = "MiniStatuslineDevinfo",  strings = { git, diff, diagnostics, lsp } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { "" } },
              "%=",
              { hl = "MiniStatuslineFileinfo", strings = { search, finfo } },
              { hl = hl,                       strings = { location } },
            }

            local raw = fname_raw()
            local fname
            if type(raw) == "string" then
              fname = raw
            else
              -- Measure each side separately; %= expands to the full window width.
              local left_width  = vim.api.nvim_eval_statusline(M.combine_groups({ groups[1], groups[2] }), {}).width
              local right_width = vim.api.nvim_eval_statusline(M.combine_groups({ groups[6], groups[7] }), {}).width
              local total_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
              local budget      = total_width - left_width - right_width - 2 -- 2 = filename group's own leading/trailing space
              fname = fit_path(raw.full, budget):gsub("%%", "%%%%") .. "%m%r"
            end
            groups[4] = { hl = "MiniStatuslineFilename", strings = { fname } }

            return M.combine_groups(groups)
          end,
        },
      }
    end,
  },

  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    config       = function() require "plugins.configs.noice" end,
  },

  { "folke/zen-mode.nvim", opts = {} },

  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts  = {},
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft   = { "markdown" },
    opts = {},
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      icons = {
        breadcrumb = "●",
        separator  = "▪",
        group      = "▸ ",
      },
      -- Diffview provides its own g? help.
      filter = function(mapping)
        return mapping.desc ~= "diffview_ignore"
      end,
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy     = false,
    ---@type snacks.Config
    opts = {
      bigfile      = { enabled = true },
      dashboard = {
        enabled  = true,
        -- Load random ASCII art at render time.
        sections = function()
          local ok, art = pcall(require, "ascii")
          local header  = ok
            and table.concat(art.art.text.neovim.dos_rebel, "\n")
            or  "N E O V I M"
          return {
            { text = { header, hl = "SnacksDashboardHeader" }, align = "center", padding = { 2, 0 } },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          }
        end,
        preset = {
          keys = {
            { icon = "▪", key = "f", desc = "Find File",  action = ":lua Snacks.picker.files()"  },
            { icon = "●", key = "r", desc = "Recent",     action = ":lua Snacks.picker.recent()" },
            { icon = "◆", key = "g", desc = "Grep",       action = ":lua Snacks.picker.grep()"   },
            { icon = "■", key = "n", desc = "New File",   action = ":enew"                       },
            { icon = "▦", key = "q", desc = "Quit",       action = ":qa"                         },
          },
        },
      },
      explorer     = { enabled = true },
      indent       = { enabled = true },
      input        = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          -- Full-width keymap descriptions without a preview pane.
          keymaps = { preview = false, layout = { preset = "ivy" } },

          -- Full-width symbol list above its preview.
          lsp_workspace_symbols = {
            -- Snacks expects the root box at layout.layout[1].
            layout = {
              layout = {
                box       = "vertical",
                backdrop  = false,
                width     = 0,
                height    = 0.65,
                row       = -1,
                border    = "top",
                title     = " {title} {live} {flags}",
                title_pos = "left",
                { win = "input",   height = 1,   border = "bottom" },
                { win = "list",    border = "none" },
                { win = "preview", title = "{preview}", height = 0.45, border = "top" },
              },
            },
          },
        },
      },
      notifier     = { enabled = true },
      quickfile    = { enabled = true },
      scope        = { enabled = true },
      scroll       = { enabled = true },
      statuscolumn = { enabled = true },
      lazygit      = { enabled = true },
      terminal     = { enabled = true },
      words        = { enabled = true },
    },
  },
}
