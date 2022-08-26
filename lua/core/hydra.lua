local km = require("core.keymap")
local hydra = require("hydra")

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

local config = {}
local exit = { nil, { exit = true, desc = "EXIT" } }

config.parenth_mode = {
    color = "pink",
    body = km.localleader("p"),
    [km.localleader("p")] = exit,
    j = { function() vim.fn.search("[({[]") end, { nowait = true, desc = "next" } },
    k = { function() vim.fn.search("[({[]", "b") end, { nowait = true, desc = "next" } },
    [")"] = { mx("ysi%)"), { nowait = true , desc = "i)"} },
    ["("] = { mx("ysa%)"), { nowait = true , desc = "a("} },
    ["]"] = { mx("ysi%]"), { nowait = true , desc = "i]"} },
    ["["] = { mx("ysa%]"), { nowait = true , desc = "a["} },
    ["}"] = { mx("ysi%}"), { nowait = true , desc = "i}"} },
    ["{"] = { mx("ysa%{"), { nowait = true , desc = "a{"} },
    ["f"] = { mx("ysa%f"), { nowait = true , desc = "af"} },
    ["F"] = { mx("ysi%f"), { nowait = true , desc = "iF"} },
}


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
    end
}

for name, spec in pairs(config) do
    local new_hydra = { name = name, config = {
        invoke_on_body = true,
        timeout = false,
        hint = { type = "statusline" }
    },
    heads = {}
    }
    for lhs, rhs in pairs(spec) do
        action = mapping[lhs]
        if action == nil then
            new_hydra.heads[#new_hydra.heads + 1] = { lhs, unpack(rhs) }
        else
            action(new_hydra, rhs)
        end
    end
    hydra(new_hydra)

end


--
-- local pmode = {
--     name = "Parenth-mode",
--     config = { color = "pink", invoke_on_body = true, timeout = false, hint = {type = 'statusline'}},
--     mode = "n",
--     body = km.localleader("p"),
--     heads = {
--         {
--             km.localleader("p"),
--             nil,
--             { exit = true, desc = "EXIT" },
--         },
--         {
--             "j",
--             function()
--                 vim.fn.search("[({[]")
--             end,
--             { nowait = true, desc = "next" },
--         },
--         {
--             "k",
--             function()
--                 vim.fn.search("[({[]", "b")
--             end,
--             { nowait = true, desc = "previous" },
--         },
--     },
-- }
--
--
-- for surround, motion in pairs({ i = "j", a = "k" }) do
--     for doc, key in pairs({ delete = "d", change = "c", yank = "y"}) do
--         local motiondoc
--         if motion == "j" then motiondoc = "within" else motiondoc = "around" end
--         pmode['heads'][#pmode.heads + 1] = {
--             table.concat({ key, motion }),
--             ex(table.concat({ key, surround, "%" })),
--             { nowait = true, desc = table.concat({ doc, motiondoc }, " ") }
--         }
--     end
-- end
--
-- local surrounds = {"[", "{", "("}
-- local out_dict = {}
-- for i, v in ipairs(surrounds) do
--     i = i -1
--     if i == 0 then i = #surrounds end
--     out_dict[v] = surrounds[i]
-- end
--
-- local function toggle()
--     ex("%")
--     -- TODO: work through and toggle surrounds, get current surround and then pop back, or just use i
-- end
--
-- hydra(pmode)
