vim.keymap.set("n", km.localleader("f"), ":Format<CR>",
    {desc =  "Julia formatter format",  noremap = true, silent = false })
vim.keymap.set("n", km.localleader("F"), ":FormatModifications<CR>",
    {desc =  "Julia formatter format",  noremap = true, silent = false })
