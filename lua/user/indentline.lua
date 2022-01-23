vim.opt.list = true

require("indent_blankline").setup({
	space_char_blankline = " ",
	show_current_context = true,
	show_current_context_start = true,
})

vim.g.indent_blankline_char_list = {  " " }
vim.g.indent_blankline_context_char = ""
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_context_patterns = {
	"class",
	"func",
	"method",
	"if",
	"while",
	"for",
	"with",
	"try",
	"except",
	"arguments",
	"argument_list",
	"object",
	"dictionary",
	"element",
	"table",
	"tuple",
}

-- vim.g.indent_blankline_char_highlight_list = {"Function", "Class", "For", "While", "Error", "Warning"}
