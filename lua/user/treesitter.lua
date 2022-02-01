local wk = require("which-key")
local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

parser_configs.norg = {
	install_info = {
		url = "https://github.com/nvim-neorg/tree-sitter-norg",
		files = { "src/parser.c", "src/scanner.cc" },
		branch = "main",
	},
}

parser_configs.norg_meta = {
	install_info = {
		url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
		files = { "src/parser.c" },
		branch = "main",
	},
}

parser_configs.norg_table = {
	install_info = {
		url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
		files = { "src/parser.c" },
		branch = "main",
	},
}

local select = {
	enable = true,

	-- Automatically jump forward to textobj, similar to targets.vim
	lookahead = true,

	keymaps = {
		-- You can use the capture groups defined in textobjects.scm
		["af"] = "@function.outer",
		["if"] = "@function.inner",
		["ac"] = "@class.outer",
		["ic"] = "@class.inner",
		["ae"] = "@block.outer",
		["ie"] = "@block.inner",
		["al"] = "@loop.outer",
		["il"] = "@loop.inner",
		["iS"] = "@statement.inner",
		["aS"] = "@statement.outer",
		["ad"] = "@comment.outer",
		["am"] = "@call.outer",
		["im"] = "@call.inner",
		["iC"] = "@conditional.inner",
		["aC"] = "@conditional.outer",
	},
}

local swap = {
	enable = true,
	swap_next = {
		[Keys.swapleader("p")] = "@parameter.inner",
		[Keys.swapleader("f")] = "@function.outer",
	},
	swap_previous = {
		[Keys.swapleader("P")] = "@parameter.inner",
		[Keys.swapleader("F")] = "@function.outer",
	},
}

wk.register({
	[Keys.swapleader("")] = {
		name = "Swap",
		p = { name = "Move parameter forward" },
		["P"] = { name = "Move parameter backward" },
		f = { name = "Move function forward" },
		["F"] = { name = "Move function backward" },
	},
})

local move = {
	enable = true,
	set_jumps = true, -- whether to set jumps in the jumplist
	goto_next_start = {
		["]}"] = "@class.outer",
		["]]"] = "@function.outer",
	},
	goto_next_end = {
		["]{"] = "@class.outer",
		["]["] = "@function.outer",
	},
	goto_previous_start = {
		["[{"] = "@class.outer",
		["[["] = "@function.outer",
	},
	goto_previous_end = {
		["[}"] = "@class.outer",
		["[]"] = "@function.outer",
	},
}

local lsp_interop = {
	enable = true,
	border = "none",
	peek_definition_code = {
		[Keys.peekleader("f")] = "@function.outer",
		[Keys.peekleader("c")] = "@class.outer",
	},
}

wk.register({
	[Keys.peekleader("")] = {
		name = "peek",
		f = { name = "function peek" },
		c = { name = "class peek" },
	},
})

local textob = {
	select = select,
	swap = swap,
	move = move,
	lsp_interop = lsp_interop,
}

require("nvim-treesitter.configs").setup({
	ignore_install = { "haskell" },
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "c" }, -- list of language that will be disabled
		custom_captures = { -- mapping of user defined captures to highlight groups
			-- ["foo.bar"] = "Identifier"  -- highlight own capture @foo.bar with highlight group "Identifier", see :h nvim-treesitter-query-extensions
		},
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = true,
	},

	indent = { enable = false, disable = { "yaml" } },

	incremental_selection = {
		enable = false,
		disable = { "cpp", "lua" },
		keymaps = { -- Keys for incremental selection (visual Keys)
			init_selection = "gnt", -- maps in normal mode to init the node/scope selection
			node_incremental = "gtt", -- increment to the upper named parent
			scope_incremental = "gct", -- increment to the upper scope (as defined in locals.scm)
			node_decremental = "gmt", -- decrement to the previous node
		},
	},
	refactor = {
		highlight_definitions = {
			enable = true,
		},
		highlight_current_scope = {
			enable = false,
		},
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = Keys.refactorleader("n"), -- mapping to rename reference under cursor
			},
		},
		navigation = { -- use lsp
			enable = true,
			keymaps = {
				goto_definition = Keys.refactorleader("d"),
				list_definitions = Keys.refactorleader("D"),
				list_definitions_toc = "gO",
				goto_next_usage = "<a-'>",
				goto_previous_usage = "<a-;>",
			},
		},
	},
	textsubjects = {
		enable = true,
		prev_selection = ",", -- (Optional) keymap to select the previous selection
		keymaps = {
			["."] = "textsubjects-smart",
			[Keys.C(";")] = "textsubjects-container-outer",
		},
	},
	textobjects = textob,
	ensure_installed = {
		"python",
    "html",
		"norg",
		"c",
		"norg_meta",
		"norg_table",
		"lua",
		"yaml",
		"bash",
		"rust",
		"dockerfile",
		"vim",
		"query",
	}, -- one of "all", "language", or a list of languages
})

require("treesitter-context").setup({
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	throttle = true, -- Throttles plugin updates (may improve performance)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
		-- For all filetypes
		-- Note that setting an entry here replaces all other patterns for this entry.
		-- By setting the 'default' entry below, you can control which nodes you want to
		-- appear in the context window.
		default = {
			"class",
			"function",
			"method",
			"for", -- These won't appear in the context
			"while",
			"if",
			"switch",
			"case",
		},
		-- Example for a specific filetype.
		-- If a pattern is missing, *open a PR* so everyone can benefit.
		--   rust = {
		--       'impl_item',
		--   },
	},
	exact_patterns = {
		-- Example for a specific filetype with Lua patterns
		-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
		-- exactly match "impl_item" only)
		-- rust = true,
	},
})

require("spellsitter").setup({
	enable = { "norg", "markdown", "python" },
})
require("nvim-treesitter.configs").setup({
	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
}
)

wk.register({
	[Keys.refactorleader("")] = {
		name = "refactor",
		n = { name = "rename" },
		d = { name = "defintion" },
		["D"] = { name = "defintion list" },
		["gO"] = { name = "defintion toc" },
	},
})
