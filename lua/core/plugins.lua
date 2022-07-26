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
return packer.startup(function(use)
    -- My plugins here
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
    use({ "tpope/vim-surround" })
    use({ "tpope/vim-fugitive" })
    use({ "vimlab/split-term.vim" })
    use({ "akinsho/toggleterm.nvim" })
    use({ "folke/lsp-colors.nvim" })
    use({ "jose-elias-alvarez/null-ls.nvim" })
    use({ "glepnir/lspsaga.nvim" })
    use({ "rmagatti/goto-preview" })
    use({ "folke/todo-comments.nvim" })
    use({ 'numToStr/Comment.nvim' })
    use({ "haringsrob/nvim_context_vt" })
    use({ 'jghauser/mkdir.nvim' })
    use"direnv/direnv.vim"
    use 'zane-/cder.nvim'
    use({ 'pwntester/octo.nvim' })
    use {
        "amrbashir/nvim-docs-view",
        opt = true,
        cmd = { "DocsViewToggle" },
        config = function()
            require("docs-view").setup {
                position = "right",
                width = 60,
            }
        end
    }

    use({
        'NTBBloodbath/doom-one.nvim',
        config = function()
            require('doom-one').setup({
                cursor_coloring = true,
                terminal_colors = true,
                italic_comments = true,
                enable_treesitter = true,
                transparent_background = false,
                pumblend = {
                    enable = true,
                    transparency_amount = 20,
                },
                plugins_integrations = {
                    neorg = true,
                    barbar = true,
                    bufferline = false,
                    gitgutter = false,
                    gitsigns = true,
                    telescope = true,
                    neogit = true,
                    nvim_tree = true,
                    dashboard = true,
                    startify = true,
                    whichkey = true,
                    indent_blankline = true,
                    vim_illuminate = true,
                    lspsaga = true,
                },
            })
        end,
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
    after = { "nvim-cmp"} -- if a completion plugin is using tabs load it before
}

-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if PACKER_BOOTSTRAP then
    require("packer").sync()
end
end)
