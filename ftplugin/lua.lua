local km = require "core.keymap"

vim.keymap.set( "n",km.localleader("f"), km.cmd("Format"),
    {desc =  "format",  noremap = true, silent = false })


vim.keymap.set( "n",km.localleader("ss"), km.plugmapping("(Luadev-RunLine)"),
    {desc =  "run lua",  noremap = true, silent = false })

vim.keymap.set( "n",km.localleader("s"), km.plugmapping("(Luadev-Run)"),
    {desc =  "run lua",  noremap = true, silent = false })

vim.keymap.set( "v",km.localleader("s"), km.plugmapping("(Luadev-Run)"),
    {desc =  "run lua",  noremap = true, silent = false })


