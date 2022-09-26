local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "<-", "Error" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
})


local function char_count_same(c1, c2)
	local line = vim.api.nvim_get_current_line()
	-- '%'-escape chars to force explicit match (gsub accepts patterns).
	-- second return value is number of substitutions.
	local _, ct1 = string.gsub(line, "%" .. c1, "")
	local _, ct2 = string.gsub(line, "%" .. c2, "")
	return ct1 == ct2
end

local function even_count(character)
	local line = vim.api.nvim_get_current_line()
	local _, ct = string.gsub(line, character, "")
	return ct % 2 == 0
end

local function neg(fn, ...)
	return not fn(...)
end

local function part(fn, ...)
	local args = { ... }
	return function()
		return fn(unpack(args))
	end
end

-- This makes creation of pair-type snippets easier.
local function pair(pair_begin, pair_end, expand_func, ...)
	-- triggerd by opening part of pair, wordTrig=false to trigger anywhere.
	-- ... is used to pass any args following the expand_func to it.
	return s({ trig = pair_begin, wordTrig = false }, {
		t({ pair_begin }),
		i(1),
		t({ pair_end }),
	}, {
		condition = part(expand_func, part(..., pair_begin, pair_end)),
	})
end

local iterator = function(delim)
	local rec_ls
	rec_ls = function()
		return sn(nil, {
			c(1, {
				-- important!! Having the sn(...) as the first choice will cause infinite recursion.
				t({ "" }),
				-- The same dynamicNode as in the snippet (also note: self reference).
				sn(nil, { t({ "", delim }), i(1), d(2, rec_ls, {}) }),
			}),
		})
	end
	return rec_ls
end

-- these should be inside your snippet-table.

local snippets = {
	all = {
		pair("(", ")", neg, char_count_same),
		pair("{", "}", neg, char_count_same),
		pair("[", "]", neg, char_count_same),
		pair("<", ">", neg, char_count_same),
		pair("'", "'", neg, even_count),
		pair('"', '"', neg, even_count),
		pair("`", "`", neg, even_count),
		s(
			"trig",
			c(1, {
				t("Ugh boring, a text node"),
				i(nil, "At least I can edit something now..."),
				f(function(args)
					return "Still only counts as text!!"
				end, {}),
			})
		),
	},
	-- python = require("user.snippets.python"),
	lua = {
		ls.parser.parse_snippet("lf", "-- Defined in $TM_FILE\nlocal $1 = function($2)\n\t$0\nend"),
		ls.parser.parse_snippet("mf", "-- Defined in $TM_FILE\nlocal $1.$2 = function($3)\n\t$0\nend"),
		s("lreq", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })), -- to lreq, bind parse the list
	},
	norg = {

		s("def", fmt("{} *{}* /{}/", { i(1, "-"), i(2, "to_define"), i(3, "definition") })), -- to lreq, bind parse the list
		s("sdef", fmt("${} \n{}", { i(1, "to_define"), i(2, "definition") })), -- to lreq, bind parse the list
		s("ldef", fmt("$$ {} \n{} \n$$", { i(1, "to_define"), i(2, "definition") })), -- to lreq, bind parse the list
		s("code", fmt("@code {} \n{} \n@end", { i(1, "-"), i(2) })), -- to lreq, bind parse the list
		s("math", fmt("@math  \n{} \n@end", { i(1) })), -- to lreq, bind parse the list
		s("table", fmt("@table  \n{} \n@end", { i(1) })), -- to lreq, bind parse the list
		s("data", fmt("@data  \n{} \n@end", { i(1) })), -- to lreq, bind parse the list
		s("link", fmt("{{{}}}[{}]", { i(1, "object"), i(2, "description") })), -- to lreq, bind parse the list
		-- pair("*", "*", neg, even_count),
		pair("/", "/", neg, even_count),
		pair(",", ",", neg, even_count),
		pair("^", "^", neg, even_count),
		pair("_", "_", neg, even_count),
		pair("*", "*", neg, even_count),

		s("mn", fmt("{} {}\n ", { i(1, "*"), i(2, "title") })), -- to lreq, bind parse the list
		s("l1", d(1, iterator("- "), {})), -- to lreq, bind parse the list
		s("l1", d(1, iterator("- "), {})), -- to lreq, bind parse the list
		s("l2", d(1, iterator("-- "), {})), -- to lreq, bind parse the list
		s("l3", d(1, iterator("--- "), {})), -- to lreq, bind parse the list
		s("i1", d(1, iterator("~ "), {})), -- to lreq, bind parse the list
		s("i2", d(1, iterator("~~ "), {})), -- to lreq, bind parse the list
		s("i3", d(1, iterator("~~~ "), {})), -- to lreq, bind parse the list
	},
	julia = require("config.snippets.julia").snippets,
    c = require("config.snippets.c").snippets,
}
ls.autosnippets = {
	all = {
		s("autotrigger", {
			t("autosnippet"),
		}),
	},
}

-- ls.filetype_extend("cpp", { "c" })

ls.add_snippets("all", snippets.all)
ls.add_snippets("lua", snippets.lua)
ls.add_snippets("python", snippets.python)
ls.add_snippets("norg", snippets.norg)
ls.add_snippets("julia", snippets.julia)
ls.add_snippets("c", snippets.c)

