local comment = require("Comment")

comment.setup({
	pre_hook = function(ctx)
		local U = require("Comment.utils")

		local location = nil
		if ctx.ctype == U.ctype.block then
			location = require("ts_context_commentstring.utils").get_cursor_location()
		elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
			location = require("ts_context_commentstring.utils").get_visual_start_location()
		end

		return require("ts_context_commentstring.internal").calculate_commentstring({
			key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
			location = location,
		})
	end,
	toggler = {
		---Line-comment toggle keymap
		line = Keys.go("cc"),
		---Block-comment toggle keymap
		block = Keys.go("cb"),
	},
	---LHS of operator-pending Keys in NORMAL + VISUAL mode
	---@type table
	opleader = {
		---Line-comment keymap
		line = Keys.go("c"),
		---Block-comment keymap
		block = Keys.go("b"),
	},

	---LHS of extra Keys
	---@type table
	extra = {
		---Add comment on the line above
		above = Keys.go("cO"),
		---Add comment on the line below
		below = Keys.go("co"),
		---Add comment at the end of line
		eol = Keys.go("cl"),
	},

	mappings = {
		---Operator-pending mapping
		---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
		---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
		basic = true,
		---Extra mapping
		---Includes `gco`, `gcO`, `gcA`
		extra = true,
		---Extended mapping
		---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
		extended = true,
	},
})
