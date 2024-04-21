local map = Mappings.keymap
local cmd = Mappings.cmd
local luacmd = Mappings.luacmd
local testing = {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python"
    }
}

function testing.config()
    require("neotest").setup({
        adapters = {
            require("neotest-python") -- https://github.com/nvim-neotest/neotest-python
        }
    })

    local testleader = Mappings.extendleader(Mappings.localleader, "t")
    map("n", testleader("R"), luacmd("require('neotest').run.run()"), {noremap=true, silent=false}, "run nearest test")
    map("n", testleader("r"), luacmd("require('neotest').run.run(vim.fn.expand('%'))"), {noremap=true, silent=false}, "run all tests in file")
    map("n", testleader("d"), luacmd("require('neotest').run.run({strategy = 'dap'})"), {noremap=true, silent=false}, "debug nearest tests")
    map("n", testleader("k"), luacmd("require('neotest').run.stop()"), {noremap=true, silent=false}, "stop tests")
    map("n", testleader("a"), luacmd("require('neotest').run.attach()"), {noremap=true, silent=false}, "attach tests")
    map("n", testleader("o"), cmd("Neotest output-panel"), {noremap=true, silent=false}, "toggle test ouptut panel")
    map("n", testleader("i"), cmd("Neotest summary"), {noremap=true, silent=false}, "toggle test summary")
    map("n", testleader("w"), luacmd("require('neotest').watch.toggle(vim.fn.expand('%'))"), {noremap=true, silent=false}, "watch tests for current file")
    map("n", testleader("p"), luacmd("require('neotest').watch.toggle(vim.fn.expand('%:p:h'..'/'))"), {noremap=true, silent=false}, "watch tests for current directory")
    map("n", Mappings.alt("t"), cmd("Neotest output"), {noremap=true, silent=false}, "nearest test output")
end

add_plugin(testing)
