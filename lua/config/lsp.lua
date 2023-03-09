function setup()
    local ret = {}

    local nvim_lsp = require("lspconfig")
    -- local null_ls = require("null-ls")
    -- local helpers = require("null-ls.helpers")
    -- local builtins = null_ls.builtins
    -- local generator = null_ls.generator
    --
    -- local jet_julia = {
    --     method = null_ls.methods.DIAGNOSTICS,
    --     filetypes = { "julia" },
    --     generator = null_ls.generator({
    --         command = { "jet" },
    --         to_stdin = true,
    --         from_stderr = true,
    --         -- timeout = timeout,
    --         format = "line",
    --         check_exit_code = function(code)
    --             return code <= 1
    --         end,
    --         args = { "$FILENAME" },
    --         on_output = helpers.diagnostics.from_patterns({
    --             {
    --                 -- TODO: FIXME
    --                 pattern = [[(%d+):([EIW]):(.*)]],
    --                 groups = { "row", "severity", "message" },
    --                 overrides = {
    --                     severities = {
    --                         E = helpers.diagnostics.severities["error"],
    --                         W = helpers.diagnostics.severities["warning"],
    --                         I = helpers.diagnostics.severities["information"],
    --                     },
    --                 },
    --             },
    --         }),
    --     }),
    -- }
    --
    -- null_ls.register(jet_julia)


    local function rename()
        local curr_name = vim.fn.expand("<cword>")
        local value = vim.fn.input("Old name: " .. curr_name .. ", new name: ")
        local lsp_params = vim.lsp.util.make_position_params()

        if not value or #value == 0 or curr_name == value then return end

        -- request lsp rename
        lsp_params.newName = value
        vim.lsp.buf_request(0, "textDocument/rename", lsp_params, function(_, res, ctx, _)
            if not res then return end

            -- apply renames
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

            -- print renames
            local changed_files_count = 0
            local changed_instances_count = 0

            if (res.documentChanges) then
                for _, changed_file in pairs(res.documentChanges) do
                    changed_files_count = changed_files_count + 1
                    changed_instances_count = changed_instances_count + #changed_file.edits
                end
            elseif (res.changes) then
                for _, changed_file in pairs(res.changes) do
                    changed_instances_count = changed_instances_count + #changed_file
                    changed_files_count = changed_files_count + 1
                end
            end

            -- compose the right print message
            print(string.format("renamed %s instance%s in %s file%s. %s",
                changed_instances_count,
                changed_instances_count == 1 and '' or 's',
                changed_files_count,
                changed_files_count == 1 and '' or 's',
                changed_files_count > 1 and "To save them run ':wa'" or ''
            ))
        end)
    end

    ret.setup = function()

        local signs = {
            { name = "DiagnosticSignError", text = "😱" },
            { name = "DiagnosticSignWarn", text = "" },
            { name = "DiagnosticSignHint", text = "" },
            { name = "DiagnosticSignInfo", text = "" },
        }

        for _, sign in ipairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end
        local severity = vim.diagnostic.severity
        local config = {
            underline = false,
            virtual_text = false,
            {
                prefix = "»",
                spacing = 4,
            },
            -- show signs
            signs = {
                active = signs,
            },
            update_in_insert = false,

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
        vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])

        local g = km.genleader("g")

        local function _bind(mode)
            local out = function(k, v)
                km.keymap(mode, k, v[1], { noremap = true, silent = true }, v[2])
            end
            return out
        end

        local lspbind = _bind("n")
        -- local lspvbind = _bind("lsp", "visual")
        -- local lspibind = _bind("lsp", "insert")

        local ntable = {
            [g("r")] = { ":Telescope lsp_references<CR>", "goto references" },
            [g("d")] = { "<cmd>lua vim.lsp.buf.definition()<CR>zz", "goto definition" },
            [g("D")] = { km.luacmd("require('goto-preview').goto_preview_definition()"), "goto definition, popup" },
            [g("q")] = { km.luacmd("require('goto-preview').close_all_win()"), "close popups" },
            [g("l")] = { km.luacmd("vim.diagnostic.open_float()"), "diagnostics" },
            ["K"] = { km.luacmd("vim.lsp.buf.hover()"), "docs" },
            [km.leader("rn")] = { rename, "rename" },
            ["]d"] = { km.luacmd("vim.diagnostic.goto_next({border='rounded'})"), "next diagnostic" },
            ["[d"] = { km.luacmd("vim.diagnostic.goto_prev({border='rounded'})"), "next diagnostic" },
            ["[d"] = { km.luacmd("vim.diagnostic.goto_prev({border='rounded'})"), "next diagnostic" },
            [g("a")] = {km.cmd("CodeActionMenu"), "code actions"}
        }


        for k, v in pairs(ntable) do
            lspbind(k, v)
        end

        -- lspibind(km.ctrl("h"), { km.luacmd("vim.lsp.buf.signature_help()"), "docs" })


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
            if status_ok then capabilities = cmp_nvim_lsp.default_capabilities(capabilities) end
            return capabilities
        end

        local servers = {
            julials = {
                root_dir = function(fname)
                    local util = require("lspconfig.util")
                    return util.root_pattern("Project.toml")(fname) or util.find_git_ancestor(fname) or
                        util.path.dirname(fname)
                end,

                cmd = { "juliacli", "server" },
                settings = {
                    julia = {
                        usePlotPane = false,
                        symbolCacheDownload = false,
                        enableCrashReporter = false,
                        runtimeCompletions = true,
                        singleFileSupport = true,
                        useRevise = true,
                        lint = {
                            NumThreads = 11,
                            missingrefs = "all",
                            iter = true,
                            lazy = true,
                            modname = true,
                            pirates = true
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
                            globals = { "vim", "km" },
                        },
                    },
                },
            },
            rust_analyzer = {
                cmd = {
                    "rust-analyzer"
                },
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy"
                        },
                    }
                }
            },
            pyright = {},
            zls = {}
        }

        for lsp, setup in pairs(servers) do
            setup.on_attach = on_attach
            setup.capabilities = make_capabilities()
            nvim_lsp[lsp].setup(setup)
        end


    end
    ret.setup()
    return nil

end

return {
    "neovim/nvim-lspconfig",
    config = setup,
    -- event = {"InsertEnter", "CursorMoved", "ModeChanged", "CursorHold"}, -- i just want it to load a little later
    dependencies = {
        "hrsh7th/cmp-nvim-lsp"
        -- "jose-elias-alvarez/null-ls.nvim",
    }
}
