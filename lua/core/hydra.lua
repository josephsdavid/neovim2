local km = require("core.keymap")
local hydra = require("hydra")

local ex = function(feedkeys)
    return function()
        local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
        vim.api.nvim_feedkeys(keys, "m", false)
    end
end

local config = {}
local exit = { nil, { exit = true, desc = "EXIT"} }

config.parenth_mode = {
    color = "pink",
    body = km.localleader("p"),
    [km.localleader("p")] = exit,
    j = { function() vim.fn.search("[({[]") end, { nowait = true, desc = "next" } },
    k = { function() vim.fn.search("[({[]", "b") end, { nowait = true, desc = "next" } },
}


for surround, motion in pairs({ i = "j", a = "k" }) do
    for doc, key in pairs({ delete = "d", change = "c", yank = "y" }) do
        local motiondoc
        if motion == "j" then motiondoc = "within" else motiondoc = "around" end
        local mapping = table.concat({ key, motion })
        config.parenth_mode[mapping] = {
            ex(table.concat({ key, surround, "%" })),
            { nowait = true, desc = table.concat({ doc, motiondoc }, " ") }
        }
    end
end

for name, spec in pairs(config) do
    local new_hydra = { name = name, config = {
        invoke_on_body = true,
        timeout = false,
        hint = { type = "statusline" }
    },
    heads = {}
    }
    for lhs, rhs in pairs(spec) do
        if lhs == "color" then
            new_hydra.config[lhs] = rhs
        elseif lhs == "body" then
            new_hydra[lhs] = rhs
        else
            -- TODO: Compat for newer luajit
            new_hydra.heads[#new_hydra.heads + 1] = { lhs, unpack(rhs) }
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
