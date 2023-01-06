local plugins = {}
local function pushconfig(t)
    plugins[#plugins+1] = t
end
local function appendconfig(t)
    for _, value in ipairs(t) do
        plugins[#plugins+1] = value
    end
end

appendconfig(require("config.simple_plugins"))

local enabled_modules = {
    -- "daylight", "telescope", "snippets", "completion", "norg",
    "treesitter",
    "leap", "git"
}


for _, value in ipairs(enabled_modules) do
    pushconfig(require("config." .. value))
    -- TODO: refactor the rest of the plugins to be good
end

return {
    setup = function()
        -- load in options and vim only configuration
        require "config.options".setup()

        -- bootstrap lazy
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
            vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "--single-branch",
                "https://github.com/folke/lazy.nvim.git",
                lazypath,
            })
        end
        vim.opt.runtimepath:prepend(lazypath)
        require("lazy").setup(
            plugins,
            { install = {
                -- install missing plugins on startup. This doesn't increase startup time.
                missing = true,
                -- try to load one of these colorschemes when starting an installation during startup
                colorscheme = { "doom-one" },
            }, }
        )

        require("config.lsp").setup()
        require("config.toggleterm").setup()
        require("config.ui").setup()
        require("config.autocmds").setup()
    end,
}
