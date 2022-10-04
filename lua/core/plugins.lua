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
    use "lukas-reineke/cmp-rg"

    use({ "Yggdroot/hiPairs" })
    use({ "tpope/vim-repeat" })
    use({ "tpope/vim-fugitive", cmd = { "Git" } })
    use({ "vimlab/split-term.vim" })
    use({ "akinsho/toggleterm.nvim" })
    use({ "folke/lsp-colors.nvim" })
    use({ "jose-elias-alvarez/null-ls.nvim" })
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
    use({ 'pwntester/octo.nvim', config = function()
        require("config.git")
    end })
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
            vim.g.doom_one_plugin_lspsaga = false
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
    -- use "Olical/conjure"
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
    -- use "PaterJason/cmp-conjure"
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
    -- here is hunk
    -- hunk 2
    -- hunk 3
    use({ "tiagovla/scope.nvim",
        -- hunk
        config = function()
            require("scope").setup()
        end
    })
    -- using packer.nvim
    -- use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons',
    --     config = function()
    --         require('bufferline').setup {
    --             options = {
    --                 indicator = {
    --                     icon = '▎',
    --                     style = "icon"
    --                 },
    --                 -- indicator_icon = '▎',
    --                 buffer_close_icon = '',
    --                 modified_icon = '●',
    --                 close_icon = '',
    --                 left_trunc_marker = '',
    --                 right_trunc_marker = '',
    --                 max_name_length = 18,
    --                 max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    --                 tab_size = 18,
    --                 diagnostics = "nvim_lsp",
    --                 diagnostics_update_in_insert = false,
    --                 -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
    --                 diagnostics_indicator = function(count, _, _, _)
    --                     return "(" .. count .. ")"
    --                 end,
    --                 -- NOTE: this will be called a lot so don't do any heavy processing here
    --                 color_icons = true, -- whether or not to add the filetype icon highlights
    --                 separator_style = "thin" --[[ | "thick" | "slant" | { 'any', 'any' } ]] ,
    --             }
    --         }
    --     end }
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
    })

    use { 'ibhagwan/fzf-lua',
        -- optional for icon support
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
        end
    }

    use({
        "ggandor/lightspeed.nvim",
        config = function()
            require("lightspeed").setup({
                ignore_case = false,
                exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },

                --- s/x ---
                jump_to_unique_chars = { safety_timeout = 400 },
                match_only_the_start_of_same_char_seqs = true,
                force_beacons_into_match_width = true,
                -- Display characters in a custom way in the highlighted matches.
                substitute_chars = { ["\r"] = "¬" },
                -- Leaving the appropriate list empty effectively disables "smart" mode,
                -- and forces auto-jump to be on or off.
                -- These keys are captured directly by the plugin at runtime.
                special_keys = {
                    next_match_group = "<TAB>",
                    prev_match_group = "<S-Tab>",
                },
                --- f/t ---
                limit_ft_matches = 20,
                repeat_ft_with_target_char = true,
            })
            local default_keymaps = {
                { "n", "gs", "<Plug>Lightspeed_omni_s" },
                { "n", "<c-s>", "<Plug>Lightspeed_omni_gs" },
                { "x", "gs", "<Plug>Lightspeed_omni_s" },
                { "x", "<c-s>", "<Plug>Lightspeed_omni_gs" },
                { "o", "gs", "<Plug>Lightspeed_omni_s" },
                { "o", "<c-s>", "<Plug>Lightspeed_omni_gs" },
            }
            for _, m in ipairs(default_keymaps) do
                vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true })
            end
            vim.cmd [[
                let g:lightspeed_last_motion = ''
                augroup lightspeed_last_motion
                autocmd!
                    autocmd User LightspeedSxEnter let g:lightspeed_last_motion = 'sx'
                    autocmd User LightspeedFtEnter let g:lightspeed_last_motion = 'ft'
                augroup end
                map <expr> ; g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
                map <expr> ,, g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"

            ]]
        end
    })
    --- packer
    use "natecraddock/telescope-zf-native.nvim"
    use "haya14busa/vim-asterisk"
    use "tversteeg/registers.nvim"
    use "ThePrimeagen/harpoon"
    use {
        'rlch/github-notifications.nvim',
        config = function()
            require "github-notifications"
        end,
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
    }
    -- use {
    --     "jpalardy/vim-slime",
    --     config = function()
    --         vim.g.slime_target = "tmux"
    --     end
    -- }
    use "simrat39/rust-tools.nvim"
    use "tpope/vim-abolish"
    use("bfredl/nvim-luadev")
    if host_is_not("djosephs") then
        use({
            "NTBBloodbath/daylight.nvim",
            config = function()
                require("daylight").setup({
                    day = {
                        name = vim.g.colors_name,
                        time = 8, -- 8 am
                    },
                    night = {
                        name = vim.g.colors_name,
                        time = 20, -- 7 pm, changes to dark theme on 07:01
                    },
                    interval = 60000, -- Time in milliseconds, 1 minute
                })
            end,
        })
    end
    use { "rafcamlet/tabline-framework.nvim", requires = "kyazdani42/nvim-web-devicons" } -- BROKEN: dev comments
    use "sindrets/diffview.nvim"
    use "rebelot/heirline.nvim"
    use { 'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                signs                        = {
                    add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
                    change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr',
                        linehl = 'GitSignsChangeLn' },
                    delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr',
                        linehl = 'GitSignsDeleteLn' },
                    topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr',
                        linehl = 'GitSignsDeleteLn' },
                    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr',
                        linehl = 'GitSignsChangeLn' },
                },
                signcolumn                   = false, -- Toggle with `:Gitsigns toggle_signs`
                numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir                 = {
                    interval = 1000,
                    follow_files = true
                },
                attach_to_untracked          = true,
                current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts      = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority                = 6,
                update_debounce              = 100,
                status_formatter             = nil, -- Use default
                max_file_length              = 40000, -- Disable if file is longer than this (in lines)
                preview_config               = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                yadm                         = {
                    enable = false
                },
            }
        end
    }
    use {
        'tamton-aquib/duck.nvim',
        config = function()
            vim.api.nvim_set_keymap('n', '<leader>dd', ':lua require("duck").hatch()<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>dk', ':lua require("duck").cook()<CR>', { noremap = true })
        end
    }
    use {
        "jbyuki/venn.nvim",
        config = function()
            -- venn.nvim: enable or disable keymappings
            function _G.Toggle_venn()
                local venn_enabled = vim.inspect(vim.b.venn_enabled)
                if venn_enabled == "nil" then
                    vim.b.venn_enabled = true
                    vim.cmd [[setlocal ve=all]]
                    -- draw a line on HJKL keystokes
                    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
                    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
                    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
                    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
                    -- draw a box by pressing "f" with visual selection
                    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
                else
                    vim.cmd [[setlocal ve=]]
                    vim.cmd [[mapclear <buffer>]]
                    vim.b.venn_enabled = nil
                end
            end

            -- toggle keymappings for venn using <leader>v
            vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true })
        end
    }
    use { "dstein64/vim-startuptime" }
    use({
        "aserowy/tmux.nvim",
        config = function() require("tmux").setup({
                copy_sync = { enable = false },
                navigation = {
                    -- cycles to opposite pane while navigating into the border
                    cycle_navigation = true,

                    -- enables default keybindings (C-hjkl) for normal mode
                    enable_default_keybindings = false,

                    -- prevents unzoom tmux when navigating beyond vim border
                    persist_zoom = false,
                },
            }
            )
        end
    })
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end,
    config = { max_jobs = 25 } }
)
