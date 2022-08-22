local minormode = require("core.namespace")

local findclosest = function(items, ...)
    local cpos = vim.api.nvim_win_get_cursor(0)
    local npos
    local key = ""
    local dist = math.huge
    local args = ...
    local backwards = false
    for _, a in ipairs(args) do
        if a == "b" then
            backwards = true
        end
    end
    for _, p in ipairs(items) do
        npos = vim.fn.searchpos(p, "n", ...)
        local dx, dy = npos[1] - cpos[1], npos[2] - cpos[2]
        if backwards then
            dx = -dx
            dy = -dy
        end
        if dx > 0 and dy > 0 then
            local test_dist = dx + dy
            if test_dist < dist then
                dist = test_dist
                key = p
            end
        end
    end
    if key ~= "" then
        vim.fn.search(key, ...)
    end
end


local bindings = {
    {
        mode = "n",
        lhs = "j",
        rhs = partial(findclosest, { "(", "[", "{" }),
        opts = {
            noremap = true,
            silent = true,
            descr = "find next parenthesis like"
        }
    },
    {
        mode = "n",
        lhs = "k",
        rhs = partial(findclosest, { "(", "[", "{" }, "b"),
        opts = {
            noremap = true,
            silent = true,
            descr = "find next parenthesis like"
        }
    }
}

for index, value in ipairs(bindings) do
    bindings[index] = minormode.keybind_trait(value)
end


local parenthesis_nav = minormode.new_mode(
    "parenthesis-navigator",
    bindings,
    "Pnav",
--[[     " n" ]] nil,
    " Navigate to the next (, {, or [ with j and k "
)

minormode.export(parenthesis_nav)

-- ns.export_namespace(parenthesis_nav)

-- vim.api.nvim_create_user_command("Pnav", partial(minormode.toggle_namespace, parenthesis_nav), {})
