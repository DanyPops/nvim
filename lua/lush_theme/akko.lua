--
-- akko — Lush colorscheme
--
-- Palette extracted from ~/Pictures/akko_bllom.JPG
-- Pink tabebuia blossoms against steel sky, Akko, Fujifilm X100VI
--
-- Hue anchors from the photo:
--   Blossom  H≈352  vibrant magenta-pink
--   Branch   H≈12   warm sienna-orange
--   Sky      H≈207  muted steel blue
--

local lush = require("lush")
local hsl  = lush.hsl

---@diagnostic disable: undefined-global
local theme = lush(function(injected_functions)
  local sym = injected_functions.sym

  -- ── Backgrounds ─────────────────────────────────────────────────────────
  -- Deep warm burgundy-blacks, derived from the shadowed branch areas

  local bg0 = hsl(342, 35,  7)   -- #120c10  deepest, almost-black
  local bg1 = hsl(342, 28, 10)   -- #1c1117  editor background
  local bg2 = hsl(342, 24, 14)   -- #261a20  popups / floats
  local bg3 = hsl(342, 20, 19)   -- #342428  selection
  local bg4 = hsl(340, 16, 28)   -- #4e3a44  borders, dimmed UI chrome

  -- ── Text ────────────────────────────────────────────────────────────────
  -- Warm off-whites with a faint pink tint (tinted by the blossom hue)

  local txt0 = hsl(340, 30, 90)  -- #eedde8  brightest, emphasis
  local txt1 = hsl(340, 18, 82)  -- #d4c4cc  normal text
  local txt2 = hsl(340, 10, 62)  -- #a29098  comments, dim
  local txt3 = hsl(340,  8, 42)  -- #6e5f65  line numbers, disabled

  -- ── Blossom ─────────────────────────────────────────────────────────────
  -- H≈352  Saturated pink-magenta — the dominant colour of the photo.
  -- Keywords, operators, primary UI accent.

  local blossom = hsl(352, 55, 57)  -- #c55778  keywords, statements
  local petal   = hsl(352, 42, 68)  -- #d4849a  types, classes, builtins
  local bloom   = hsl(352, 60, 74)  -- #e890a8  strong emphasis, special kw
  local blush   = hsl(352, 28, 84)  -- #dfcad2  subtle decoration

  -- ── Amber / Branch ──────────────────────────────────────────────────────
  -- H≈12-22  Warm sienna and gold from the tree branches.
  -- Strings, constants, numeric literals.

  local sienna = hsl( 12, 65, 45)   -- #be5430  numbers, constants
  local amber  = hsl( 22, 62, 52)   -- #c4703a  strings
  local gold   = hsl( 38, 55, 60)   -- #d09e48  attributes, specials

  -- ── Sky ─────────────────────────────────────────────────────────────────
  -- H≈207  Muted steel-blue from the overcast sky background.
  -- Variables, identifiers, parameters.

  local sky   = hsl(207, 32, 58)    -- #6d9aba  variables
  local cloud = hsl(207, 18, 72)    -- #9eb8ca  parameters, subtle

  -- ── Status ──────────────────────────────────────────────────────────────

  local err  = hsl(352, 65, 50)     -- #c22848  errors
  local ok   = hsl(145, 38, 50)     -- #50a06c  success, added
  local warn = hsl( 42, 70, 54)     -- #cc9c28  warnings
  local info = hsl(212, 48, 54)     -- #4c7cbf  info

  -- ── Theme ────────────────────────────────────────────────────────────────

  return {

    -- Editor chrome
    Normal         { bg = bg1,      fg = txt1 },
    NormalNC       { bg = bg0,      fg = txt2 },
    NormalFloat    { bg = bg2,      fg = txt1 },
    FloatBorder    { bg = bg2,      fg = bg4  },
    FloatTitle     { bg = bg2,      fg = blossom, bold = true },

    -- Cursor
    Cursor         { bg = blossom,  fg = bg0 },
    CursorIM       { bg = bloom,    fg = bg0 },
    CursorLine     { bg = bg2 },
    CursorColumn   { bg = bg2 },
    CursorLineNr   { bg = bg2,      fg = blossom, bold = true },

    -- Selection
    Visual         { bg = bg3 },
    VisualNOS      { bg = bg3 },

    -- UI chrome
    LineNr         { fg = txt3 },
    SignColumn     { bg = bg1 },
    ColorColumn    { bg = bg2 },
    VertSplit      { fg = bg4,      bg = bg1 },
    WinSeparator   { fg = bg4,      bg = bg1 },
    Folded         { bg = bg2,      fg = txt3,   italic = true },
    FoldColumn     { bg = bg1,      fg = bg4 },
    EndOfBuffer    { fg = bg3 },

    -- Status / tab line
    StatusLine     { bg = bg2,      fg = txt2 },
    StatusLineNC   { bg = bg0,      fg = txt3 },
    TabLine        { bg = bg0,      fg = txt3 },
    TabLineFill    { bg = bg0 },
    TabLineSel     { bg = bg2,      fg = txt0,   bold = true },

    -- Popup menu (completion)
    Pmenu          { bg = bg2,      fg = txt1 },
    PmenuSel       { bg = bg3,      fg = txt0,   bold = true },
    PmenuSbar      { bg = bg3 },
    PmenuThumb     { bg = bg4 },

    -- Search
    Search         { bg = gold.darken(30).desaturate(20), fg = txt0 },
    IncSearch      { bg = blossom,  fg = bg0,    bold = true },
    CurSearch      { bg = bloom,    fg = bg0,    bold = true },
    Substitute     { bg = sienna,   fg = bg0 },

    -- Spelling
    SpellBad       { sp = err,      undercurl = true },
    SpellCap       { sp = warn,     undercurl = true },
    SpellRare      { sp = info,     undercurl = true },
    SpellLocal     { sp = sky,      undercurl = true },

    -- Diff
    DiffAdd        { bg = ok.darken(60),   fg = ok },
    DiffChange     { bg = warn.darken(60), fg = warn },
    DiffDelete     { bg = err.darken(60),  fg = err },
    DiffText       { bg = warn.darken(40), fg = txt0, bold = true },
    Added          { fg = ok },
    Changed        { fg = warn },
    Removed        { fg = err },

    -- Misc UI
    MatchParen     { bg = bg4,      fg = bloom,  bold = true },
    NonText        { fg = bg4 },
    SpecialKey     { fg = bg4 },
    Whitespace     { fg = bg4 },
    Conceal        { fg = txt3 },
    Directory      { fg = sky,      bold = true },
    Title          { fg = blossom,  bold = true },
    Question       { fg = gold },
    MoreMsg        { fg = ok },
    ModeMsg        { fg = txt1,     bold = true },
    ErrorMsg       { fg = err,      bold = true },
    WarningMsg     { fg = warn },

    -- Quickfix
    QuickFixLine   { bg = bg3 },
    qfLineNr       { fg = txt3 },
    qfFileName     { fg = sky },

    -- Winbar
    WinBar         { bg = bg0,      fg = txt2 },
    WinBarNC       { bg = bg0,      fg = txt3 },

    -- ── Base syntax ──────────────────────────────────────────────────────

    Comment        { fg = txt2,     italic = true },

    Constant       { fg = amber },
    String         { fg = amber },
    Character      { fg = gold },
    Number         { fg = sienna },
    Boolean        { fg = sienna,   italic = true },
    Float          { fg = sienna },

    Identifier     { fg = txt1 },
    Function       { fg = petal },

    Statement      { fg = blossom,  bold = true },
    Conditional    { fg = blossom,  bold = true },
    Repeat         { fg = blossom,  bold = true },
    Label          { fg = blossom },
    Operator       { fg = bloom },
    Keyword        { fg = blossom,  bold = true },
    Exception      { fg = err,      bold = true },

    PreProc        { fg = cloud },
    Include        { fg = sky },
    Define         { fg = blossom },
    Macro          { fg = amber },
    PreCondit      { fg = sky },

    Type           { fg = petal },
    StorageClass   { fg = blossom },
    Structure      { fg = petal },
    Typedef        { fg = petal },

    Special        { fg = bloom },
    SpecialChar    { fg = gold },
    Tag            { fg = blossom },
    Delimiter      { fg = txt2 },
    SpecialComment { fg = txt2,     bold = true },
    Debug          { fg = warn },

    Underlined     { underline = true },
    Ignore         { fg = bg4 },
    Error          { fg = err,      bold = true },
    Todo           { fg = blossom,  bold = true, italic = true },

    -- ── Treesitter ───────────────────────────────────────────────────────

    sym("@variable")                { fg = txt1 },
    sym("@variable.builtin")        { fg = sky,      italic = true },
    sym("@variable.parameter")      { fg = cloud },
    sym("@variable.member")         { fg = sky },

    sym("@constant")                { fg = amber },
    sym("@constant.builtin")        { fg = sienna,   italic = true },
    sym("@constant.macro")          { fg = amber },

    sym("@string")                  { fg = amber },
    sym("@string.escape")           { fg = bloom },
    sym("@string.special")          { fg = gold },
    sym("@string.regexp")           { fg = gold },

    sym("@number")                  { fg = sienna },
    sym("@number.float")            { fg = sienna },
    sym("@boolean")                 { fg = sienna,   italic = true },

    sym("@function")                { fg = petal },
    sym("@function.builtin")        { fg = bloom },
    sym("@function.call")           { fg = petal },
    sym("@function.macro")          { fg = amber },
    sym("@function.method")         { fg = petal },
    sym("@function.method.call")    { fg = petal },

    sym("@constructor")             { fg = petal },

    sym("@keyword")                 { fg = blossom,  bold = true },
    sym("@keyword.return")          { fg = bloom,    bold = true },
    sym("@keyword.import")          { fg = sky },
    sym("@keyword.operator")        { fg = bloom },
    sym("@keyword.exception")       { fg = err,      bold = true },
    sym("@keyword.conditional")     { fg = blossom,  bold = true },
    sym("@keyword.repeat")          { fg = blossom,  bold = true },

    sym("@type")                    { fg = petal },
    sym("@type.builtin")            { fg = petal,    italic = true },
    sym("@type.definition")         { fg = petal },
    sym("@type.qualifier")          { fg = blossom },

    sym("@attribute")               { fg = gold },
    sym("@property")                { fg = sky },
    sym("@field")                   { fg = sky },
    sym("@namespace")               { fg = cloud },
    sym("@module")                  { fg = cloud },

    sym("@operator")                { fg = bloom },
    sym("@punctuation")             { fg = txt2 },
    sym("@punctuation.bracket")     { fg = txt2 },
    sym("@punctuation.delimiter")   { fg = txt2 },
    sym("@punctuation.special")     { fg = bloom },

    sym("@comment")                 { fg = txt2,     italic = true },
    sym("@comment.todo")            { fg = blossom,  bold = true },
    sym("@comment.error")           { fg = err,      bold = true },
    sym("@comment.warning")         { fg = warn,     bold = true },
    sym("@comment.note")            { fg = info,     bold = true },

    sym("@tag")                     { fg = blossom },
    sym("@tag.attribute")           { fg = sky },
    sym("@tag.delimiter")           { fg = txt3 },

    sym("@markup.heading")          { fg = blossom,  bold = true },
    sym("@markup.strong")           { fg = txt0,     bold = true },
    sym("@markup.italic")           { fg = petal,    italic = true },
    sym("@markup.strikethrough")    { fg = txt3,     strikethrough = true },
    sym("@markup.link")             { fg = sky,      underline = true },
    sym("@markup.link.url")         { fg = cloud,    underline = true },
    sym("@markup.raw")              { fg = amber },
    sym("@markup.list")             { fg = bloom },
    sym("@markup.quote")            { fg = txt2,     italic = true },

    -- ── LSP ──────────────────────────────────────────────────────────────

    LspReferenceText   { bg = bg3 },
    LspReferenceRead   { bg = bg3 },
    LspReferenceWrite  { bg = bg3, bold = true },
    LspCodeLens        { fg = txt3, italic = true },
    LspInlayHint       { fg = txt3, bg = bg2, italic = true },

    -- ── Diagnostics ──────────────────────────────────────────────────────

    DiagnosticError           { fg = err },
    DiagnosticWarn            { fg = warn },
    DiagnosticInfo            { fg = info },
    DiagnosticHint            { fg = txt2 },
    DiagnosticOk              { fg = ok },

    DiagnosticUnderlineError  { sp = err,  undercurl = true },
    DiagnosticUnderlineWarn   { sp = warn, undercurl = true },
    DiagnosticUnderlineInfo   { sp = info, undercurl = true },
    DiagnosticUnderlineHint   { sp = txt2, undercurl = true },

    DiagnosticVirtualTextError { fg = err.desaturate(20).darken(10),  bg = err.desaturate(40).darken(70),  italic = true },
    DiagnosticVirtualTextWarn  { fg = warn.desaturate(20).darken(10), bg = warn.desaturate(40).darken(70), italic = true },
    DiagnosticVirtualTextInfo  { fg = info.desaturate(20).darken(10), bg = info.desaturate(40).darken(70), italic = true },
    DiagnosticVirtualTextHint  { fg = txt3,                                                                 italic = true },

    DiagnosticSignError  { fg = err,  bg = bg1 },
    DiagnosticSignWarn   { fg = warn, bg = bg1 },
    DiagnosticSignInfo   { fg = info, bg = bg1 },
    DiagnosticSignHint   { fg = txt2, bg = bg1 },

    -- ── Git (Gitsigns) ───────────────────────────────────────────────────

    GitSignsAdd           { fg = ok,   bg = bg1 },
    GitSignsChange        { fg = warn, bg = bg1 },
    GitSignsDelete        { fg = err,  bg = bg1 },
    GitSignsAddNr         { fg = ok },
    GitSignsChangeNr      { fg = warn },
    GitSignsDeleteNr      { fg = err },
    GitSignsAddLn         { bg = ok.darken(70) },
    GitSignsChangeLn      { bg = warn.darken(70) },
    GitSignsDeleteLn      { bg = err.darken(70) },

    -- ── Telescope ────────────────────────────────────────────────────────

    TelescopeNormal         { bg = bg2,      fg = txt1 },
    TelescopeBorder         { bg = bg2,      fg = bg4  },
    TelescopePromptNormal   { bg = bg2,      fg = txt0 },
    TelescopePromptBorder   { bg = bg2,      fg = blossom },
    TelescopePromptTitle    { bg = blossom,  fg = bg0,  bold = true },
    TelescopePreviewTitle   { bg = sky,      fg = bg0,  bold = true },
    TelescopeResultsTitle   { bg = bg2,      fg = txt3 },
    TelescopeSelectionCaret { fg = blossom,  bold = true },
    TelescopeSelection      { bg = bg3,      fg = txt0 },
    TelescopeMatching       { fg = bloom,    bold = true },

    -- ── Snacks ───────────────────────────────────────────────────────────

    SnacksInputBorder  { fg = blossom },
    SnacksInputTitle   { fg = blossom, bold = true },
    SnacksDashboardHeader { fg = blossom, bold = true },
    SnacksDashboardFooter { fg = txt3, italic = true },
    SnacksDashboardKey    { fg = bloom },
    SnacksDashboardDesc   { fg = txt2 },
    SnacksDashboardFile   { fg = sky },

    -- ── Bufferline ───────────────────────────────────────────────────────

    BufferLineFill           { bg = bg0 },
    BufferLineBackground     { bg = bg0,  fg = txt3 },
    BufferLineSelected       { bg = bg1,  fg = txt0,   bold = true },
    BufferLineSelectedSign   { bg = bg1,  fg = blossom },
    BufferLineIndicatorSelected { bg = bg1, fg = blossom },

    -- ── Noice ────────────────────────────────────────────────────────────

    NoiceCmdlinePopup       { bg = bg2, fg = txt1 },
    NoiceCmdlinePopupBorder { bg = bg2, fg = blossom },
    NoiceCmdlineIcon        { fg = blossom },
    NoiceConfirmBorder      { bg = bg2, fg = bloom },

    -- ── Trouble ──────────────────────────────────────────────────────────

    TroubleNormal     { bg = bg0, fg = txt1 },
    TroubleText       { fg = txt1 },
    TroubleCount      { fg = blossom, bold = true },
    TroubleError      { fg = err },
    TroubleWarning    { fg = warn },
    TroubleInformation{ fg = info },
    TroubleHint       { fg = txt2 },

    -- ── Mini statusline ──────────────────────────────────────────────────

    MiniStatuslineModeNormal  { bg = blossom, fg = bg0,  bold = true },
    MiniStatuslineModeInsert  { bg = sky,     fg = bg0,  bold = true },
    MiniStatuslineModeVisual  { bg = bloom,   fg = bg0,  bold = true },
    MiniStatuslineModeReplace { bg = sienna,  fg = bg0,  bold = true },
    MiniStatuslineModeCommand { bg = gold,    fg = bg0,  bold = true },
    MiniStatuslineModeOther   { bg = bg4,     fg = txt1, bold = true },
    MiniStatuslineFilename    { bg = bg2,     fg = txt1 },
    MiniStatuslineFileinfo    { bg = bg2,     fg = txt2 },
    MiniStatuslineInactive    { bg = bg0,     fg = txt3 },

    -- ── Indent blankline ─────────────────────────────────────────────────

    IblIndent    { fg = bg4 },
    IblScope     { fg = blossom.darken(40).desaturate(20) },

    -- ── Pivi (our plugin) ─────────────────────────────────────────────────

    PiviConnected   { fg = ok,       bold = true },
    PiviConnecting  { fg = warn,     bold = true },
    PiviError       { fg = err,      bold = true },
    PiviTitle       { fg = blossom,  bold = true },
    PiviYou         { fg = ok,       bold = true },
    PiviPi          { fg = sky,      bold = true },
    PiviDim         { fg = txt3 },
  }
end)

return theme
