local subscriptions = {}
local function notify(subscription, f, ...)
    local ret = f(...)
    subscriptions[subscription] = ret
    return ret
end

local function take(subscription)
    local ret = subscriptions[subscription]
    subscriptions[subscription] = nil
    return ret
end

return {
    Subscriptions = subscriptions,
    Notify = notify,
    Take = take
}
