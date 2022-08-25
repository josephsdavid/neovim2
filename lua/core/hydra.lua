local km = require("core.keymap")
local hydra = require("hydra")

hydra({
    name = "Parenth-mode",
    config = { color = "pink" },
    mode = "n",
    body = km.localleader("p"),
    heads = {
        { "j", function() vim.fn.search("[({[]") end, { nowait = true, desc = "next (" } },
        { "k", function() vim.fn.search("[({[]", "b") end, { nowait = true, desc = "previous (" } },
        { "dj", "d]%", { nowait = true, desc = "next (" } },
        { "dJ", "d%", { nowait = true, desc = "next (" } },
        { "cj", "ct)", { nowait = true, desc = "next (" } },
        { "cJ", "c%", { nowait = true, desc = "next (" } },
        { km.localleader("p"), nil, { exit = true } }
    }
})

local function colorcycler(reverse)
    local colors = vim.fn.getcompletion("", "color")
    local ccol = vim.g.colors_name
    local len = #colors
    local i = 1
    for index, value in ipairs(colors) do
        if value == ccol then
            i = index
        end
    end
    return function()
        if reverse then
            i = i - 1
        else
            i = i + 1
        end
        if i > len then
            i = 1
        elseif i < 1 then
            i = len
        end
        local out = colors[i]
        vim.cmd('colorscheme ' .. out)
        print("using colorcheme: " .. out)
    end
end


hydra({
    name = "Color Cycler",
    config = { color = "amaranth", hint = {type = "statusline"}, },
    mode = "n",
    body = km.localleader("C"),
    heads = {
        { "j", colorcycler(false), { desc = "next colorscheme" } },
        { "k", colorcycler(true), { desc = "previous colorscheme" } },
    }
})
