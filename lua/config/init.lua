local plugins = {}

-- utilities to add plugins to our big ole list of plugins
-- add a single plugin
local function pushconfig(t)
    plugins[#plugins + 1] = t
end

-- add a list of plugins
local function appendconfig(t)
    for _, value in ipairs(t) do
        plugins[#plugins + 1] = value
    end
end

-- add all the plugins which dont require major configuration
appendconfig(require("config.simple_plugins"))

-- list of modules found in this directory, which return
-- plugins + their dependencies configured
local enabled_modules = {
    "telescope",
    "completion",
    "norg",
    "treesitter",
    "leap", "git",
    "lsp"
}

-- if we are not on work server, enable the "daylight" module
local f = io.popen("/bin/hostname")
local hostname = f:read("*a") or ""
f:close()
hostname = string.gsub(hostname, "\n$", "")
if not string.find(string.lower(hostname), "djosephs") then
    enabled_modules[#enabled_modules + 1] = "daylight"
end

-- push all the enabled modules to our big list of plugins
for _, value in ipairs(enabled_modules) do
    pushconfig(require("config." .. value))
end

-- load in options and vim only configuration
require "config.options".setup()

-- bootstrap package manager
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

-- instantiate all the packages with their configurations
require("lazy").setup(
    plugins,
    { install = {
        -- install missing plugins on startup. This doesn't increase startup time.
        missing = true,
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "doom-one" },
    },
        performance = { rtp = { disabled_plugins = {
            "gzip",
            -- "matchit",
            -- "matchparen",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
        } } },
    }
)

-- setup other more complex configuration options
-- require("config.lsp").setup()
require("config.toggleterm")
require("config.ui")
require("config.autocmds")
