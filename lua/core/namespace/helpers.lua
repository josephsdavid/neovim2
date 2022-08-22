Helpers = {}

local function catch_keymap_nil(mode)
    local out = vim.api.nvim_get_keymap(mode)
    if out == nil then
        return { mode = mode, opt={noremap=true, silent=true}}
    end
    return out
end

-- TODO: Something here doesnt work, we need to pass in mode without the line 6 shit,
-- or make this API less dumb
Helpers.get_keymap = function(t, k)
    if t.lhs == nil then
        return {
            lhs = k,
            rhs = k,
            mode = t.mode,
            opt = {}
        }
    end
    local tmp = {}
    for _, v in ipairs(t) do
        tmp[v.lhs] = {
            lhs = v.lhs,
            rhs = v.rhs,
            mode = v.mode,
            opt = {
                script = v.script,
                expr = v.expr,
                desc = v.desc,
                nowait = v.nowait,
                silent = v.silent,
                noremap = v.noremap
            }
        }
    end
    return tmp[k]
end

for _, mode in ipairs({ "n", "v", "i", "t" }) do
    Helpers[table.concat({ "get_", mode, "map" })] = partial(Helpers.get_keymap, catch_keymap_nil(mode))
end

Helpers.setmap = function(t)
    vim.keymap.set(t.mode, t.lhs, t.rhs, t.opt or {})
end


return Helpers
