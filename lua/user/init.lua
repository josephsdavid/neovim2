local km = require("core.keymap")

local findclosest = function(items, backwards)
    -- NOTE: BROKEN
    backwards = false or backwards
    local cpos = vim.api.nvim_win_get_cursor(0)
    local npos
    local key = ""
    local dist = math.huge
    for _, p in ipairs(items) do
        if not(backwards) then
            npos = vim.fn.searchpos(p, "n")
        else
            npos = vim.fn.searchpos(p, "n", "b")
        end
        local dx, dy = npos[1] - cpos[1], npos[2] - cpos[2]
        if backwards then
            dx = -dx
            dy = -dy
        end
        if dx > 0 or dy > 0 then
            local test_dist = dx + dy
            if test_dist < dist then
                dist = test_dist
                key = p
            end
        end
    end
    if key ~= "" then
        if not(backwards) then
            vim.fn.search(key)
        else
            vim.fn.search(key, "b")
        end
    end
end

local delims ={"(", "{", "["}


local pfinder = function ()
    local enabled = false
    return function ()
        if not(enabled) then
            print("Enabling parenthesis mode")
            vim.keymap.set("n", "j", function() return findclosest(delims) end, {noremap = true, silent = true})
            vim.keymap.set("v", "j", function() return findclosest(delims, true) end, {noremap = true, silent = true})
        else
            print("Disabling parenthesis mode")
            vim.keymap.del("n", "j")
            vim.keymap.del("v", "j")
        end
        enabled = not(enabled)

    end
end

local pfind = pfinder()

vim.keymap.set( "n",km.leader("p"), pfind,
    {desc =  "toggle parenthesis mode",  noremap = true, silent = true })
