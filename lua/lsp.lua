M = {}


require("goto-preview").setup({})

function RenameWithQuickfix()
	local position_params = vim.lsp.util.make_position_params()
	local new_name = vim.fn.input "New Name > "

	position_params.newName = new_name

	vim.lsp.buf_request(0, "textDocument/rename", position_params, function(err, method, result, ...)
		-- You can uncomment this to see what the result looks like.
		if false then
			print(vim.inspect(result))
		end
		vim.lsp.handlers["textDocument/rename"](err, method, result, ...)

		local entries = {}
		if result.changes then
			for uri, edits in pairs(result.changes) do
				local bufnr = vim.uri_to_bufnr(uri)

				for _, edit in ipairs(edits) do
					local start_line = edit.range.start.line + 1
					local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

					table.insert(entries, {
						bufnr = bufnr,
						lnum = start_line,
						col = edit.range.start.character + 1,
						text = line,
					})
				end
			end
		end

		vim.fn.setqflist(entries, "r")
	end)
end

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
	vim.lsp.set_log_level("ERROR")
	-- if vim.fn.has("nvim-0.5.1") == 1 then
	-- 	require("vim.lsp.log").set_format_func(vim.inspect)
	-- end
	local nvim_lsp = require("lspconfig")
	local on_attach = function(client, bufnr)


		-- local function vim.api.nvim_buf_set_keymap(a,b,c,d)
		-- 	vim.api.nvim_vim.api.nvim_buf_set_keymap(bufnr, a,b,c,d)
		-- end
		local function buf_set_option(...)
			vim.api.nvim_buf_set_option(bufnr, ...)
		end

		buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

		-- Mappings.
		local opts = { noremap = true, silent = true }
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("D"), "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", opts)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			Keys.go("i"),
			"<cmd>vsp<cr><cmd>lua require('goto-preview').goto_preview_implementation()<cr>",
			opts
		)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("x"), "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("r"), "<cmd>lua vim.lsp.buf.references()<cr>", opts)

		-- vim.api.nvim_vim.api.nvim_buf_set_keymap(bufnr, "n", leader .. "D", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("d"), "mD<cmd>lua vim.lsp.buf.definition()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
		-- vim.api.nvim_vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("k"), "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.refactorleader("n"), "<cmd>lua RenameWithQuickfix()<CR>", opts)
		-- vim.api.nvim_vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("a"), "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
		-- vim.api.nvim_vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("l"), '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("q"), "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("s"), "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("S"), "<cmd>lua vim.lsp.workspace_symbol()<CR>", opts)
		if client.name == "tsserver" then
			client.resolved_capabilities.document_formatting = false
		end
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
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
		settings = {
			julia = {
        usePlotPane=false,
				symbolCacheDownload = false,
				lint = {
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
