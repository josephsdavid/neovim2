local fn = vim.fn
-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

packer.startup({
	{ ... },
	config = {
		-- Move to lua dir so impatient.nvim can cache it
		compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	use("L3MON4D3/LuaSnip")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use("saadparwaiz1/cmp_luasnip")
	use("Rigellute/rigel")
	use("Yggdroot/hiPairs")
	use("axvr/zepl.vim")
	use("tpope/vim-repeat")
	use("tpope/vim-vinegar")
	use("tpope/vim-surround")
	use("tpope/vim-fugitive")
	use("vimlab/split-term.vim")
	use("lukas-reineke/indent-blankline.nvim")
	use("akinsho/toggleterm.nvim")
	use("lewis6991/impatient.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("folke/lsp-colors.nvim")
	use("folke/tokyonight.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })
	use({ "ray-x/lsp_signature.nvim" })
	use("ray-x/cmp-treesitter")
  use("nvim-treesitter/playground")
  use 'arkav/lualine-lsp-progress'
	use({
		"danymat/neogen",
		config = function()
			require("neogen").setup({
				enabled = true,
				languages = {
					python = {
						template = {
							annotation_convention = "numpydoc",
						},
					},
				},
			})
		end,
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use("jbyuki/instant.nvim")
	use("jbyuki/dash.nvim")
	use("romgrk/nvim-treesitter-context")
	use("RRethy/nvim-treesitter-textsubjects")
	use({
		"lewis6991/spellsitter.nvim",
	})
	use("elihunter173/dirbuf.nvim")
  use { 'romgrk/barbar.nvim', requires = {'kyazdani42/nvim-web-devicons'} }
  use('sainnhe/everforest')
  use('direnv/direnv.vim')
  use {
    'tamton-aquib/duck.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>dd', ':lua require("duck").hatch("🐔")<CR>', {noremap=true, silent = true})
      vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require("duck").cook()<CR>', {noremap=true, silent = true})
    end
  }
  use 'xiyaowong/telescope-emoji.nvim'
-- Lua

  use "mfussenegger/nvim-ts-hint-textobject"


  use "Pocco81/TrueZen.nvim"

	-- HACK
	-- ADD MORE STUFF HERE
-- Lua
  use {
    "SmiteshP/nvim-gps",
    wants = "nvim-treesitter/nvim-treesitter"
  }
	use({
		"phaazon/hop.nvim",
		branch = "v1", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({
				-- keys = 'etovxqpdygfblzhckisuran'
			})
		end,
	})
	use({
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({})
		end,
	})
	use({ "mcchrish/zenbones.nvim", requires = "rktjmp/lush.nvim" })
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })

	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("nvim-treesitter/nvim-treesitter-refactor")

	use({
		"folke/twilight.nvim",
		config = function()
			require("twilight").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })
	use("nvim-telescope/telescope-project.nvim")
	use({
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		requires = { "tami5/sqlite.lua" },
	})

	use({ "nvim-neorg/neorg", requires = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" } })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
