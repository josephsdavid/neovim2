local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

packer.init {}

-- Install your plugins here
return packer.startup({ function(use)
    use 'lewis6991/impatient.nvim' -- My plugins here
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    use({ "nvim-telescope/telescope.nvim" })
    use({ "neovim/nvim-lspconfig" })
    -- Lua
    use {
        "max397574/which-key.nvim",
        config = function()
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use({ "kyazdani42/nvim-web-devicons" })
    use({ "rktjmp/lush.nvim" })
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use({ "nvim-treesitter/playground" })
    use({ "nvim-treesitter/nvim-treesitter-textobjects" })
    use({ "nvim-treesitter/nvim-treesitter-refactor" })
    use 'nvim-treesitter/nvim-treesitter-context'
    use({ "L3MON4D3/LuaSnip" })
    use({ "kdheepak/cmp-latex-symbols" })
    use({ "hrsh7th/cmp-nvim-lsp" })
    use({ "hrsh7th/cmp-buffer" })
    use({ "hrsh7th/cmp-path" })
    use({ "hrsh7th/cmp-cmdline" })
    use({ "hrsh7th/nvim-cmp" })
    use({ "saadparwaiz1/cmp_luasnip" })
    use({ "Yggdroot/hiPairs" })
    use({ "tpope/vim-repeat" })
    use({ "tpope/vim-vinegar" })
    use({ "tpope/vim-fugitive" })
    use({ "vimlab/split-term.vim" })
    use({ "akinsho/toggleterm.nvim" })
    use({ "folke/lsp-colors.nvim" })
    use({ "jose-elias-alvarez/null-ls.nvim" })
    use({ "glepnir/lspsaga.nvim" })
    use({ "rmagatti/goto-preview" })
    -- Lua
    use "stsewd/tree-sitter-comment"

    use({
        'numToStr/Comment.nvim',
        config = function()
            require("Comment").setup()
        end
    })
    use({ "haringsrob/nvim_context_vt" })
    use({ 'jghauser/mkdir.nvim' })
    use "direnv/direnv.vim"
    use 'zane-/cder.nvim'
    use({ 'pwntester/octo.nvim' })
    use {
        "amrbashir/nvim-docs-view",
        opt = true,
        cmd = { "DocsViewToggle" },
        config = function()
            require("docs-view").setup {
                position = "bottom",
                width = 60,
            }
        end
    }

    use({
        'NTBBloodbath/doom-one.nvim',
        setup = function()
            -- Add color to cursor
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
            vim.g.doom_one_plugin_bufferline = true
            vim.g.doom_one_plugin_telescope = true
            vim.g.doom_one_plugin_neogit = true
            vim.g.doom_one_plugin_nvim_tree = true
            vim.g.doom_one_plugin_dashboard = true
            vim.g.doom_one_plugin_startify = true
            vim.g.doom_one_plugin_whichkey = true
            vim.g.doom_one_plugin_indent_blankline = true
            vim.g.doom_one_plugin_vim_illuminate = true
            vim.g.doom_one_plugin_lspsaga = true
        end,
        -- config = function()
        --     vim.cmd [[colorscheme doom-one]]
        -- end


    })

    use { "chentoast/marks.nvim",
        config = function()
            require 'marks'.setup {
                default_mappings = true,
                builtin_marks = {},
                cyclic = true,
                force_write_shada = false,
                refresh_interval = 250,
                sign_priority = { lower = 10, upper = 15, builtin = 0, bookmark = 20 },
                excluded_filetypes = {},
                mappings = {}
            }
        end
    }

    use "antoinemadec/FixCursorHold.nvim"
    use "unblevable/quick-scope"
    use 'radenling/vim-dispatch-neovim'
    use "Olical/conjure"
    use "Olical/aniseed"
    use {
        "X3eRo0/dired.nvim",
        requires = "MunifTanjim/nui.nvim",
        config = function()
            require("dired").setup {
                path_separator = "/",
                show_banner = false,
                show_hidden = true
            }
        end
    }
    use "gpanders/nvim-parinfer"
    use "PaterJason/cmp-conjure"
    use("guns/vim-sexp")
    use("tpope/vim-sexp-mappings-for-regular-people")
    use("andymass/vim-matchup")
    use {
        -- Optional but recommended
        -- 'nvim-treesitter/nvim-treesitter',
        'lewis6991/spellsitter.nvim',
    }
    use "mtikekar/nvim-send-to-term"
    use "nvim-telescope/telescope-symbols.nvim"
    -- Lua
    use {
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
        wants = { 'nvim-treesitter' }, -- or require if not used so far
        after = { "nvim-cmp" } -- if a completion plugin is using tabs load it before
    }
    use 'tjdevries/complextras.nvim'
    use 'onsails/lspkind.nvim'
    use {
        'chipsenkbeil/distant.nvim',
        config = function()
            require('distant').setup {
                -- Applies Chip's personal settings to every machine you connect to
                --
                -- 1. Ensures that distant servers terminate with no connections
                -- 2. Provides navigation bindings for remote directories
                -- 3. Provides keybinding to jump into a remote file's parent directory
                ['*'] = require('distant.settings').chip_default()
            }
        end
    }

    use { 'j-hui/fidget.nvim',
        config = function()
            require "fidget".setup()
        end
    }
    -- use {
    --     "windwp/nvim-autopairs",
    --     config = function() require("nvim-autopairs").setup {} end
    -- }
    use 'kdheepak/JuliaFormatter.vim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use({ "pocco81/truezen.nvim" })
    use({ "nvim-neorg/neorg" })
    use({ "nvim-neorg/neorg-telescope" })
    use("khzaw/vim-conceal")
    use({ "mcchrish/zenbones.nvim" })
    use({ "tiagovla/scope.nvim",
        config = function()
            require("scope").setup()
        end
    })
    -- using packer.nvim
    use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('bufferline').setup {
                options = {
                    indicator_icon = '▎',
                    buffer_close_icon = '',
                    modified_icon = '●',
                    close_icon = '',
                    left_trunc_marker = '',
                    right_trunc_marker = '',
                    max_name_length = 18,
                    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
                    tab_size = 18,
                    diagnostics = "nvim_lsp",
                    diagnostics_update_in_insert = false,
                    -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
                    diagnostics_indicator = function(count, _, _, _)
                        return "(" .. count .. ")"
                    end,
                    -- NOTE: this will be called a lot so don't do any heavy processing here
                    color_icons = true, -- whether or not to add the filetype icon highlights
                    separator_style = "thin" --[[ | "thick" | "slant" | { 'any', 'any' } ]] ,
                }
            }
        end }
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('neogit').setup {
                disable_commit_confirmation = true,
                use_magit_keybindgs = true
            }
        end
    }
    use({
        "quarto-dev/quarto-vim",
        requires = {
            { "vim-pandoc/vim-pandoc-syntax" },
        },
        ft = { "quarto" },
    })
    use({
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    insert = "<C-h>s",
                    insert_line = "<C-h>S",
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
    })

    use { 'ibhagwan/fzf-lua',
        -- optional for icon support
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
        end
    }

    use({
        "ggandor/leap.nvim",
        config = function()
            local leap = require('leap')
            vim.cmd([[autocmd ColorScheme * lua require('leap').init_highlight(true)]])
            leap.setup {
                max_aot_targets = nil,
                highlight_unlabeled = false,
                case_sensitive = false,
                -- Groups of characters that should match each other.
                -- Obvious candidates are braces & quotes ('([{', ')]}', '`"\'').
                character_classes = {
                    ' \t\r\n',
                    ')]}>',
                    '([{<',
                    { '"', "'", '`' },
                },
                -- Leaving the appropriate list empty effectively disables "smart" mode,
                -- and forces auto-jump to be on or off.
                -- safe_labels = { . . . },
                -- labels = { . . . },
                -- These keys are captured directly by the plugin at runtime.
                -- (For `prev_match`, I suggest <s-enter> if possible in the terminal/GUI.)
                special_keys = {
                    repeat_search = '<enter>',
                    next_match    = '<space>',
                    prev_match    = '<C-space>',
                    next_group    = '<tab>',
                    prev_group    = '<S-tab>',
                },
            }
            leap.set_default_keymaps()
        end
    })
    --- packer
    use "natecraddock/telescope-zf-native.nvim"
    use "haya14busa/vim-asterisk"
    use "tversteeg/registers.nvim"


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end,
config = { max_jobs = 25 } }
)
