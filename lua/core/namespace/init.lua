M = {}
M.helpers = require("core.namespace.helpers")

M.spec = function(...)
    local out = ...
    return function(...)
        for _, value in pairs(out) do
            value(...)
        end
    end
end

M.trait = function(get, set, ...)
    local getargs = ...
    local old = get(getargs)
    local using_old = true
    return function(...)
        local args = ...
        return function()
            if using_old then
                set(args)
                old = get(getargs)
                using_old = false
            else
                set(old)
                using_old = true
            end
        end
    end
end


M.namespace = function(name, traits, command, binding, description, active, on_enter, on_exit)
    return {
        name = name,
        spec = M.spec(traits),
        command = command or nil,
        binding = binding or nil,
        description = description or nil,
        active = active or false,
        on_enter = on_enter or nil,
        on_exit = on_exit or nil
    }
end

M.toggle_namespace = function(ns)
    ns.active = not (ns.active)
    ns.spec()
    return ns
end


M.export_namespace = function(ns)
    local toggle = partial(M.toggle_namespace, ns)
    if ns.command ~= nil then
        vim.api.nvim_create_user_command(ns.command, toggle, {})
    end
    if ns.binding ~= nil then
        vim.keymap.set("n", ns.binding, toggle, { noremap = true, silent = false, descr = ns.description })
    end
end


return M
