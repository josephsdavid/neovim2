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
	use("kdheepak/cmp-latex-symbols")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use("saadparwaiz1/cmp_luasnip")
	use({ "Yggdroot/hiPairs", event = "BufRead" })
	-- use({ "axvr/zepl.vim", cmd = { "Repl" }, opt = true })
	use({ "tpope/vim-repeat", event = "BufRead" })
	-- use({ "tpope/vim-vinegar", event = "BufRead" })
	use({ "tpope/vim-surround", event = "BufRead" })
	-- use({
	--    "blackCauldron7/surround.nvim",
	--    event = "BufRead",
	--    config = function ()
	--     require('surround').setup{
	--       mappings_style = "surround",
	--       pairs = {
	--         nestable = { b = { "(", ")" }, s = { "[", "]" }, B = { "{", "}" }, a = { "<", ">" }, S = {"*","*"} },
	--         linear = { q = { "'", "'" }, t = { "`", "`" }, d = { '"', '"' }
	--       },
	--     }
	--   }
	--    end
	--  })
  use 'mizlan/iswap.nvim'
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
	use({
	  'j-hui/fidget.nvim',
	config = function()
		require("fidget").setup()
	end,
	})
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
	})
	use("romgrk/nvim-treesitter-context")
	use("RRethy/nvim-treesitter-textsubjects")
	use({
		"lewis6991/spellsitter.nvim",
	})
	-- use({ "elihunter173/dirbuf.nvim", cmd = "Dirbuf" })
	use({ "romgrk/barbar.nvim", requires = { "kyazdani42/nvim-web-devicons" }, event = "BufWinEnter" })
  -- use({"noib3/nvim-cokeline",requires = { "kyazdani42/nvim-web-devicons" } })
	use({
		"sainnhe/everforest",
	})
  use {
      "mcchrish/zenbones.nvim",
      requires = "rktjmp/lush.nvim"
  }
  use 'folke/tokyonight.nvim'
	use({ "echasnovski/mini.nvim", requires = { "lewis6991/gitsigns.nvim", "kyazdani42/nvim-web-devicons" } })
	use({
		"startup-nvim/startup.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("startup").setup(require("user.startup"))
		end,
	})
	-- use({
	-- 	"themercorp/themer.lua",
	-- 	config = function()
	-- 		require("themer").setup({
	-- 			-- colorscheme = "everforest",
	-- 			transparent = false,
	-- 			styles = {
	-- 				comment = { style = "italic" },
	-- 				-- ["function"] = { style = 'italic' },
	-- 				functionbuiltin = { style = "italic" },
	-- 				type = { style = "italic" },
	-- 				typeBuiltIn = { style = "italic" },
	-- 				-- variable = { style = 'italic' },
	-- 				variableBuiltIn = { style = "italic" },
	-- 				-- parameter  = { style = 'italic' },
	-- 			},
	--
	-- 			remaps = {
	-- 				palette = {
	-- 					everforest = {
	-- 						bg = {
	-- 							base = "#323d43",
	--                selected = '#4b565c',
	-- 						},
	-- 					},
	-- 				},
	-- 				-- per colorscheme palette remaps, for example:
	-- 				-- remaps.palette = {
	-- 				--     rose_pine = {
	-- 				--     	fg = "#000000"
	-- 				--     }
	-- 				-- },
	-- 				-- would recommend to look into vim.api.nvim_set_hl() docs before using this
	-- 				-- remaps.highlights = {
	-- 				--     rose_pine = {
	-- 				--     	Normal = { bg = "#000000" }
	-- 				--     }
	-- 				-- },
	-- 				--
	-- 				-- Also you can do remaps.highlights.globals  for global highlight remaps
	-- 				highlights = {},
	-- 			},
	-- 		})
	-- 	end,
	-- })
  -- use "GustavoPrietoP/doom-themes.nvim"
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
	use({ "xiyaowong/telescope-emoji.nvim" })

	-- Lua

	use("mfussenegger/nvim-ts-hint-textobject")

	use({
		"pocco81/truezen.nvim",
	})

	-- HACK
	-- ADD MORE STUFF HERE
	-- Lua
	use({
		"SmiteshP/nvim-gps",
		wants = "nvim-treesitter/nvim-treesitter",
	})
  use 'ggandor/lightspeed.nvim'
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
	-- use({
	-- 	"numToStr/Comment.nvim",
	-- })
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
	use({ "nvim-telescope/telescope-project.nvim" })
	use({ "chentau/marks.nvim" })

	use({
		"nvim-telescope/telescope-frecency.nvim",
		requires = { "tami5/sqlite.lua" },
	})
	use({
		"ThePrimeagen/harpoon",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("harpoon").setup({
				projects = {
					["$HOME/tasq/setpoint-rec"] = {},
				},
			})
		end,
	})

	use({ "nvim-neorg/neorg", requires = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" } })
	use("nathom/filetype.nvim")
  use({
    "rcarriga/nvim-notify",
    config = function ()
      require"notify".setup({})
    end
  })
  -- use({"dccsillag/magma-nvim", ft="python", run = ":UpdateRemotePlugins"})
  use({"hkupty/iron.nvim"})
  use("nvim-telescope/telescope-symbols.nvim")
  use "folke/lua-dev.nvim"
  use "rmagatti/goto-preview"

  use({
    "andweeb/presence.nvim",
    config = function()
      require("presence"):setup({
        enable_line_number = true,
      })
    end,
  })
  use({
    "natecraddock/workspaces.nvim",
    config = function ()
      require("workspaces").setup({
        hooks = {
          open = { "Telescope find_files" },
        }
      })

    end

  })
	use({
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				undercurl = true, -- enable undercurls
				commentStyle = "italic",
				functionStyle = "bold",
				keywordStyle = "italic",
				statementStyle = "bold",
				typeStyle = "italic",
				variablebuiltinStyle = "italic",
				specialReturn = true, -- special highlight for the return keyword
				specialException = true, -- special highlight for exception handling keywords
				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				colors = {},
				overrides = {},
			})
		end,
	})
  use {
      "ThePrimeagen/refactoring.nvim",
      requires = {
          {"nvim-lua/plenary.nvim"},
          {"nvim-treesitter/nvim-treesitter"}
      }
  }
  -- use({
  --   "kdheepak/JET.nvim",
  --   requires = "jose-elias-alvarez/null-ls.nvim",
  --   run = [[mkdir -p ~/.julia/environments/nvim-null-ls && julia --startup-file=no --project=~/.julia/environments/nvim-null-ls -e 'using Pkg; Pkg.add("JET")']],
  -- })
  use({
    "jbyuki/venn.nvim",
    config = function()
      -- venn.nvim: enable or disable keymappings
      function _G.Toggle_venn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.cmd[[setlocal ve=all]]
          -- draw a line on HJKL keystokes
          vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
          vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
          vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
          vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
          -- draw a box by pressing "f" with visual selection
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
        else
          vim.cmd[[setlocal ve=]]
          vim.cmd[[mapclear <buffer>]]
          vim.b.venn_enabled = nil
        end
      end
      -- toggle keymappings for venn using <leader>v
      vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})
    end,
  })

	-- use'mfussenegger/nvim-dap'
	-- use{'mfussenegger/nvim-dap-python', requires = {"mfussenger/nvim-dap"}}
	-- use{ "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
	-- use{ "theHamsta/nvim-dap-virtual-text", requires = {"mfussenegger/nvim-dap"} }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
