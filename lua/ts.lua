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

-- wk.register({
-- 	[Keys.swapleader("")] = {
-- 		name = "Swap",
-- 		p = { name = "Move parameter forward" },
-- 		["P"] = { name = "Move parameter backward" },
-- 		f = { name = "Move function forward" },
-- 		["F"] = { name = "Move function backward" },
-- 	},
-- })

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
    [Keys.peekleader("f")] = "@function.inner",
    [Keys.peekleader("c")] = "@class.inner",
    [Keys.peekleader("F")] = "@function.outer",
    [Keys.peekleader("C")] = "@class.outer",
  },
}

wk.register({
  [Keys.peekleader("")] = {
    name = "peek",
    F = { name = "function peek" },
    C = { name = "class peek" },
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
  matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
  },
  ignore_install = { "haskell" },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "c", "vim" }, -- list of language that will be disabled
    custom_captures = { -- mapping of user defined captures to highlight groups
      -- ["foo.bar"] = "Identifier"  -- highlight own capture @foo.bar with highlight group "Identifier", see :h nvim-treesitter-query-extensions
    },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = true,
  },

  indent = { enable = true, disable = { "yaml" } },

  incremental_selection = {
    enable = true,
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
        smart_rename = Keys.refactorleader("l"), -- mapping to rename reference under cursor
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
    "julia",
    "html",
    "norg",
    "c",
    "cpp",
    "norg_meta",
    "norg_table",
    "lua",
    "yaml",
    "bash",
    "rust",
    "dockerfile",
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
  enable = { "norg", "markdown", "python", "lua" },
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
    lint_events = { "BufWrite", "CursorHold" },
  },
}
)

wk.register({
  [Keys.refactorleader("")] = {
    name = "refactor",
    n = { name = "rename" },
    d = { name = "definition" },
    ["D"] = { name = "definition list" },
    ["gO"] = { name = "definition toc" },
  },
})


-- Setup Function example:
-- These are the default options:
require("syntax-tree-surfer").setup({
  highlight_group = "STS_highlight",
  disable_no_instance_found_report = false,
  default_desired_types = {
    "function",
    "function_definition",
    "struct_definition",
    "if_statement",
    "else_clause",
    "do_clause",
    "else_statement",
    "elseif_statement",
    "for_statement",
    "let_statement",
    "while_statement",
    "switch_statement",
    "list_lit",
    "vec_lit",
    "map_lit",
    "set_lit",
    "quoting_lit",
    "regex_lit",
  },
  left_hand_side = "fdsawervcxqtzb",
  right_hand_side = "jkl;oiu.,mpy/n",
  icon_dictionary = {
    ["if_statement"] = "????",
    ["else_clause"] = "???",
    ["else_statement"] = "???",
    ["elseif_statement"] = "???",
    ["elseif_clause"] = "???",
    ["for_statement"] = "???",
    ["while_statement"] = "???",
    ["switch_statement"] = "???",
    ["function"] = "???",
    ["function_definition"] = "???",
    ["variable_declaration"] = "???",
    ["let_statement"] = "???",
    ["do_statement"] = "????",
    ["struct_definition"] = "????",
    ["list_lit"] = "???",
    ["vec_lit"] =  "???",
    ["map_lit"] =   "???",
    ["set_lit"] = "???",
    ["quoting_lit"] = "???",
    ["regex_lit"] = "???",
  },
})

-- Syntax Tree Surfer V2 Mappings
-- Targeted Jump with virtual_text
local sts = require("syntax-tree-surfer")
vim.keymap.set("n", " hv", function() -- only jump to variable_declarations
  sts.targeted_jump({ "variable_declaration" })
end, opts)
vim.keymap.set("n", " hi", function() -- only jump to if_statements
  sts.targeted_jump({ "if_statement", "else_clause", "else_statement", "elseif_statement" })
end, opts)
vim.keymap.set("n", " hf", function() -- only jump to for_statements
  sts.targeted_jump({ "for_statement", "do_clause", "while_statement" })
end, opts)
vim.keymap.set("n", "gj", function() -- jump to all that you specify
  sts.targeted_jump({
    "function",
    "function_definition",
    "struct_definition",
    "if_statement",
    "else_clause",
    "do_clause",
    "else_statement",
    "elseif_statement",
    "for_statement",
    "let_statement",
    "while_statement",
    "switch_statement",
    "list_lit",
    "vec_lit",
    "map_lit",
    "set_lit",
    "quoting_lit",
    "regex_lit",
  })
end, opts)

-------------------------------
-- filtered_jump --
-- "default" means that you jump to the default_desired_types or your lastest jump types
vim.keymap.set("n", "<C-n>", function()
  sts.filtered_jump("default", true) --> true means jump forward
end, opts)
vim.keymap.set("n", "<C-b>", function()
  sts.filtered_jump("default", false) --> false means jump backwards
end, opts)


-------------------------------
-- jump with limited targets --
-- jump to sibling nodes only
-- jump to parent or child nodes only
