local km = require("core.keymap")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

local has_words_before = function()
	local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local rhs = function(rhs_str)
	return vim.api.nvim_replace_termcodes(rhs_str, true, true, true)
end
local column = function()
	local _line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	return col
end

local shift_width = function()
	if vim.o.softtabstop <= 0 then
		return vim.fn.shiftwidth()
	else
		return vim.o.softtabstop
	end
end

local smart_tab = function(opts)
	local keys = nil
	if vim.o.expandtab then
		keys = "<Tab>" -- Neovim will insert spaces.
	else
		local col = column()
		local line = vim.api.nvim_get_current_line()
		local prefix = line:sub(1, col)
		local in_leading_indent = prefix:find("^%s*$")
		if in_leading_indent then
			keys = "<Tab>" -- Neovim will insert a hard tab.
		else
			-- virtcol() returns last column occupied, so if cursor is on a
			-- tab it will report `actual column + tabstop` instead of `actual
			-- column`. So, get last column of previous character instead, and
			-- add 1 to it.
			local sw = shift_width()
			local previous_char = prefix:sub(#prefix, #prefix)
			local previous_column = #prefix - #previous_char + 1
			local current_column = vim.fn.virtcol({ vim.fn.line("."), previous_column }) + 1
			local remainder = (current_column - 1) % sw
			local move = remainder == 0 and sw or sw - remainder
			keys = (" "):rep(move)
		end
	end

	vim.api.nvim_feedkeys(rhs(keys), "nt", true)
end

local smart_bs = function()
	if vim.o.expandtab then
		return rhs("<BS>")
	else
		local col = column()
		local line = vim.api.nvim_get_current_line()
		local prefix = line:sub(1, col)
		local in_leading_indent = prefix:find("^%s*$")
		if in_leading_indent then
			return rhs("<BS>")
		end
		local previous_char = prefix:sub(#prefix, #prefix)
		if previous_char ~= " " then
			return rhs("<BS>")
		end
		-- Delete enough spaces to take us back to the previous tabstop.
		--
		-- Originally I was calculating the number of <BS> to send, but
		-- Neovim has some special casing that causes one <BS> to delete
		-- multiple characters even when 'expandtab' is off (eg. if you hit
		-- <BS> after pressing <CR> on a line with trailing whitespace and
		-- Neovim inserts whitespace to match.
		--
		-- So, turn 'expandtab' on temporarily and let Neovim figure out
		-- what a single <BS> should do.
		--
		-- See `:h i_CTRL-\_CTRL-O`.
		return rhs("<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>")
	end
end

--   פּ ﯟ   some other good icons
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),

		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-' '>"] = cmp.mapping.confirm({ select = true }),

		["<CR>"] = cmp.mapping.confirm({
			select = true,
			behavior = cmp.ConfirmBehavior.Insert,
		}),

		[km.Ctrl("f")] = cmp.mapping(function(fallback)
			if luasnip.choice_active() then
				require("luasnip").change_choice(1)
			elseif cmp.visible() then
				cmp.scroll_docs(4)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<C-d>"] = cmp.mapping(function(fallback)
			if luasnip.choice_active() then
				require("luasnip").change_choice(-1)
			elseif cmp.visible() then
				cmp.scroll_docs(-4)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<BS>"] = cmp.mapping(function(_fallback)
			local keys = smart_bs()
			vim.api.nvim_feedkeys(keys, "nt", true)
		end, { "i", "s" }),

		["<Tab>"] = cmp.mapping(function(core, fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif not check_backspace() then
				cmp.mapping.complete()(core, fallback)
			elseif has_words_before() then
				cmp.complete()
			else
                smart_tab()
			end
		end, {
			"i",
			"s",
		}),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				smart_bs()
			end
		end, {
			"i",
			"s",
		}),

		[km.Ctrl("j")] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.mapping.abort()
				cmp.mapping.close()
			end
			if luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),

		[km.Ctrl("k")] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.mapping.abort()
				cmp.mapping.close()
			end
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),

	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				luasnip = "[SNIP]",
				nvim_lsp = "[LSP]",
				conjure = "[CONJ]",
				treesitter = "[TS]",
				nvim_lua = "[NVIM_LUA]",
				path = "[PATH]",
				neorg = "[NEORG]",
				buffer = "[BUFF]",
				latex_symbols = "[TEX]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "luasnip" },
		{ name = "conjure" },
		{ name = "nvim_lsp" },
		{ name = "treesitter" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "neorg" },
		{ name = "buffer" },
		{ name = "latex_symbols" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	-- documentation = {
	-- 	border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	-- },
	experimental = {
		ghost_text = true,
		native_menu = false,
	},
})
