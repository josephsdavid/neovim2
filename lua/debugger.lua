local dapleader = Mappings.extendleader(Mappings.leader, "d")
local map = Mappings.keymap
local luacmd = Mappings.luacmd

local debugger = {
    "mfussenegger/nvim-dap",
    dependencies = {
        { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } }
    }
}

local python_debugger = {
    "mfussenegger/nvim-dap-python"
}

function python_debugger.config()
    -- NOTE: Make sure to run:
    -- mkdir .virtualenvs
    -- cd .virtualenvs
    -- python -m venv debugpy
    -- debugpy/bin/python -m pip install debugpy
    require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
    map("n", dapleader("n"), luacmd("require('dap-python').test_method()"), { noremap = true, silent = false },
        "test nearest method")
    map("n", dapleader("c"), luacmd("require('dap-python').test_class()"), { noremap = true, silent = false },
        "test nearest class")
    map("v", dapleader("s"), luacmd("require('dap-python').debug_selection()"), { noremap = true, silent = false },
        "debug selection")
end

debugger.dependencies[#debugger.dependencies + 1] = python_debugger

function debugger.config()
    require("dapui").setup()
    map("n", dapleader("b"), luacmd("require'dap'.toggle_breakpoint()"), { noremap = true, silent = false },
        "toggle breakpoint")
    map("n", dapleader("d"), luacmd("require'dap'.continue()"), { noremap = true, silent = false }, "dap continue")
    map("n", dapleader("o"), luacmd("require'dap'.step_over()"), { noremap = true, silent = false }, "step over")
    map("n", dapleader("i"), luacmd("require'dap'.step_into()"), { noremap = true, silent = false }, "step into")
    map("n", dapleader("r"), luacmd("require'dap'.repl.open()"), { noremap = true, silent = false }, "dap repl open")
    map("v", Mappings.leader("e"), luacmd("require'dapui'.eval()"), { noremap = true, silent = false }, "eval expression")
    -- local dap, dapui = require("dap"), require("dapui")
    -- vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
end

add_plugin(debugger)

