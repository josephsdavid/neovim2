local M = {}


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

-- This was an outline of what you could do w/ lsp and not opening .d.ts files when they are
-- the only definition.
function ExampleTS()
  local position_params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", position_params, function(err, method, result, ...)
    -- local new_result = vim.tbl_filter(function(v)
    --   return not string.find(v.uri, ".d.ts", 1, true)
    -- end, result)

    if #result == 1 and string.find(result[1].uri, ".d.ts", 1, true) then
      -- Open nice little floaty window at cursor w/ that file in it
      local bufnr = open_or_get_bufnr(...)
      vim.api.nvim_open_win(bufnr, ...)
      return
    end

    vim.lsp.handlers["textDocument/definition"](err, method, result, ...)
  end)
end

-- TODO: backfill this to template
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
		scope = "cursor",
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
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then

		-- vim.api.nvim_exec(
		-- 	[[
		--     augroup lsp_document_highlight
		--       autocmd! * <buffer>
		--       autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		--       autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		--     augroup END

		--   ]],
		-- 	false
		-- )
	end
end

require("goto-preview").setup({
	width = 120, -- Width of the floating window
	height = 15, -- Height of the floating window
	border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
	default_mappings = false, -- Bind default mappings
	debug = false, -- Print debug information
	opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
	resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
	post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
	-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
	focus_on_open = true, -- Focus the floating window when opening it.
	dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
	force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
	bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
})

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		Keys.go("D"),
		"<cmd>lua require('goto-preview').goto_preview_definition()<cr>",
		opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		Keys.go("i"),
		"<cmd>vsp<cr><cmd>lua require('goto-preview').goto_preview_implementation()<cr>",
		opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("x"), "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("r"), "<cmd>lua vim.lsp.buf.references()<cr>", opts)

	-- vim.api.nvim_buf_set_keymap(bufnr, "n", leader .. "D", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("d"), "mD<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("k"), "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.refactorleader("n"), "<cmd>lua RenameWithQuickfix()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("a"), "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		Keys.go("l"),
		'<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
		opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("q"), "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("s"), "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", Keys.go("S"), "<cmd>lua vim.lsp.workspace_symbol()<CR>", opts)
end

M.on_attach = function(client, bufnr)
	vim.o.updatetime = 250
	-- vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]
	vim.cmd([[autocmd CursorHoldI * lua vim.lsp.buf.hover(nil, {focus=false})]])
	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
	end
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

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
if not status_ok then
	return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
