local ok, gitsigns = Prequire("gitsigns")

if not ok then
	return
end

gitsigns.setup({
	signcolumn = false,
	numhl = false,
	current_line_blame = false,
	keymaps = {},
})

