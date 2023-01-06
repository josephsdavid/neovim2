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

local bindings = require("core.keybinds")

Config.load_plugins()

vim.cmd([[
  syntax on
  filetype on
  filetype plugin indent on
]])

