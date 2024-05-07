local lsp = {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        'joechrisellis/lsp-format-modifications.nvim'
        -- "jose-elias-alvarez/null-ls.nvim",
    }
}


local on_attach = function(client, bufnr)
    -- local function vim.api.nvim_buf_set_keymap(a,b,c,d)
    -- 	vim.api.nvim_vim.api.nvim_buf_set_keymap(bufnr, a,b,c,d)
    -- end
    if client.name == 'ruff_lsp' then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end
    if client.name ~= "basedpyright" then
        local lsp_format_modifications = require "lsp-format-modifications"
        lsp_format_modifications.attach(client, bufnr, { format_on_save = false })
    end
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
    lua_ls = {
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
    basedpyright = {
        settings = {
            basedpyright = {
                analysis = {
                    diagnosticSeverityOverrides = {
                        reportMissingTypeStubs = "warning",
                        reportUnknownParameterType = "warning",
                        reportMissingParameterType = "warning",
                        reportUnknownMemberType = "warning",
                        reportUnknownArgumentType = "warning",
                        reportUnknownVariableType = "warning",
                        reportUnknownLambdaType = "warning",
                        reportUnnecessaryComparison = "warning",
                        reportMissingTypeArgument = "warning",
                        reportUnusedCallResult = "warning",
                        reportReturnType = "warning",
                        reportAny = "warning"
                    }
                }
            }
        }
    },
    ruff_lsp = {},
    zls = {}
}


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



local g = Mappings.genleader("g")
local maps = {
    [g("r")] = { ":Telescope lsp_references<CR>", "goto references" },
    [g("d")] = { "<cmd>lua vim.lsp.buf.definition()<CR>zz", "goto definition" },
    [Mappings.leader("a")] = { Mappings.cmd("CodeActionMenu"), "code action" },
    [g("D")] = { Mappings.luacmd("require('goto-preview').goto_preview_definition()"), "goto definition, popup" },
    [g("q")] = { Mappings.luacmd("require('goto-preview').close_all_win()"), "close popups" },
    [g("l")] = { Mappings.luacmd("vim.diagnostic.open_float()"), "diagnostics" },
    ["K"] = { Mappings.luacmd("vim.lsp.buf.hover()"), "docs" },
    [Mappings.leader("rn")] = { rename, "rename" },
    ["]d"] = { Mappings.luacmd("vim.diagnostic.goto_next({border='rounded'})"), "next diagnostic" },
    ["[d"] = { Mappings.luacmd("vim.diagnostic.goto_prev({border='rounded'})"), "next diagnostic" },
}


local function keybind(mode, lhs, rhs)
    Mappings.keymap(mode, lhs, rhs[1], { noremap = true, silent = true }, rhs[2])
end


function lsp.config()
    local nvim_lsp = require("lspconfig")
    local signs = {
        { name = "DiagnosticSignError", text = " " },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end
    vim.diagnostic.config({
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
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])

    for bind, action in pairs(maps) do
        keybind("n", bind, action)
    end

    for server, setup in pairs(servers) do
        setup.on_attach = on_attach
        setup.capabilities = make_capabilities()
        nvim_lsp[server].setup(setup)
    end
end

add_plugin(lsp)
