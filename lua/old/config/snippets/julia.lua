local M = {}

local ls    = require("luasnip")
local s     = ls.snippet
local sn    = ls.snippet_node
local t     = ls.text_node
local i     = ls.insert_node
local f     = ls.function_node
local c     = ls.choice_node
local d     = ls.dynamic_node
local r     = ls.restore_node
local l     = require("luasnip.extras").lambda
local rep   = require("luasnip.extras").rep
local p     = require("luasnip.extras").partial
local m     = require("luasnip.extras").match
local n     = require("luasnip.extras").nonempty
local dl    = require("luasnip.extras").dynamic_lambda
local fmt   = require("luasnip.extras.fmt").fmt
local fmta  = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

local same = function(index)
    return f(function(arg) return arg[1] end, { index })
end


local newline = t({ "", "" })

local rec_ls
rec_ls = function()
    return sn(nil, {
        c(1, {
            -- important!! Having the sn(...) as the first choice will cause infinite recursion.
            t({ "" }),
            -- The same dynamicNode as in the snippet (also note: self reference).
            sn(nil, { t(''), i(1), t({ '=>' }), i(2), t(","), d(3, rec_ls, {}) }),
        }),
    })
end


local function do_choice(fun)
    return c(
        1, {
        fmt(fun .. "({}, {})\n{}", { i(1, "function"), i(2, "iterable"), i(3) }),
        fmt(fun .. "({}) do {}\n\t{}\nend\n{}", { i(1, "iterable"), i(2, "item"), i(3, "body"), i(4) })

    })
end


local function backtick()
    return c(
        1, {
        fmt("\"{}\"", { i(1, "name")}),
        fmt("\"`{}`\"", { i(1, "name")}),

    })
end

M.snippets = {

    s("dict", { t({ "Dict(" }), d(1, rec_ls, {}), t({ ")" }) }),
    s("block_comment", fmt("####\n#### {}\n####", { i(1, "SECTION") })),
    s("docstring", fmt("\"\"\"\n{}\n\"\"\"", { i(1, "DOC") })),
    s("map", { do_choice("map") }),
    s("filter", { do_choice("filter") }),
    s("reduce", { do_choice("reduce") }),
    s("tern", fmt("{} ? {} : {}", {i(1, "cond"), i(2, "if_true"), i(3, "if_false")})),
    s("testset", fmt( "@testset {} begin\n\t{}\nend",
        {
            backtick(),
        i(2, "")
        }
    )
    )
}
return M
