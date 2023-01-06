vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 0
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.matchup_matchparen_enabled = 1
vim.g.load_black = 1
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

