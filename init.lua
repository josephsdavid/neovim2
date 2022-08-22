require("impatient")
function partial(f, ...)
    local args = ...
    return function(...)
        return f(args, ...)
    end
end

function map(f, ...)
    local t = {}
    for k, v in ipairs(...) do
        t[#t+1] = f(v)
    end
    return t
end

function dmap(f, ...)
    local t = {}
    for k, v in pairs(...) do
        t[k] = f(v)
    end
    return t
end

function filter(f, ...)
    local t = {}
    for _, v in ipairs(...) do
        if f(v) == true then
            t[#t+1] = (v)
        end
    end
    return t
end

function dfilter(f, ...)
    local t = {}
    for k, v in pairs(...) do
        if f(v) == true then
            t[k] = (v)
        end
    end
    return t
end

require"core"
require "config"
