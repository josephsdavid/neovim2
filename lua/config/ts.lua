M = {}
local km = require("core.keymap")
local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
local swapl = km.genleader(km.leader("s"))
local peekl = km.genleader(km.leader("p"))



M.select = {
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
        ["ad"] = "@comment.outer",
        ["am"] = "@call.outer",
        ["im"] = "@call.inner",
        ["iC"] = "@conditional.inner",
        ["aC"] = "@conditional.outer",
    },
}

M.swap = {
    enable = true,
    swap_next = {
        [swapl("l")] = "@parameter.inner",
        [swapl("L")] = "@function.outer",
    },
    swap_previous = {
        [swapl("h")] = "@parameter.inner",
        [swapl("H")] = "@function.outer",
    },
}

M.move = {
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


M.lsp_interop = {
    enable = true,
    border = "none",
    peek_definition_code = {
        [peekl("f")] = "@function.inner",
        [peekl("c")] = "@class.inner",
        [peekl("F")] = "@function.outer",
        [peekl("C")] = "@class.outer",
    },
}

M.textob = {
    select = M.select,
    swap = M.swap,
    move = M.move,
    lsp_interop = M.lsp_interop,
}

M.ts_config = {}
M.ts_config.matchup = { enable = true }
M.ts_config.ignore_install = { "haskell" }
M.ts_config.highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "c", "vim" }, -- list of language that will be disabled
    custom_captures = {},
}

M.ts_config.context_commentstring = {
    enable = true,
    enable_autocmd = true,
}

M.ts_config.indent = { enable = true, disable = { "yaml" } }
M.ts_config.refactor = {
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
}

M.ts_config.textsubjects = {
    enable = true,
    keymaps = {
        [km.localleader("s")] = "textsubjects-container-outer",
        [km.localleader(".")] = "textsubjects-smart",
    }
}
M.ts_config.textobjects = M.textob
M.ts_config.ensure_installed = { "python", "julia", "html", "norg", "c", "cpp", "norg_meta", "norg_table", "lua", "yaml", "bash", "rust", "dockerfile", "query", }
M.ts_config.playground = {
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
}

M.ts_config.query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
}

M.ts_context = {}
M.ts_context.enable = true
M.ts_context.throttle = true
M.ts_context.max_lines = true
M.ts_context.patterns = {
    default = {
        "class",
        "function",
        "method",
        "for",
        "while",
        "if",
        "switch",
        "case",
    },
}


M.setup = function()
    require "nvim-treesitter.configs".setup(M.ts_config)
    require "treesitter-context".setup(M.ts_context)
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
end

return M
