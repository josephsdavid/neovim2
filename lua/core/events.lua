local subscriptions = {}
local function notify(message, f, ...)
    if type(f) == "function" then
        local ret = f(...)
        subscriptions[message] = ret
        return ret
    end
    subscriptions[message] = f
    return f
end

local function take(message)
    local ret = subscriptions[message]
    subscriptions[message] = nil
    return ret
end

local function notifier(message, f)
    return function(...)
        notify(message, f, ...)
    end
end

return {
    Subscriptions = subscriptions,
    Notify = notify,
    Take = take,
    Notifier = notifier
}
