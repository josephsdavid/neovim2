local km = require("core.keymap")
local hydra = require("hydra")

if table.unpack == nil then
    table.unpack = unpack
end



local mx = function(feedkeys)
    return function()
        local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
        vim.api.nvim_feedkeys(keys, "m", false)
    end
end

local ex = function(feedkeys)
    return function()
        local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
        vim.api.nvim_feedkeys(keys, "x", false)
    end
end


-- NOTE:
local config = {}





local exit = { nil, { exit = true, desc = "EXIT" } }






-- TODO: make a toggler for cursorhold events, so we can show peek
function toggle(lhs, on_enter, on_exit)
    return {
        color = "pink",
        body = lhs,
        [lhs] = exit,
        on_exit = on_exit,
        on_enter = on_enter
    }
end

--#region ?

config.parenth_mode = {
    color = "pink",
    body = km.leader("p"),
    mode = {"n", "v", "x", "o"},
    -- TODO: add in maybe treesitter node surfing and we are good to make this a thing
    [km.leader("p")] = exit,
    j = { function() vim.fn.search("[({[]") end, { nowait = true, desc = "next" } },
    k = { function() vim.fn.search("[({[]", "b") end, { nowait = true, desc = "next" } },
    J = { function() vim.fn.search("[)}\\]]") end, { nowait = true, desc = "next" } },
    K = { function() vim.fn.search("[)}\\]]", "b") end, { nowait = true, desc = "next" } },
    [")"] = { mx("ysi%)"), { nowait = true , desc = "i)"} },
    ["("] = { mx("ysa%)"), { nowait = true , desc = "a("} },
    ["]"] = { mx("ysi%]"), { nowait = true , desc = "i]"} },
    ["["] = { mx("ysa%]"), { nowait = true , desc = "a["} },
    ["}"] = { mx("ysi%}"), { nowait = true , desc = "i}"} },
    ["{"] = { mx("ysa%{"), { nowait = true , desc = "a{"} },
    ["F"] = { mx("ysi%f"), { nowait = true , desc = "iF"} },
    ["f"] = { mx("ys"), { nowait = true , desc = "add surroundings"} },
}

-- TODO:
-- config.parenth_quickmode = config.parenth_mode
-- config.parenth_quickmode[#config.parenth_quickmode+1] = {["<ESC>"] = exit}
-- config.parenth_quickmode.color = "red"


for surround, motion in pairs({ i = "j", a = "k" }) do
    for doc, key in pairs({ d = "d", c = "c", y = "y" }) do
        local motiondoc = surround
        -- if motion == "j" then motiondoc = "i" else motiondoc = "i" end
        local mapping = table.concat({ key, motion })
        config.parenth_mode[mapping] = {
            mx(table.concat({ key, surround, "%" })),
            { nowait = true, desc = table.concat({ doc, motiondoc }) }
        }
    end
end


-- function (peek_aucmd)
--
-- end
--


local mapping = {
    color = function (t, rhs)
        t.config.color = rhs
    end,
    body = function (t, rhs)
        t.body = rhs
    end,
    on_enter = function (t, rhs)
        t.config.on_enter = rhs
    end,
    on_exit = function (t, rhs)
        t.config.on_exit = rhs
    end,
    mode = function (t, rhs)
        t.config.mode = rhs
    end
}



--#region

for name, spec in pairs(config) do
    local new_hydra = { name = name, config = {
        invoke_on_body = true,
        timeout = false,
        hint = {type = "cmdline"}
    },
    heads = {}
    }
    for lhs, rhs in pairs(spec) do
        local action = mapping[lhs]
        if action == nil then
            new_hydra.heads[#new_hydra.heads + 1] = { lhs, table.unpack(rhs) }
        else
            action(new_hydra, rhs)
        end
    end
    hydra(new_hydra)
end
