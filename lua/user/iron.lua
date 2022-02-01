local iron = require('iron')


iron.core.set_config {
  preferred = {
    python = "ptpython",
    lua = "lua",
  }
}
vim.g.iron_map_defaults = 0
