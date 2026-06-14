# Neovim agent context

AI chat plugins are currently disabled in this config.

## Editor context

If prompts include editor context from an external agent:

- `#{nvim}` — JSON snapshot of focused buffer, cursor, open buffers, aerial symbol, nearby diagnostics
- `#{aerial}` — current symbol from aerial.nvim
- `#{viewport}` — visible code on screen
- `#{buffer}{diff}` — incremental buffer changes
- `#{diagnostics}` — LSP diagnostics in the current buffer
- `#{selection}` — visual selection

Treat `focused` in `#{nvim}` as authoritative for which file and line the user is looking at.

## Rules for the agent

- Prefer editing paths from `focused` / `#{buffer}` before guessing from the repo tree.
- If `modified` is true, the buffer may differ from disk — read before overwriting.
- For multi-file bulk replacements, propose changes clearly; the user may review in grug-far.
- MCP tools from `~/.cursor/mcp.json` (scribe, locus, emcee, chronolog, conty, lex) are available when the Cursor agent session approves them.

## Keymaps

- `,ao` — aerial symbol outline
