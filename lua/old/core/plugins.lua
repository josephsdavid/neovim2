local fn = vim.fn

local function getHostname()
    local f = io.popen("/bin/hostname")
    local hostname = f:read("*a") or ""
    f:close()
    hostname = string.gsub(hostname, "\n$", "")
    return hostname
end

local function host_is_not(s)
    local hostname = string.lower(getHostname())
    if string.find(hostname, s) then
        return false
    else
        return true
    end
end

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


local function push(tab, new)
    tab[#tab + 1] = new
end

local plugins = {
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        config = function()
            require "config.snippets"
        end
    },
    -- TODO: lazy load cmp
    { 'pwntester/octo.nvim', config = function()
        require("config.git")
    end,
        cmd = "Octo"
    },
    { "nvim-neorg/neorg", ft = "norg", config = function()
        require("config.norg")
    end, dependencies = { "nvim-neorg/neorg-telescope" } },
    { 'TimUntersberger/neogit', dependencies = { 'nvim-lua/plenary.nvim' },
        lazy = true,
        config = function()
            require('neogit').setup {
                disable_commit_confirmation = true,
                use_magit_keybindgs = true
            }
        end
    },
    {
        "ggandor/leap.nvim",
        keys = { "s", "S" },
        config = function()
            require "config.leap".setup()
        end
    },
}

push(plugins, {
    "nvim-telescope/telescope.nvim",
    -- keys = { "<Leader>f", "<C-f>", "<C-p>"},
    cmd = {"Telescope"},
    config = function()
        require("config.telescope")
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-frecency.nvim", dependencies = "kkharji/sqlite.lua" },
        "nvim-telescope/telescope-symbols.nvim",
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
})

require("lazy").setup(plugins,
    { install = {
        -- install missing plugins on startup. This doesn't increase startup time.
        missing = true,
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "doom-one" },
    }, }

)
