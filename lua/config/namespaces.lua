local minormode = require("core.namespace")
local setmap = minormode.helpers.setmap
local get_nmap = minormode.helpers.get_nmap

local findclosest = function(items, ...)
    local cpos = vim.api.nvim_win_get_cursor(0)
    local npos
    local key = ""
    local dist = math.huge
    for _, p in ipairs(items) do
        npos = vim.fn.searchpos(p, "n", ...)
        local dx, dy = npos[1] - cpos[1], npos[2] - cpos[2]
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

local traits = {}

for index, v in ipairs(bindings) do
    traits[index] = minormode.trait(get_nmap, setmap, v.lhs)(v)
end


local parenthesis_nav = minormode.namespace(
    "parenthesis-navigator",
    traits,
    "Pnav",
    " n",
    " Navigate to the next (, {, or [ with j and k "
)

-- ns.export_namespace(parenthesis_nav)

vim.api.nvim_create_user_command("Pnav", partial(minormode.toggle_namespace, parenthesis_nav), {})
