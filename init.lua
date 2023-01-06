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

Config = require("config")

Config.setup()
Config.load_plugins()

require("core.keybinds").setup()

vim.cmd([[
  syntax on
  filetype on
  filetype plugin indent on
]])

