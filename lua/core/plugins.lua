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
    use({ "kdheepak/cmp-latex-symbols", ft = { "julia", "norg", "query" } })
    use({ "hrsh7th/cmp-nvim-lsp" })
    use({ "hrsh7th/cmp-buffer" })
    use({ "hrsh7th/cmp-path" })
    use({ "hrsh7th/cmp-cmdline" })
    use({ "hrsh7th/nvim-cmp" })
    use({ "saadparwaiz1/cmp_luasnip" })
    use "lukas-reineke/cmp-rg"

    use({ "Yggdroot/hiPairs", })
    use({ "tpope/vim-repeat", })
    use({ "tpope/vim-fugitive", cmd = { "Git" } })
    use({ "vimlab/split-term.vim", cmd = { "Term", "VTerm" } })
    use({ "akinsho/toggleterm.nvim" })
    use({ "folke/lsp-colors.nvim" })
    use({ "jose-elias-alvarez/null-ls.nvim" })
    use({ "rmagatti/goto-preview", event = "LspAttach",
        config = function()
            require("goto-preview").setup({})
        end })
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
	commit = "60eb78255472bd9a2ca483ce70757cfda57cc706",
         config = function()
             vim.cmd [[colorscheme doom-one]]
         end
    })
    -- Or with configuration
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
    -- use 'radenling/vim-dispatch-neovim'
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
    use { 'kdheepak/JuliaFormatter.vim', ft = "julia" }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use({ "pocco81/truezen.nvim" })
    use({ "nvim-neorg/neorg", ft = "norg", cmd = "NeorgStart", config = function()
        require("config.norg")
    end })
    -- use({ "~/projects/neorg", ft = "norg", cmd = "NeorgStart", config = function()
    --     require("config.norg")
    -- end })
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
        "ggandor/leap.nvim",
        config = function()
            require "config.leap".setup()
        end
    })
    --- packer
    use "natecraddock/telescope-zf-native.nvim"
    use { "haya14busa/vim-asterisk", }
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
    use({ "bfredl/nvim-luadev", cmd = "Luadev" })
    if host_is_not("djosephs") then
        use({
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
    use { "rafcamlet/tabline-framework.nvim", requires = "kyazdani42/nvim-web-devicons" } -- BROKEN: dev comments
    use "sindrets/diffview.nvim"
    -- use {
    --     "b0o/incline.nvim",
    --     config = function ()
    --         require('incline').setup()
    --     end
    -- }
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
    use({
        'andymass/vim-matchup',
    })
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use 'anuvyklack/hydra.nvim'

    use {
        'TheBlob42/houdini.nvim',
        config = function()
            require("houdini").setup({
                mappings = { "jk", "AA", "II" },
                escape_sequences = {
                    t = false,
                    i = function(first, second)
                        local seq = first .. second

                        if vim.opt.filetype:get() == "terminal" then
                            return "" -- disabled
                        end

                        if seq == "AA" then
                            -- jump to the end of the line in insert mode
                            return "<BS><BS><End>"
                        end
                        if seq == "II" then
                            -- jump to the beginning of the line in insert mode
                            return "<BS><BS><Home>"
                        end
                        return "<BS><BS><ESC>"
                    end,
                    R = "<BS><BS><ESC>",
                    c = "<BS><BS><C-c>",
                },
            })
        end
    }
    use({
        "ggandor/leap-spooky.nvim",
        config = function() require('leap-spooky').setup { } end
    })
    use "ziglang/zig.vim"

    -- use({
    --   "folke/noice.nvim",
    --   event = "VimEnter",
    --   config = function()
    --     require("noice").setup(
    --             {
    --                 notify = {enabled = false}
    --             }
    --         )
    --   end,
    --   requires = {
    --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --     "MunifTanjim/nui.nvim",
    --     "rcarriga/nvim-notify",
    --     }
    -- })
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end,
    config = { max_jobs = 25 } }
)
