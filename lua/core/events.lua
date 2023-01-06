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

local function inspect()
    vim.pretty_print(subscriptions)
end

return {
    subscriptions = subscriptions,
    notify = notify,
    take = take,
    notifier = notifier,
    inspect = inspect
}

