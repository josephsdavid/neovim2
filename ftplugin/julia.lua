local km = require"core.keymap"

km.setmap(km.localleader("f"), ":JuliaFormatterFormat<CR>", "Julia formatter format", {mode = "n", noremap = true, silent = false})
km.setmap(km.localleader("f"), ":JuliaFormatterFormat<CR>", "Julia formatter format", {mode = "v", noremap = true, silent = false})
