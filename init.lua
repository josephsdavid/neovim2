vim.cmd([[
  syntax off
  filetype off
  filetype plugin indent off
]])

-- require("impatient").enable_profile()
E = require("core.events")
km = require("core.keymap")

if table.unpack == nil then
    table.unpack = unpack
end

require("config")
require("core.keybinds")

vim.cmd([[
  syntax on
  filetype on
  filetype plugin indent on
  colorscheme doom-one
]])

