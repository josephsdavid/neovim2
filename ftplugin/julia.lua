vim.keymap.set( "n",km.localleader("f"), ":JuliaFormatterFormat<CR>",
    {desc =  "Julia formatter format",  noremap = true, silent = false })
vim.keymap.set( "v",km.localleader("f"), ":JuliaFormatterFormat<CR>",
    {desc =  "Julia formatter format",  noremap = true, silent = false })
