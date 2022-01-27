local dap = require"dap"
local dap_py = require('dap-python')

require("dapui").setup()

require("nvim-dap-virtual-text").setup({commented = true})
dap.defaults.fallback.terminal_win_cmd = '80vsplit new'
vim.fn.sign_define('DapBreakpoint', {text='👉'})
vim.fn.sign_define('DapStopped', {text='💸'})

dap_py.setup('~/.virtualenvs/debugpy/bin/python')
table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'Debugger',
  program = '${file}',
  -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
})
