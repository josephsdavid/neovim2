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


local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

local function push(tab, new)
    tab[#tab + 1] = new
end

local plugins = {
    "folke/lazy.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "folke/which-key.nvim",
    "neovim/nvim-lspconfig", "kyazdani42/nvim-web-devicons", { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "nvim-treesitter/playground", "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-refactor",
    'nvim-treesitter/nvim-treesitter-context',
    {
        "L3MON4D3/LuaSnip",
        event="InsertEnter",
        config = function ()
            require "config.snippets"
        end
    },
    { "kdheepak/cmp-latex-symbols", ft = { "julia", "norg", "query" } },
    -- TODO: lazy load cmp
    "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp", "saadparwaiz1/cmp_luasnip", "lukas-reineke/cmp-rg",
    "tpope/vim-repeat",
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
    },
    {
        'andymass/vim-matchup',
        setup = function()
            -- may set any options here
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end
    },
    { "tpope/vim-fugitive", cmd = { "Gdiffsplit", "Git" }, config = function()
        vim.cmd [[hi clear DiffText]]
        vim.api.nvim_set_hl(0, 'DiffText', { link = 'DiffChange' })
    end
    },
    { "vimlab/split-term.vim", cmd = { "Term", "VTerm" } },
    { "akinsho/toggleterm.nvim", },
    "folke/lsp-colors.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    { "rmagatti/goto-preview", event = "LspAttach",
        config = function()
            require("goto-preview").setup({})
        end
    },
    "stsewd/tree-sitter-comment",
    {
        'numToStr/Comment.nvim',
        config = function()
            require("Comment").setup()
        end
    },
    "haringsrob/nvim_context_vt",
    { "jghauser/mkdir.nvim" },
    "direnv/direnv.vim",
    { 'pwntester/octo.nvim', config = function()
        require("config.git")
    end,
        cmd = "Octo"
    },
    {
        "amrbashir/nvim-docs-view",
        cmd = { "DocsViewToggle" },
        config = function()
            require("docs-view").setup {
                position = "bottom",
                width = 60,
            }
        end
    },
    {
        'NTBBloodbath/doom-one.nvim',
        config = function()
            vim.g.doom_one_cursor_coloring = true
            -- Set :terminal colors
            vim.g.doom_one_terminal_colors = true
            -- Enable italic comments
            vim.g.doom_one_italic_comments = true
            -- Enable TS support
            vim.g.doom_one_enable_treesitter = true
            -- Color whole diagnostic text or only underline
            vim.g.doom_one_diagnostics_text_color = false
            -- Enable transparent background
            vim.g.doom_one_transparent_background = false

            -- Pumblend transparency
            vim.g.doom_one_pumblend_enable = false
            vim.g.doom_one_pumblend_transparency = 20

            -- Plugins integration
            vim.g.doom_one_plugin_neorg = true
            vim.g.doom_one_plugin_barbar = false
            vim.g.doom_one_plugin_telescope = false
            vim.g.doom_one_plugin_neogit = true
            vim.g.doom_one_plugin_nvim_tree = false
            vim.g.doom_one_plugin_dashboard = false
            vim.g.doom_one_plugin_startify = false
            vim.g.doom_one_plugin_whichkey = true
            vim.g.doom_one_plugin_indent_blankline = false
            vim.g.doom_one_plugin_vim_illuminate = true
            vim.g.doom_one_plugin_lspsaga = false
            vim.cmd [[colorscheme doom-one]]

        end
    },
    "antoinemadec/FixCursorHold.nvim",
    { "mtikekar/nvim-send-to-term", cmd = "SendHere", config = function()
        vim.g.send_disable_mapping = true
    end },
    {
        'abecodes/tabout.nvim',
        config = function()
            require('tabout').setup {
                tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
                backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
                act_as_tab = true, -- shift content if tab out is not possible
                act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
                default_shift_tab = '<C-d>', -- reverse shift default action,
                enable_backwards = true, -- well ...
                completion = true, -- if the tabkey is used in a completion pum
                tabouts = {
                    { open = "'", close = "'" },
                    { open = '"', close = '"' },
                    { open = '`', close = '`' },
                    { open = '(', close = ')' },
                    { open = '[', close = ']' },
                    { open = '{', close = '}' }
                },
                ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                exclude = {} -- tabout will ignore these filetypes
            }
        end,
    },
    "tjdevries/complextras.nvim",
    "onsails/lspkind.nvim",
    { 'j-hui/fidget.nvim',
        config = function()
            require "fidget".setup()
        end
    },
    { 'kdheepak/JuliaFormatter.vim', cmd = "JuliaFormatterFormat" },
    { "pocco81/true-zen.nvim",
        cmd = "TZAtaraxis",
        config = function()
            require("true-zen").setup({
                modes = {
                    ataraxis = {
                        padding = {
                            left = 24,
                            right = 24,
                            top = 12,
                            bottom = 12
                        }
                    }
                }
            })
        end
    },
    { "nvim-neorg/neorg", ft = "norg", config = function()
        require("config.norg")
    end, dependencies = { "nvim-neorg/neorg-telescope" } },
    { "tiagovla/scope.nvim",
        config = function()
            require("scope").setup()
        end
    },
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
        "kylechui/nvim-surround",
        keys = { "<C-s>", "ys", "yss", "yS", "ySS", "S", "gS", "ds", "cs" },
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    insert_line = "<C-s>",
                    normal = "ys",
                    normal_cur = "yss",
                    normal_line = "yS",
                    normal_cur_line = "ySS",
                    visual = "S",
                    visual_line = "gS",
                    delete = "ds",
                    change = "cs",
                },
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    { 'ibhagwan/fzf-lua',
        config = function()
            vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
        end
    },
    {
        "ggandor/leap.nvim",
        keys = { "s", "S" },
        config = function()
            require "config.leap".setup()
        end
    },
    { "haya14busa/vim-asterisk", keys = { "*", "z*", "g*", "#", "z#", "g#" } },
    "ThePrimeagen/harpoon",
    "rafcamlet/tabline-framework.nvim",
    "sindrets/diffview.nvim",
    {
        "aserowy/tmux.nvim",
        lazy=true,
        config = function() require("tmux").setup({
                copy_sync = { enable = false },
                navigation = {
                    -- cycles to opposite pane while navigating into the border
                    cycle_navigation = false,

                    -- enables default keybindings (C-hjkl) for normal mode
                    enable_default_keybindings = false,

                    -- prevents unzoom tmux when navigating beyond vim border
                    persist_zoom = false,
                },
            }
            )
        end
    },
    {
        "folke/todo-comments.nvim",
        config = function()
            require("todo-comments").setup {
            }
        end
    },
    "anuvyklack/hydra.nvim",
    {
        'lukas-reineke/headlines.nvim',
        ft = { "markdown", "norg" },
        config = function()
            require("headlines").setup({
                norg = {
                    headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6" },
                    codeblock_highlight = { "NeorgCodeBlock" },
                }
            })
        end
    },
}

push(plugins, {
    "nvim-telescope/telescope.nvim",
    -- keys = { "<Leader>f", "<C-f>", "<C-p>"},
    -- cmd = {"Telescope"},
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

if host_is_not("djosephs") then
    push(plugins, {
        "NTBBloodbath/daylight.nvim",
        config = function()
            vim.cmd([[colorscheme doom-one]])
            require("daylight").setup({
                day = {
                    name = vim.g.colors_name,
                    time = 8, -- 8 am
                },
                night = {
                    name = vim.g.colors_name,
                    time = 19, -- 7 pm, changes to dark theme on 07:01
                },
                interval = 60000, -- Time in milliseconds, 1 minute
            })
        end,
    })
end

require("lazy").setup(plugins,
    { install = {
        -- install missing plugins on startup. This doesn't increase startup time.
        missing = true,
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "doom-one" },
    }, }

)
