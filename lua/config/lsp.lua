M = {}
local nvim_lsp = require("lspconfig")
local saga = require 'lspsaga'
local action = saga.codeaction
local km = require("core.keymap")

M.setup = function()

    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        virtual_text = false,
        {
            prefix = "»",
            spacing = 4,
        },
        -- show signs
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = false,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
    require("goto-preview").setup({})
    -- set up lspsaga
    saga.init_lsp_saga({
        border_style = "rounded",
        saga_winblend = 10,
        move_in_saga = { prev = km.Ctrl(","), next = km.Ctrl(".") },
        diagnostic_header = { " ", " ", " ", "ﴞ " },
        show_diagnostic_source = true,
        max_preview_lines = 10,
        code_action_icon = "ﯦ",
        code_action_num_shortcut = true,
        code_action_lightbulb = {
            enable = false,
            sign = true,
            sign_priority = 20,
            virtual_text = false,
        },
        finder_icons = {
            def = '  ',
            ref = '諭 ',
            link = '  ',
        },
        finder_action_keys = {
            open = { "o", "<cr>" },
            vsplit = "s",
            split = "i",
            tabe = "t",
            quit = "q",
            scroll_down = "<C-f>",
            scroll_up = "<C-b>",
        },
        code_action_keys = {
            quit = "q",
            exec = "<CR>",
        },
        rename_action_quit = "<C-c>",
        definition_preview_icon = "  ",
        show_outline = {
            win_position = 'right',
            -- set the special filetype in there which in left like nvimtree neotree defx
            left_with = '',
            win_width = 30,
            auto_enter = true,
            auto_preview = true,
            virt_text = '┃',
            jump_key = 'o',
            -- auto refresh when change buffer
            auto_refresh = true,
        },
    })

    Bindings.config.lsp = { normal = {}, visual = {} }
    local g = km.genleader("g")

    local function _bind(key, mode)
        local out = function(k, v)
            Bindings.config[key][mode][k] = v
        end
        return out
    end

    local lspbind = _bind("lsp", "normal")
    local lspvbind = _bind("lsp", "visual")

    local ntable = {
        [g("f")] = { ":Lspsaga lsp_finder<CR>", "finder" },
        [g("r")] = { ":Telescope lsp_references<CR>", "goto references" },
        [g("D")] = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "goto definition, popup" },
        [g("d")] = { "<cmd>Telescope lsp_definitions<CR>", "goto definition" },
        [g("a")] = { ":Lspsaga code_action<CR>", "code_action" },
        [g("s")] = { ":Lspsaga signature_help<CR>", "signature" },
        [g("l")] = { ":Lspsaga show_line_diagnostics<CR>", "diagnostics" },
        ["K"] = { ":Lspsaga hover_doc<CR>", "docs" },
        [km.Ctrl("f")] = { function() action.smart_scroll_with_saga(1) end, "docs scroll up" },
        [km.Ctrl("b")] = { function() action.smart_scroll_with_saga(-1) end, "docs scroll down" },
        [km.leader("rn")] = { ":Lspsaga rename<CR>", "rename" },
        ["]d"] = { ":Lspsaga diagnostic_jump_next<CR>", "next diagnostic" },
        ["[d"] = { ":Lspsaga diagnostic_jump_prev<CR>", "prev diagnostic" },
        [g("o")] = { ":LSOutlineToggle<CR>", "Outline" },
        [g("p")] = { ":Lspsaga preview_definition<CR>", "Saga preview definition" },
    }

    lspvbind(g("a"), { ":<C-U>Lspsaga code_action", "code_action" })

    for k, v in pairs(ntable) do
        lspbind(k, v)
    end

    local on_attach = function(client, bufnr)


        -- local function vim.api.nvim_buf_set_keymap(a,b,c,d)
        -- 	vim.api.nvim_vim.api.nvim_buf_set_keymap(bufnr, a,b,c,d)
        -- end
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    end


    local function make_capabilities()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.preselectSupport = true
        capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
        capabilities.textDocument.completion.completionItem.deprecatedSupport = true
        capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
        capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
        capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
        }
        capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown" }
        capabilities.textDocument.codeAction = {
            dynamicRegistration = true,
            codeActionLiteralSupport = {
                codeActionKind = {
                    valueSet = (function()
                        local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                        table.sort(res)
                        return res
                    end)(),
                },
            },
        }
        local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if status_ok then capabilities = cmp_nvim_lsp.update_capabilities(capabilities) end
        return capabilities
    end

    local servers = {
        julials = {

            cmd = { "juliacli", "server" },
            settings = {
                julia = {
                    usePlotPane = false,
                    symbolCacheDownload = false,
                    runtimeCompletions = true,
                    singleFileSupport = false,
                    useRevise = true,
                    lint = {
                        NumThreads = 11,
                        missingrefs = "all",
                        iter = true,
                        lazy = true,
                        modname = true,
                    },
                },
            },

        },
        sumneko_lua = {
            cmd = {
                "lua-language-server",
            },
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        },
    }

    for lsp, setup in pairs(servers) do
        setup.on_attach = on_attach
        setup.capabilities = make_capabilities()
        nvim_lsp[lsp].setup(setup)
    end

end
return M
