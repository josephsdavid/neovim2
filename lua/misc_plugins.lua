local plugins = {
    "folke/lazy.nvim", "nvim-lua/popup.nvim", { "nvim-lua/plenary.nvim", lazy = true },
    "kyazdani42/nvim-web-devicons", "tpope/vim-repeat",
    {
        "tpope/vim-fugitive",
        cmd = { "Gdiffsplit", "Git" },
        config = function()
            vim.cmd [[hi clear DiffText]]
            vim.api.nvim_set_hl(0, 'DiffText', { link = 'DiffChange' })
        end
    },
    "jghauser/mkdir.nvim",
    { "direnv/direnv.vim",     event = "BufRead" },
    "antoinemadec/FixCursorHold.nvim",
    {
        "mtikekar/nvim-send-to-term",
        cmd = "SendHere",
        config = function()
            vim.g.send_disable_mapping = true
        end
    },
    {
        "tiagovla/scope.nvim",
        config = function()
            require("scope").setup()
        end
    },
    {
        "kylechui/nvim-surround",
        keys = { "<C-s>", "ys", "yss", "yS", "ySS", "S", "gS", "ds", "cs" },
        events = { "InsertEnter" },
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    insert_line = "<C-s>",
                    normal = "ys",
                    normal_cur = "yss",
                    normal_line = "yS",
                    normal_cur_line = "ySS",
                    visual = "S",
                    visual_line = "gS",
                    delete = "ds",
                    change = "cs",
                },
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    "haya14busa/vim-asterisk",
    -- TODO: Make harpoon2 work
    "ThePrimeagen/harpoon",
    {
        "aserowy/tmux.nvim",
        lazy = true,
        config = function()
            require("tmux").setup({
                copy_sync = { enable = false },
                navigation = {
                    -- cycles to opposite pane while navigating into the border
                    cycle_navigation = false,

                    -- enables default keybindings (C-hjkl) for normal mode
                    enable_default_keybindings = false,

                    -- prevents unzoom tmux when navigating beyond vim border
                    persist_zoom = false,
                },
            }
            )
        end
    },
    {
        'TimUntersberger/neogit',
        dependencies = { 'nvim-lua/plenary.nvim' },
        lazy = true,
        config = function()
            require('neogit').setup {
                disable_commit_confirmation = true,
                use_magit_keybindgs = true
            }
        end
    },
    {
        "rmagatti/goto-preview",
        event = "LspAttach",
        config = function()
            require("goto-preview").setup({})
        end
    },
    { "folke/lsp-colors.nvim", event = "LspAttach" },
    {
        "amrbashir/nvim-docs-view",
        cmd = { "DocsViewToggle" },
        config = function()
            require("docs-view").setup {
                position = "bottom",
                width = 60,
            }
        end
    },
    {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    },
    {

        {
            'quarto-dev/quarto-nvim',
            ft = { 'quarto' },
            dev = false,
            opts = {
                lspFeatures = {
                    languages = { 'r', 'python', 'julia', 'bash', 'lua', 'html', 'dot', 'javascript', 'typescript', 'ojs' },
                },
                codeRunner = {
                    enabled = false,
                    default_method = 'slime',
                },
            },
            dependencies = {
                {
                    'jmbuhr/otter.nvim',
                    dev = false,
                    dependencies = {
                        { 'neovim/nvim-lspconfig' },
                    },
                },
            },
        }
    },
    {
        'huggingface/llm.nvim',
        config = function()
            local llm = require('llm')

            llm.setup({
                api_token = "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", -- cf Install paragraph
                model = "bigcode/starcoder",                         -- the model ID, behavior depends on backend
                backend = "huggingface",                             -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
                url = nil,                                           -- the http url of the backend
                tokens_to_clear = { "<|endoftext|>" },               -- tokens to remove from the model's output
                -- parameters that are added to the request body, values are arbitrary, you can set any field:value pair here it will be passed as is to the backend
                request_body = {
                    parameters = {
                        max_new_tokens = 60,
                        temperature = 0.2,
                        top_p = 0.95,
                    },
                },
                -- set this if the model supports fill in the middle
                fim = {
                    enabled = true,
                    prefix = "<fim_prefix>",
                    middle = "<fim_middle>",
                    suffix = "<fim_suffix>",
                },
                debounce_ms = 150,
                accept_keymap = "<Tab>",
                dismiss_keymap = "<S-Tab>",
                tls_skip_verify_insecure = false,
                -- llm-ls configuration, cf llm-ls section
                lsp = {
                    bin_path = nil,
                    host = nil,
                    port = nil,
                    version = "0.5.2",
                },
                tokenizer = nil,                   -- cf Tokenizer paragraph
                context_window = 8192,             -- max number of tokens for the context window
                enable_suggestions_on_startup = false,
                enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
            })
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
        }
    }
}

add_plugins(plugins)
