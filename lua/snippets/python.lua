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

local function saved_text(args, snip, old_state, placeholder)
    local nodes = {}
    if not old_state then
        old_state = {}
    end
    if not placeholder then
        placeholder = {}
    end
    local indent = placeholder.indent and '\t' or ''

    if snip.snippet.env and snip.snippet.env.SELECT_DEDENT and #snip.snippet.env.SELECT_DEDENT > 0 then
        local lines = vim.deepcopy(snip.snippet.env.SELECT_DEDENT)
        -- local indent_level = require'utils.buffers'.get_indent_block_level(lines)
        -- lines = require'utils.buffers'.indent(lines, -indent_level)
        -- TODO: We may need to use an indent indepente node to avoid indenting empty lines
        for idx = 1, #lines do
            local line = indent .. lines[idx]
            local node = idx == #lines and { line } or { line, '' }
            table.insert(nodes, t(node))
        end
    else
        local text = placeholder.text or '# placeholder'
        if indent ~= '' then
            table.insert(nodes, t(indent))
        end
        table.insert(nodes, i(1, text))
    end

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

local function surround_with_func(args, snip, old_state, placeholder)
    local nodes = {}
    if not old_state then
        old_state = {}
    end
    if not placeholder then
        placeholder = {}
    end

    if snip.snippet.env and snip.snippet.env.SELECT_RAW and #snip.snippet.env.SELECT_RAW == 1 then
        local node = snip.snippet.env.SELECT_RAW[1]
        table.insert(nodes, t(node))
    else
        local text = placeholder.text or 'placeholder'
        table.insert(nodes, i(1, text))
    end

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

local function python_class_init(args, snip, old_state, placeholder)
    local nodes = {}

    if snip.captures[1] == 'd' then
        table.insert(
            nodes,
            c(1, {
                t { '' },
                sn(nil, { t { '\t' }, i(1, 'attr') }),
            })
        )
    else
        table.insert(nodes, t { '', '\tdef __init__(self' })
        table.insert(
            nodes,
            c(1, {
                t { '' },
                sn(nil, { t { ', ' }, i(1, 'arg') }),
            })
        )
        table.insert(nodes, t { '):', '\t\t' })
        table.insert(nodes, i(2, 'pass'))
    end

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

local function python_dataclass(args, snip, old_state, placeholder)
    local nodes = {}

    table.insert(nodes, snip.captures[1] == 'd' and t { '@dataclass', '' } or t { '' })

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

local function else_clause(args, snip, old_state, placeholder)
    local nodes = {}

    if snip.captures[1] == 'e' then
        table.insert(nodes, t { '', 'else', '\t' })
        table.insert(nodes, i(1, 'pass'))
    else
        table.insert(nodes, t { '' })
    end

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

M = {
    s("for", {
        t{"for "}, i(1, 'i'), t{" in "}, i(2, 'Iterator'), t{":", ""},
            d(3, saved_text, {}, {text = 'pass', indent = true}),
    }),
    s("ran", {
        t{"range("}, i(1, '0'), t{", "}, i(2, 'limit'), t{")"},
    }),
    s("imp", {
        t{'import '}, i(1, 'sys')
    }),
    s(
        { trig = 'from', regTrig = true },
        {
            t{'from '}, i(1, 'os'), t{' import '}, i(2, 'path')
        }
    ),
    s(
        { trig = "if", regTrig = true },
        {
            t{"if "}, i(1, 'condition'), t{":", ""},
                d(2, saved_text, {}, {text = 'pass', indent = true}),
            d(3, else_clause, {}, {}),
        }
    ),
    s("def", {
        t{"def "}, i(1, 'name'), t{"("}, i(2, 'args'), t{"):", ""},
            d(3, saved_text, {}, {text = 'pass', indent = true}),
    }),
    s("try", {
        t{"try:", "",},
            d(1, saved_text, {}, {text = 'pass', indent = true}),
        t{"", "except "},
            c(2, {
                t{'Exception as e'},
                t{'KeyboardInterrupt as e'},
                sn(nil, { i(1, 'Exception') }),
            }),
        t{":", "\t"},
            i(3, 'pass'),
    }),
    s("ifmain", {
        t{'if __name__ == "__main__":', '\t'},
            c(1, {
                sn(nil, { t{'exit('}, i(1, 'main()'), t{')'} }),
                t{'pass'},
            }),
        t{"", "else:", "\t"},
            i(2, 'pass'),
    }),
    s("with", {
        t{"with open("}, i(1, 'filename'), t{', '},
        c(2, {
            i(1, '"r"'),
            i(1, '"a"'),
            i(1, '"w"'),
        }),
        t{') as '}, i(3, 'data'), t{':', ''},
            d(4, saved_text, {}, {text = 'pass', indent = true}),
    }),
    s("w", {
        t{"while "}, i(1, 'True'), t{":", ""},
            d(2, saved_text, {}, {text = 'pass', indent = true}),
    }),
    s(
        { trig = "dcl", regTrig = true },
        {
            d(1, python_dataclass, {}, {}),
            t{"class "}, i(2, 'Class'), t{"("},
            c(3, {
                t{''},
                i(1, 'object'),
            }),
            t{"):", '\t"""'},
            dl(4, l._1 .. ': docstring', { 2 }),
            t{'"""', ''},
            d(5, python_class_init, {}, {}),
        }
    ),
}

return M
