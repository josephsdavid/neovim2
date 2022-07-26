local km = require("core.keymap")
local op = require("core.options")

op.setglobal("mapleader", " ")
op.setglobal("maplocalleader", ",")

op.setglobal("lasttab", 1)
vim.cmd([[au TabLeave * let g:lasttab = tabpagenr()]])

-- TODO:Good whichkey map setup
km.setmap()
