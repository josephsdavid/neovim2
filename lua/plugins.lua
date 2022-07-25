vim.cmd [[packadd packer.nvim]]
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]
require 'packer'.init({
  max_jobs = 50
})

require 'packer'.startup(function(use)

  use 'wbthomason/packer.nvim'
  use 'lewis6991/impatient.nvim'
  use({ "nvim-telescope/telescope.nvim" })
  use({ "nvim-lua/plenary.nvim" })
  use({ "neovim/nvim-lspconfig" })
  use({ "max397574/which-key.nvim" })
  use({ "kdheepak/JuliaFormatter.vim" })
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "rktjmp/lush.nvim" })
  use({ "mcchrish/zenbones.nvim" })
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
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
  use({ 'ThePrimeagen/git-worktree.nvim',
    config = function()
      require("git-worktree").setup({
        change_directory_command = "tcd", -- default: "cd",
        -- update_on_change = <boolean> -- default: true,
        -- update_on_change_command = <str> -- default: "e .",
        -- clearjumps_on_change = <boolean> -- default: true,
        -- autopush = <boolean> -- default: false,
      })
    end
  })
  use({ "tpope/vim-fugitive" })
  use({ "vimlab/split-term.vim" })
  use({ "akinsho/toggleterm.nvim" })
  use({ "folke/lsp-colors.nvim" })
  use({ "jose-elias-alvarez/null-ls.nvim" })
  use({ "ray-x/lsp_signature.nvim" })
  use({ "ray-x/cmp-treesitter" })
  use({ "nvim-treesitter/playground" })
  use({ "arkav/lualine-lsp-progress" })
  use({ "josephsdavid/neogen", branch = "dj/add-julia-support" })
  use({ "direnv/direnv.vim"; })
  use({ "tamton-aquib/duck.nvim" })
  use({ "williamboman/nvim-lsp-installer" })
  use({ "xiyaowong/telescope-emoji.nvim" })
  use({ "mfussenegger/nvim-ts-hint-textobject" })
  use({ "pocco81/truezen.nvim" })
  use({ "SmiteshP/nvim-gps" })
  use({ "nvim-lualine/lualine.nvim" })
  use({ "nvim-treesitter/nvim-treesitter-textobjects" })
  use({ "nvim-treesitter/nvim-treesitter-refactor" })
  use({ "folke/twilight.nvim" })
  use({ "nvim-telescope/telescope-project.nvim" })
  use({ "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" } })
  use({ "romgrk/nvim-treesitter-context" })
  use({ 'lewis6991/spellsitter.nvim', })
  use({ "romgrk/barbar.nvim" })
  use({ "nvim-neorg/neorg-telescope" })
  use({ "nvim-neorg/neorg" })
  use({ "nvim-telescope/telescope-symbols.nvim" })
  use({ "mtikekar/nvim-send-to-term" })
  use({ "rmagatti/goto-preview" })
  use({ "rebelot/kanagawa.nvim" })
  use({ "ThePrimeagen/refactoring.nvim" })
  use({ "folke/todo-comments.nvim" })
  use({ 'numToStr/Comment.nvim' })
  use({ "kevinhwang91/nvim-bqf" })
  use({ "ten3roberts/qf.nvim" })
  use({ "junegunn/fzf" })
  use({ "ibhagwan/fzf-lua" })
  use({ "sainnhe/everforest" })
  use({ "jbyuki/venn.nvim" })
  use({ "andreasvc/vim-256noir" })
  use({ "GustavoPrietoP/doom-themes.nvim" })
  use({ "pianocomposer321/yabs.nvim" })
  use({ "haringsrob/nvim_context_vt" })
  use({ 'jghauser/mkdir.nvim' })
  use 'zane-/cder.nvim'
  use({ 'pwntester/octo.nvim' })
  use({
    "andweeb/presence.nvim",
    config = function()
      require("presence"):setup({
        enable_line_number = true,
      })
    end,
  })
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
  use "ziontee113/syntax-tree-surfer"
  use "unblevable/quick-scope"
  use 'clojure-vim/vim-jack-in'
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
  use "https://gitlab.com/yorickpeterse/vim-paper"
  use("shaunsingh/seoul256.nvim")
  use("guns/vim-sexp")
  use("tpope/vim-sexp-mappings-for-regular-people")
  use("andymass/vim-matchup")
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

end
)
