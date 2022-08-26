local km = require("core.keymap")
local hydra = require("hydra")

local execute_keys = function(feedkeys)
    local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
    vim.api.nvim_feedkeys(keys, "x", false)
end


local pmode = {
    name = "Parenth-mode",
    config = { color = "pink", invoke_on_body = true },
    mode = "n",
    body = km.localleader("p"),
    heads = {
        {
            "j",
            function()
                vim.fn.search("[({[]")
            end,
            { nowait = true, desc = "next (" },
        },
        {
            "k",
            function()
                vim.fn.search("[({[]", "b")
            end,
            { nowait = true, desc = "previous (" },
        },
    },
}


for surround, motion in pairs({ i = "j", a = "k" }) do
    for doc, key in pairs({ delete = "d", change = "c", delete_surround = "ds" }) do
        local motiondoc
        if motion == "j" then motiondoc = "in" else motiondoc = "around" end
        pmode['heads'][#pmode.heads + 1] = {
            table.concat({ key, motion }),
            table.concat({ key, surround, "%" }),
            { nowait = true, desc = table.concat({ doc, motiondoc }, " ") }
        }
    end
end

hydra(pmode)
