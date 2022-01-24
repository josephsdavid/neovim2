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
	use({ "Yggdroot/hiPairs", event = "BufRead" })
	use({ "axvr/zepl.vim", cmd = { "Repl" }, opt = true })
	use({ "tpope/vim-repeat", event = "BufRead" })
	use({ "tpope/vim-vinegar", event = "BufRead" })
	use({ "tpope/vim-surround", event = "BufRead" })
	use({ "tpope/vim-fugitive", cmd = { "Git" }, opt = true })
	use({ "vimlab/split-term.vim", cmd = { "VTerm", "Term" }, opt = true })
	use({
		"lukas-reineke/indent-blankline.nvim",
		ft = { "python", "lua" },
		config = function()
			require("user.indentline")
		end,
	})
	use("akinsho/toggleterm.nvim")
	use("lewis6991/impatient.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("folke/lsp-colors.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use({ "ray-x/lsp_signature.nvim" })
	use("ray-x/cmp-treesitter")
	use("nvim-treesitter/playground")
	use("arkav/lualine-lsp-progress")
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
		opt = true,
		ft = { "python", "lua" },
	})
	use("romgrk/nvim-treesitter-context")
	use("RRethy/nvim-treesitter-textsubjects")
	use({
		"lewis6991/spellsitter.nvim",
	})
	use({ "elihunter173/dirbuf.nvim", cmd = "Dirbuf" })
	use({ "romgrk/barbar.nvim", requires = { "kyazdani42/nvim-web-devicons" } })
	use({
		"sainnhe/everforest",
		config = function()
			require("colors")
		end,
	})
  use {
    "startup-nvim/startup.nvim",
    requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
    config = function()
      require"startup".setup(require("user.startup"))
    end
  }
  -- use({
  --   "themercorp/themer.lua",
  --   config = function()
  --     require("themer").setup({
  --       colorscheme = "everforest",
  --       transparent = true,
  --       styles = {
  --         comment = { style = 'italic' },
  --         ["function"] = { style = 'italic' },
  --         functionbuiltin = { style = 'italic' },
  --         -- variable = { style = 'italic' },
  --         -- variableBuiltIn = { style = 'italic' },
  --         parameter  = { style = 'italic' },
  --       },
  --     })
  --   end
  -- })
	use("direnv/direnv.vim")
	use({
		"tamton-aquib/duck.nvim",
		config = function()
			vim.api.nvim_set_keymap(
				"n",
				"<leader>dd",
				':lua require("duck").hatch("🐔")<CR>',
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>dc",
				':lua require("duck").cook()<CR>',
				{ noremap = true, silent = true }
			)
		end,
	})
	use({ "xiyaowong/telescope-emoji.nvim",  })

	-- Lua

	use("mfussenegger/nvim-ts-hint-textobject")

	use({
		"pocco81/truezen.nvim",
		cmd = { "TZAtaraxis", "TZFocus", "TZMinimalist" },
    ft = {"norg"},
		config = function()
			require("user.zen")
		end,
	})

	-- HACK
	-- ADD MORE STUFF HERE
	-- Lua
	use({
		"SmiteshP/nvim-gps",
		wants = "nvim-treesitter/nvim-treesitter",
	})
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
	use({ "folke/which-key.nvim" })
	use({
		"numToStr/Comment.nvim",
	})
	use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })

	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("nvim-treesitter/nvim-treesitter-refactor")
	use("lewis6991/gitsigns.nvim")

	use({
		"folke/twilight.nvim",
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("user.telescope")
		end,
    -- module = "telescope",
    -- keys = {
    --   {"n", Keys.telescopeleader("f")},
    --   {"n", Keys.go("r")},
    --   {"n", Keys.telescopeleader("g")},
    --   {"n", Keys.telescopeleader("b")},
    --   {"n", Keys.telescopeleader("h")},
    --   {"n", Keys.telescopeleader("m")},
    --   {"n", Keys.telescopeleader("p")},
    --   {"n", Keys.telescopeleader(" ")},
    --   {"n", Keys.telescopeleader("/")},
    --   {"n", Keys.telescopeleader("R")},
    --   {"n", Keys.telescopeleader("j")},
    --   {"n", Keys.telescopeleader("e")},
    --   {"n", Keys.telescopeleader("D")},
    --   {"n", Keys.telescopeleader("d")},
    --   {"n", Keys.telescopeleader("r")},
    --   {"n", Keys.telescopeleader("t")},
    --   {"n", Keys.harpoonleader("t")},
    -- },
    -- ft = {"norg"}
	})
	use({ "nvim-telescope/telescope-project.nvim",   })
  use({"chentau/marks.nvim"})

	use({
		"nvim-telescope/telescope-frecency.nvim",
		requires = { "tami5/sqlite.lua" },
	})
  use({"ThePrimeagen/harpoon", requires = "nvim-lua/plenary.nvim"})

	use({ "nvim-neorg/neorg", requires = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" } })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
