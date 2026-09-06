.PHONY: test smoke

# Structural/behavioral tests via mini.test child processes.
test: deps/mini.nvim
	nvim --headless --noplugin \
	  -u tests/scripts/minimal_init.lua \
	  -c "lua MiniTest.run({ execute = { reporter = MiniTest.gen_reporter.stdout({ group_depth = 1 }) } })"

# Smoke: load plugins, move the cursor, close folds, and collect errors.
# Headless needs explicit input after plugin startup settles.
SMOKE_SCRIPT := $(shell mktemp /tmp/nvim-smoke-XXXXXX.lua)
smoke:
	@printf '%s\n' \
	  'local log = "/tmp/nvim-smoke-errors.log"' \
	  'local orig = vim.notify' \
	  'vim.notify = function(msg, level, opts)' \
	  '  if level and level >= vim.log.levels.ERROR then' \
	  '    local f = io.open(log, "a") if f then f:write(msg .. "\n") f:close() end' \
	  '  end' \
	  '  orig(msg, level, opts)' \
	  'end' \
	  'vim.defer_fn(function()' \
	  '  vim.cmd("edit /tmp/nvim-smoke-test.rs")' \
	  '  vim.defer_fn(function()' \
	  '    vim.api.nvim_input("GzMjkjkjk")' \
	  '    vim.defer_fn(function() vim.cmd("qa!") end, 2000)' \
	  '  end, 2000)' \
	  'end, 3000)' > $(SMOKE_SCRIPT)
	@printf 'fn main() { let x = vec![1,2,3]; }\n' > /tmp/nvim-smoke-test.rs
	@rm -f /tmp/nvim-smoke-errors.log
	@nvim --headless -S $(SMOKE_SCRIPT) 2>/tmp/nvim-smoke-stderr.log || true
	@rm -f $(SMOKE_SCRIPT)
	@{ cat /tmp/nvim-smoke-errors.log 2>/dev/null; grep -E "Error|error" /tmp/nvim-smoke-stderr.log 2>/dev/null | grep -v deprecated; } | grep . && exit 1 || echo "smoke: OK"

deps/mini.nvim:
	@mkdir -p deps
	git clone --filter=blob:none https://github.com/echasnovski/mini.nvim $@
