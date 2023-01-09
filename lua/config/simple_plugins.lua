return {
    "folke/lazy.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "folke/which-key.nvim",
    "neovim/nvim-lspconfig", "kyazdani42/nvim-web-devicons",
    "tpope/vim-repeat",
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
    },
    { "Yggdroot/hiPairs",
        event = "BufRead",
        config = function()
            vim.g["hiPairs_timeout"] = 1
            vim.g["hiPairs_insert_timeout"] = 1
            vim.g["hiPairs_hl_matchPair"] = { term = 'underline,bold', cterm = 'underline,bold', ctermfg = '0', ctermbg = '180',
                gui = 'underline,bold,italic', guifg = '#fb94ff', guibg = 'NONE' }

        end
    },
    { "tpope/vim-fugitive", cmd = { "Gdiffsplit", "Git" }, config = function()
        vim.cmd [[hi clear DiffText]]
        vim.api.nvim_set_hl(0, 'DiffText', { link = 'DiffChange' })
    end
    },
    { "vimlab/split-term.vim", cmd = { "Term", "VTerm" } },
    { "akinsho/toggleterm.nvim", },
    { "folke/lsp-colors.nvim", event = "LspAttach" },
    "jose-elias-alvarez/null-ls.nvim",
    { "rmagatti/goto-preview", event = "LspAttach",
        config = function()
            require("goto-preview").setup({})
        end
    },
    "jghauser/mkdir.nvim",
    { "direnv/direnv.vim", event = "BufRead" },
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
            vim.g.doom_one_terminal_colors = true
            vim.g.doom_one_italic_comments = true
            vim.g.doom_one_enable_treesitter = true
            vim.g.doom_one_diagnostics_text_color = false
            vim.g.doom_one_transparent_background = false

            vim.g.doom_one_pumblend_enable = false
            vim.g.doom_one_pumblend_transparency = 20

            vim.g.doom_one_plugin_neorg = true
            vim.g.doom_one_plugin_barbar = false
            vim.g.doom_one_plugin_telescope = true
            vim.g.doom_one_plugin_neogit = true
            vim.g.doom_one_plugin_nvim_tree = false
            vim.g.doom_one_plugin_dashboard = false
            vim.g.doom_one_plugin_startify = false
            vim.g.doom_one_plugin_whichkey = true
            vim.g.doom_one_plugin_indent_blankline = false
            vim.g.doom_one_plugin_vim_illuminate = false
            vim.g.doom_one_plugin_lspsaga = false
        end
    },
    "antoinemadec/FixCursorHold.nvim",
    { "mtikekar/nvim-send-to-term", cmd = "SendHere", config = function()
        vim.g.send_disable_mapping = true
    end },
    { 'j-hui/fidget.nvim',
        event = "LspAttach",
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
    { "tiagovla/scope.nvim",
        config = function()
            require("scope").setup()
        end
    },
    {
        "kylechui/nvim-surround",
        keys = { "<C-s>", "ys", "yss", "yS", "ySS", "S", "gS", "ds", "cs" },
        events= {"InsertEnter"},
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
    { "haya14busa/vim-asterisk" },
    "ThePrimeagen/harpoon",
    "rafcamlet/tabline-framework.nvim",
    {
        "aserowy/tmux.nvim",
        lazy = true,
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
    { 'TimUntersberger/neogit', dependencies = { 'nvim-lua/plenary.nvim' },
        lazy = true,
        config = function()
            require('neogit').setup {
                disable_commit_confirmation = true,
                use_magit_keybindgs = true
            }
        end
    },
}
