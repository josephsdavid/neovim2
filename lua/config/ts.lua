local km = require("core.keymap")
local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
local swapl = km.genleader(km.leader("s"))
local peekl = km.genleader(km.leader("p"))



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
        [swapl("p")] = "@parameter.inner",
        [swapl("f")] = "@function.outer",
    },
    swap_previous = {
        [swapl("P")] = "@parameter.inner",
        [swapl("F")] = "@function.outer",
    },
}

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
        [peekl("f")] = "@function.inner",
        [peekl("c")] = "@class.inner",
        [peekl("F")] = "@function.outer",
        [peekl("C")] = "@class.outer",
    },
}

local textob = {
    select = select,
    swap = swap,
    move = move,
    lsp_interop = lsp_interop,
}

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
    matchup = {
        enable = true, -- mandatory, false will disable the whole extension
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
                smart_rename = km.localleader("rn"), -- mapping to rename reference under cursor
            },
        },
        navigation = { -- use lsp
            enable = true,
            keymaps = {
                goto_definition = km.localleader("d"),
                list_definitions = km.localleader("D"),
                list_definitions_toc = "gO",
                goto_next_usage = km.Alt("'"),
                goto_previous_usage = km.Alt(";"),
            },
        },
    },
    textsubjects = {
        enable = true,
        prev_selection = ",", -- (Optional) keymap to select the previous selection
        keymaps = {
            ["."] = "textsubjects-smart",
            [km.Ctrl(";")] = "textsubjects-container-outer",
        },
    },
    textobjects = textob,
    ensure_installed = {
        "comment",
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
        "markdown",
        "markdown_inline"
    }, -- one of "all", "language", or a list of languages
})




require 'treesitter-context'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            -- 'for', -- These won't appear in the context
            -- 'while',
            -- 'if',
            -- 'switch',
            -- 'case',
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

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
}
require("spellsitter").setup({
    enable = { "norg", "markdown", "python", "lua" },
})

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
require("spellsitter").setup({
    enable = { "norg", "markdown", "python", "lua" },
})
