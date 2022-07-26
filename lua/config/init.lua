Bindings = require "config.keybinds"
local ts = require "config.ts"
local lsp = require "config.lsp"
-- alter any treesitter setups here
ts.setup()
lsp.setup()
Bindings.setup(Bindings.config)
