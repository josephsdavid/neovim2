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

local function header(pos)
    local snippet = sn(pos, {
        t("$(MMI.doc_header("),
        i(1),
        t({ "))", "`" }),
        same(1),
        t("`")

    })
    return snippet
end

local function implements(pos)
    local snippet = sn(pos, {
        t(" implements the $"),
        i(1),
        t({
            ".",
            "",
            "# Training data",
            "",
            "In MLJ or MLJBase, bind an instance `model` to data with",
            "\tmach = machine(model, X, y)",
            "",
            "Where",
            ""
        })
    })
    return snippet
end

local classif = t({
    "- `X`: any table of input features (eg, a `DataFrame`) whose columns",
    "  each have one of the following element scitypes: `Continuous`,",
    "  `Count`, or `<:OrderedFactor`; check column scitypes with `schema(X)`",
    "",
    "- `y`: is the target, which can be any `AbstractVector` whose element",
    "  scitype is `<:OrderedFactor` or `<:Multiclass`; check the scitype",
    "  with `scitype(y)`",
    ""
})

local regress = t({
    "- `X`: any table of input features (eg, a `DataFrame`) whose columns",
    "  each have one of the following element scitypes: `Continuous`,",
    "  `Count`, or `<:OrderedFactor`; check column scitypes with `schema(X)`",
    "",
    "- `y`: is the target, which can be any `AbstractVector` whose element",
    "  scitype is `Continuous`; check the scitype with `scitype(y)`",
    ""
})

local function training_data(pos)
    local out = c(pos, { classif, regress })
    return out
end

local newline = t({ "", "" })

local args = function(delim)
    local out
    out = function()
        return sn(nil, {
            c(1, {
                -- important!! Having the sn(...) as the first choice will cause infinite recursion.
                t({ "" }),
                -- The same dynamicNode as in the snippet (also note: self reference).
                sn(nil, { t({ "", delim }), t("`"), i(1), t("`: "), i(2), d(3, out, {}) }),
            }),
        })
    end
    return out
end

local function titled_list(header, delim)
    return { t("#" .. header), newline, d(1, args(delim), {}) }
end

local operations = function(delim)
    local out
    out = function()
        return sn(nil, {
            c(1, {
                -- important!! Having the sn(...) as the first choice will cause infinite recursion.
                t({ "" }),
                -- The same dynamicNode as in the snippet (also note: self reference).
                sn(nil, { t({ "", delim }), t("`"), i(1), t("(mach, Xnew)`: "), i(2), d(3, out, {}) }),
            }),
        })
    end
    return out
end

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


local function do_choice(fname)
    return c(
        1, {
        fmt(fname .. "({}, {})\n{}", { i(1, "function"), i(2, "iterable"), i(3) }),
        fmt(fname .. "({}) do {}\n\t{}\nend\n{}", { i(1, "iterable"), i(2, "item"), i(3, "body"), i(4) })

    }
    )

end

M.snippets = {

    s("dict", { t({ "Dict(" }), d(1, rec_ls, {}), t({ ")" }) }),
    s("block_comment", fmt("####\n#### {}\n####", { i(1, "SECTION") })),
    s("docstring", fmt("\"\"\"\n{}\n\"\"\"", { i(1, "DOC") })),
    s("args", {
        titled_list("Args", "- ")
    }),
    s("hyperparams", {
        titled_list("Hyper-parameters", "- ")
    }),
    s("operations", {
        titled_list("Operations", "- ")
    }),
    s("map", { do_choice("map") }),
    s("filter", { do_choice("filter") }),
    s("reduce", { do_choice("reduce") }),


}
return M
