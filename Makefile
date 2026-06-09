.PHONY: test smoke

# Structural/behavioral tests via mini.test child processes.
test: deps/mini.nvim
	nvim --headless --noplugin \
	  -u tests/scripts/minimal_init.lua \
	  -c "lua MiniTest.run({ execute = { reporter = MiniTest.gen_reporter.stdout({ group_depth = 1 }) } })"

# Smoke: load the real config, exit immediately, print any Lua errors.
smoke:
	@nvim --headless -c "quit" 2>&1 | grep -E "^E[0-9]+|Error|error" && exit 1 || echo "smoke: OK"

deps/mini.nvim:
	@mkdir -p deps
	git clone --filter=blob:none https://github.com/echasnovski/mini.nvim $@
