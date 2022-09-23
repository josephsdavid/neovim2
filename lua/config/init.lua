require "config.ts"
term = require "config.terminal"
Bindings = require "config.keybinds"
local lsp = require "config.lsp"
-- alter any treesitter setups here
lsp.setup()
term.setup()
Bindings.setup(Bindings.config)

require "config.autocmds"
require "config.snippets"
require "config.telescope"
require "config.norg"
require "config.lines"
-- require "config.namespaces"

