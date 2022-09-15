local subscriptions = {}
local function notify(key, message)
    subscriptions[key] = message
    return message
end

local function take(key)
    local ret = subscriptions[key]
    subscriptions[key] = nil
    return ret
end

local function notifier(key, message)
    return function()
        notify(key, message)
    end
end

return {
    subscriptions = subscriptions,
    notify = notify,
    take = take,
    notifier = notifier
}
