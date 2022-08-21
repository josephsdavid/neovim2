local km = require("core.keymap")

local function mapping_getter(mode)
    local mappings = vim.api.nvim_get_keymap(mode)
    mappings = filter(function(x) return x.buffer == 0 end, mappings)
    local ret = {}
    for _, v in ipairs(mappings) do
        mappings[mode.rhs] = v
    end
    return ret
end

--- mapget.n() = get current normal mode mappings
local mapget = map(function(mode) return { mode = partial(mapping_getter,mode) } end, { "n", "v", "i", "t" })

function toggledmapping(mode, key, value, descr, opts)
    local oldmap = mapget[mode]()[key]
    local using_old = true
    local function out()
        if using_old then
            km.setmap(key, value, descr, opts)
            using_old = false
        else
            km.setmap(oldmap.lhs, oldmap.rhs, oldmap.descr, { oldmap.mode, oldmap.noremap, oldmap.silent, oldmap.nowait, oldmap.script, oldmap.expr })
            using_old = true
        end
    end

    return out
end

local toggledmode = function(toggledmappings)
    local toggle = function()
        for _, mapping in pairs(toggledmappings) do
            mapping()
        end
    end
    return toggle
end
