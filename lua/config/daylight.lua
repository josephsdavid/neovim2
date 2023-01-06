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
