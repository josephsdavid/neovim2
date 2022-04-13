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
  max_jobs=50,
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
	use({ "Yggdroot/hiPairs"})
	-- use({ "axvr/zepl.vim", cmd = { "Repl" }, opt = true })
	use({ "tpope/vim-repeat"})
	use({ "tpope/vim-vinegar"})
	use({ "tpope/vim-surround"})
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
	-- use("mizlan/iswap.nvim")
	use({ "tpope/vim-fugitive", cmd = { "Git" }, opt = true })
	use({ "vimlab/split-term.vim", cmd = { "VTerm", "Term" }, opt = true })
	use({
		"lukas-reineke/indent-blankline.nvim",
		ft = { "python", "lua", "julia", "cpp" },
		config = function()
			require("user.indentline")
		end,
	})
	use("akinsho/toggleterm.nvim")
	use("lewis6991/impatient.nvim")
	use("folke/lsp-colors.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use({ "ray-x/lsp_signature.nvim" })
	use("ray-x/cmp-treesitter")
	use("nvim-treesitter/playground")
	-- use({
	-- 	"j-hui/fidget.nvim",
	-- 	config = function()
	-- 		require("fidget").setup()
	-- 	end,
	-- })
	use("arkav/lualine-lsp-progress")
	use({
		"josephsdavid/neogen",
    branch = "dj/add-julia-support",
		config = function()
			require("neogen").setup({
        snippet_engine = "luasnip",
        enable_placeholders = false,
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
	use({
		"mcchrish/zenbones.nvim",
		requires = "rktjmp/lush.nvim",
	})
	use("folke/tokyonight.nvim")
	-- use({ "echasnovski/mini.nvim", requires = { "lewis6991/gitsigns.nvim", "kyazdani42/nvim-web-devicons" } })
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
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
	use("ggandor/lightspeed.nvim")
	-- use({
	-- 	"phaazon/hop.nvim",
	-- 	branch = "v1", -- optional but strongly recommended
	-- 	config = function()
	-- 		-- you can configure Hop the way you like here; see :h hop-config
	-- 		require("hop").setup({
	-- 			-- keys = 'etovxqpdygfblzhckisuran'
	-- 		})
	-- 	end,
	-- })
	use({ "folke/which-key.nvim" })
	-- use({
	-- 	"numToStr/Comment.nvim",
	-- })
	use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })

	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("nvim-treesitter/nvim-treesitter-refactor")
	-- use("lewis6991/gitsigns.nvim")

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
		-- },
		-- ft = {"norg"}
	})
	use({ "nvim-telescope/telescope-project.nvim" })
	use({
		"chentau/marks.nvim",
		config = function()
			require("marks").setup({
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
				sign_priority = { lower = 18, upper = 18, builtin = 1, bookmark = 10 },
				excluded_filetypes = {},
				bookmark_0 = {
					sign = "⚑",
					virt_text = "hello world",
				},
				mappings = {},
			})
		end,
	})

	use({
		"nvim-telescope/telescope-frecency.nvim",
		requires = { "tami5/sqlite.lua" },
	})
	-- use({
	-- 	"ThePrimeagen/harpoon",
	-- 	requires = "nvim-lua/plenary.nvim",
	-- 	config = function()
	-- 		require("harpoon").setup({
	-- 			projects = {
	-- 				["$HOME/tasq/setpoint-rec"] = {},
	-- 			},
	-- 		})
	-- 	end,
	-- })
  use({"nvim-neorg/neorg-telescope", })

	use({ "nvim-neorg/neorg", requires = { "nvim-lua/plenary.nvim",  } })
	use("nathom/filetype.nvim")
	use({
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({})
		end,
	})
	-- use({"dccsillag/magma-nvim", ft="python", run = ":UpdateRemotePlugins"})
	use({ "hkupty/iron.nvim" })
	use("nvim-telescope/telescope-symbols.nvim")
	use("folke/lua-dev.nvim")
	use("rmagatti/goto-preview")

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
		config = function()
			require("workspaces").setup({
				hooks = {
					open = { "Telescope find_files" },
				},
			})
		end,
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
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})
	-- use({
	--   "kdheepak/JET.nvim",
	--   requires = "jose-elias-alvarez/null-ls.nvim",
	--   run = [[mkdir -p ~/.julia/environments/nvim-null-ls && julia --startup-file=no --project=~/.julia/environments/nvim-null-ls -e 'using Pkg; Pkg.add("JET")']],
	-- })
	-- Lua
	use({
		"abecodes/tabout.nvim",
		config = function()
			require("tabout").setup({
				tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
				backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
				act_as_tab = true, -- shift content if tab out is not possible
				act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
				enable_backwards = true, -- well ...
				completion = true, -- if the tabkey is used in a completion pum
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = "`", close = "`" },
					{ open = "(", close = ")" },
					{ open = "[", close = "]" },
					{ open = "{", close = "}" },
				},
				ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
				exclude = {}, -- tabout will ignore these filetypes
			})
		end,
		wants = { "nvim-treesitter" }, -- or require if not used so far
		after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
	})
	-- Lua
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
				keywords = {
					FIX = {
						icon = " ", -- icon used for the sign, and in search results
						color = "error", -- can be a hex color, or a named color (see below)
						alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
						-- signs = false, -- configure signs for some keywords individually
					},
					TODO = { icon = " ", color = "info" },
					HACK = { icon = " ", color = "warning" },
					WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
					PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				},

				priority = 19,
				highlight = {
					before = "", -- "fg" or "bg" or empty
					keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
					after = "fg", -- "fg" or "bg" or empty
					pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
					comments_only = true, -- uses treesitter to match keywords in comments only
					max_line_len = 400, -- ignore lines longer than this
					exclude = {}, -- list of file types to exclude highlighting
				},
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	use({
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		-- config = function()
		-- 	require("user.qf")
		-- end,
	})
	use({
		"ten3roberts/qf.nvim",
		config = function()
			require("qf").setup({})
		end,
	})

	-- optional
	use({
		"junegunn/fzf",
		run = function()
			vim.fn["fzf#install"]()
		end,
	})
	use({
		"ibhagwan/fzf-lua",
		-- optional for icon support
		requires = { "kyazdani42/nvim-web-devicons" },
	})
	use({ "jbyuki/venn.nvim" })
	use({ "andreasvc/vim-256noir" })
	use("GustavoPrietoP/doom-themes.nvim")
	use({
		"pianocomposer321/yabs.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
  use({
    "haringsrob/nvim_context_vt",
    config = function ()
      require("nvim_context_vt").setup({
        disable_virtual_lines = true,
        prefix = '▶️',
      })
    end
  })
-- mkdir
  use {
    'jghauser/mkdir.nvim',
    config = function()
      require('mkdir')
    end
  }
use {
  'pwntester/octo.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'kyazdani42/nvim-web-devicons',
  },
}
  -- use {
  --   "xiyaowong/nvim-transparent",
  --   config = function ()
  --     require("transparent").setup({
  --       enable = true
  --     })
  --
  --   end
  -- }
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
