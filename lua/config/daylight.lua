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
            vim.cmd([[colorscheme doom-one]])
            require("daylight").setup({
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
        end,
    }
else
    return nil
end

