require "user.options"
require "user.plugins"
require "user.lsp"
require "user.colorscheme"
require "user.treesitter"
require "user.keybinds"
require "user.cmp"
require "user.luasnip"
require "user.telescope"
require "user.toggleterm"
require "user.comment"
require "user.lualine"
-- require "user.clickfree"
-- require "user.lightspeed"
require "user.null-ls"
-- require "user.gitsigns"
require "user.neogit"
require "user.vimscript"
require "user.neorg"
require 'packer_compiled'
require "user.bufferline"
-- require "user.staline"
require "user.indentline"
require "user.zen"
vim.opt.list = true


local utils = require("user.utils")
local mappings = utils.mappings

require'impatient'.enable_profile()
