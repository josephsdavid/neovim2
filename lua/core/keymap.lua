M = {}

local wk = require("whichkey")

M.setmap = function(key, value, descr, opts)
    wk.register({ [key] = { value, descr } }, opts)
end

M.genleader = function(leader)
    local function ret(s)
        return table.concat({ leader, s })
    end

    return ret
end

M.genheldkey = function(leader)
    local function ret(s)
        return table.concat({ "<", leader, "-", s, ">" })
    end

    return ret
end

M.leader = M.genleader("<Leader>")
M.localleader = M.genleader("<LocalLeader>")
M.Ctrl = M.genheldkey("c")
M.Alt = M.genheldkey("a")
M.Shift = M.genheldkey("s")
M.plugmapping = M.genleader("<Plug>")


local mode_map = {normal = "n", visual = "v", terminal = "t", insert = "t", xmode = "x"}

M.init_binds = function ()
    local ret =  { default = {} }
    for k, _ in pairs(mode_map) do
        ret.default[k] = {}
    end
    return ret
end

M.process_binds = function(binds)

    for _, v in pairs(binds) do
        for kk, vv in pairs(v) do
            for mode, def in pairs(vv) do
                local modestr = mode_map[mode]
                for lhs, rhs in pairs(def) do
                    M.setmap(lhs, rhs[1], rhs[2], {mode = modestr})
                end
            end
        end
    end
end

return M