require "config.ts"
Bindings = require "config.keybinds"
local lsp = require "config.lsp"
-- alter any treesitter setups here
lsp.setup()
Bindings.setup(Bindings.config)

require "config.autocmds"
require "config.snippets"



