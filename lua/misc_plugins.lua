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
        keys = { "ys", "yss", "yS", "ySS", "S", "gS", "ds", "cs" },
        events = { "InsertEnter" },
        config = function()
            require("nvim-surround").setup({
                keymaps = {
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
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            -- REQUIRED
            harpoon:setup(
                { settings = { save_on_toggle = true, sync_on_ui_close = true } }
            )
            -- REQUIRED
            vim.keymap.set("n", "<leader>h", function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-x><C-x>", function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            -- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
            -- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
            -- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
            -- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
            vim.keymap.set("n", "g1", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "g2", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "g3", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "g4", function() harpoon:list():select(4) end)
            vim.keymap.set("n", "g5", function() harpoon:list():select(5) end)
            vim.keymap.set("n", "g6", function() harpoon:list():select(6) end)
            vim.keymap.set("n", "g7", function() harpoon:list():select(7) end)
            vim.keymap.set("n", "g8", function() harpoon:list():select(8) end)
            vim.keymap.set("n", "g9", function() harpoon:list():select(9) end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<A-,>", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<A-.>", function() harpoon:list():next() end)
        end
    },
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
            ft = { 'quarto', 'markdown' },
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
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
        }
    },

    {
        "NTBBloodbath/daylight.nvim",
        config = function()
            require("daylight").setup({
                day = {
                    name = vim.g.colors_name,
                    time = 8, -- 8 am
                },
                night = {
                    name = vim.g.colors_name,
                    time = 19,          -- 7 pm, changes to dark theme on 07:01
                },
                interval = 60000000000, -- Time in milliseconds, 1 minute
            })
        end,
    },
    {
        "lukas-reineke/headlines.nvim",
        ft = "markdown",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true, -- or `opts = {}`
    },
    {
        "kevinhwang91/nvim-bqf"
    },
    {

        "GCBallesteros/jupytext.nvim",
        config = true,
        -- Depending on your nvim distro or config you may need to make the loading not lazy
        -- lazy=false,

    },
    {
        "chrisgrieser/nvim-various-textobjs",
        event = "VeryLazy",
        opts = { useDefaultKeymaps = true },
    },
}

add_plugins(plugins)
