vim.cmd [[packadd packer.nvim]]
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
  use({ "kdheepak/JuliaFormatter.vim"})
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
        change_directory_command = "lcd", -- default: "cd",
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
  use({ "ggandor/leap.nvim" })
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
  use({ "folke/lua-dev.nvim" })
  use({ "rmagatti/goto-preview" })
  use({ "rebelot/kanagawa.nvim" })
  use({ "ThePrimeagen/refactoring.nvim" })
  use({ "abecodes/tabout.nvim" })
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
  use "ziontee113/syntax-tree-surfer"
  use {"chentoast/marks.nvim",
    config = function ()
      require'marks'.setup {
        -- whether to map keybinds or not. default true
        default_mappings = true,
        -- which builtin marks to show. default {}
        builtin_marks = {},
        -- whether movements cycle back to the beginning/end of buffer. default true
        cyclic = true,
        -- whether the shada file is updated after modifying uppercase marks. default false
        force_write_shada = false,
        -- how often (in ms) to redraw signs/recompute mark positions.
        -- higher values will have better performance but may cause visual lag,
        -- while lower values may cause performance penalties. default 150.
        refresh_interval = 250,
        -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
        -- marks, and bookmarks.
        -- can be either a table with all/none of the keys, or a single number, in which case
        -- the priority applies to all marks.
        -- default 10.
        sign_priority = { lower=10, upper=15, builtin=0, bookmark=20 },
        -- disables mark tracking for specific filetypes. default {}
        excluded_filetypes = {},
        -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
        -- sign/virttext. Bookmarks can be used to group together positions and quickly move
        -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
        -- default virt_text is "".
        bookmark_0 = {
          sign = "⚑",
          virt_text = "hello world"
        },
        mappings = {}
      }
    end
  }
end
)
