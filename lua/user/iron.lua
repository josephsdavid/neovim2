local iron = require('iron')


iron.core.set_config {
  repl_open_cmd = "topleft vertical split",
  preferred = {
    python = "ptpython",
    lua = "lua",
    julia = "julia",
  }
}
vim.g.iron_map_defaults = 0
vim.g.iron_map_extended = 0
