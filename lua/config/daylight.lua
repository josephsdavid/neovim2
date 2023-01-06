local function getHostname()
    local f = io.popen("/bin/hostname")
    local hostname = f:read("*a") or ""
    f:close()
    hostname = string.gsub(hostname, "\n$", "")
    return hostname
end

local function host_is_not(s)
    local hostname = string.lower(getHostname())
    if string.find(hostname, s) then
        return false
    else
        return true
    end
end

if host_is_not("djosephs") then
    return {
        "NTBBloodbath/daylight.nvim",
        config = function()
            local daylight = require "daylight"
            daylight.setup({
                day = {
                    name = vim.g.colors_name,
                    time = 8, -- 8 am
                },
                night = {
                    name = vim.g.colors_name,
                    time = 19, -- 7 pm, changes to dark theme on 07:01
                },
                interval = 60000, -- Time in milliseconds, 1 minute
            })
            vim.cmd([[DaylightToggle]])
        end,
    }
else
    return nil
end
