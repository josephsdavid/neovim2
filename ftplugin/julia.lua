local km = require "core.keymap"
local g = require"config.terminal".genterm
local opt = require"core.options"


km.setmap(km.localleader("f"), ":JuliaFormatterFormat<CR>", "Julia formatter format",
    { mode = "n", noremap = true, silent = false })
km.setmap(km.localleader("f"), ":JuliaFormatterFormat<CR>", "Julia formatter format",
    { mode = "v", noremap = true, silent = false })

_G.JLTEST = g({hidden = true, close_on_exit= false, direction = "float", cmd = "julia -e 'using Pkg; Pkg.test()'"})
_G.JLFLOAT = g({hidden = true, close_on_exit= false, direction = "float", cmd = "julia"})
_G.JLVERT = g({hidden = true, close_on_exit= false, direction = "vertical", cmd = "julia", size = vim.o.columns * 0.4})
_G.JLHORIZ = g({hidden = true, close_on_exit= false, direction = "horizontal", cmd = "julia", size = 15})

km.setmap(km.localleader("t"), ":lua JLTEST()<CR>", "Julia test",
    { mode = "n", noremap = true, silent = false })
km.setmap(km.localleader("j"), ":lua JLFLOAT()<CR>", "Julia repl (float)",
    { mode = "n", noremap = true, silent = false })
km.setmap(km.localleader("v"), ":lua JLVERT()<CR>", "Julia repl (vert)",
    { mode = "n", noremap = true, silent = false })
km.setmap(km.localleader("h"), ":lua JLHORIZ()<CR>", "Julia repl (horiz)",
    { mode = "n", noremap = true, silent = false })

vim.cmd([[
    set conceallevel=2
    hi link Arrow Normal
    ]])


-- NOTE: parinfer is supporting julia in core.options, but we turn it off by default because sometimes its annoying
-- and then we just have a mapping to toggle it
opt.setbuffer("parinfer_comment_chars", { "#" }) -- in other lispy languages ; is comment, in julia ; is crucial to using the lang
vim.cmd("ParinferOff")
km.setmap(km.localleader("p"), ":ParinferToggle<cr>", "toggle parinfer",
    { mode = "n", noremap = true, silent = true })
