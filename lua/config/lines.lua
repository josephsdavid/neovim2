-- thanks [ntb](https://github.com/NTBBloodbath/nvim/blob/main/lua/modules/ui/statusline.lua)
local function get_color(name)
    local doom_one_palette = require("doom-one.colors").get_palette(vim.o.background)
    local palette = {
        fg1 = doom_one_palette.fg,
        fg2 = doom_one_palette.fg_alt,
        bg1 = doom_one_palette.base0,
        bg2 = doom_one_palette.bg,
        bg3 = doom_one_palette.bg,
        bg4 = doom_one_palette.bg_alt,
        red = doom_one_palette.red,
        ylw = doom_one_palette.yellow,
        grn = doom_one_palette.green,
        cya = doom_one_palette.cyan,
        blu = doom_one_palette.blue,
        tea = doom_one_palette.teal,
        mag = doom_one_palette.magenta,
        acc = doom_one_palette.violet,
    }
    return palette[name]
end

--- Set custom icons
local setup_icons = require("nvim-web-devicons").setup

setup_icons({
    override = {
        tl = { name = "Teal", icon = "", color = get_color("tea") },
        fnl = { name = "Fennel", icon = "", color = get_color("grn") },
    },
})

local function get_rgb(color)
    return {
        tonumber(color:sub(2, 3), 16),
        tonumber(color:sub(4, 5), 16),
        tonumber(color:sub(6, 7), 16),
    }
end

local function blend_colors(top, bottom, alpha)
    local top_rgb, bottom_rgb = get_rgb(top), get_rgb(bottom)
    local blend = function(c)
        c = ((alpha * top_rgb[c]) + ((1 - alpha) * bottom_rgb[c]))
        return math.floor((math.min(math.max(0, c), 255) + 0.5))
    end
    return string.format("#%02X%02X%02X", blend(1), blend(2), blend(3))
end

--- Tabline setup
local setup = require("tabline_framework").setup

local marks_cache = {}
local first_run = true

local get_mark = function(info)
    -- if info.before_current or info.after_current then
    --     return "_"
    -- end
    if E.Take("harpoonchanged") or first_run then
        marks = require"harpoon".get_mark_config()
        marks_cache[info.buf_name] = require("harpoon.mark").get_index_of(info.buf_name)
        first_run = false
    end
    local idx = marks_cache[info.buf_name]
    local s
    if idx then
        s = idx
    else
        s = ""
    end
    return s
end

local function format_filename(info)
    local name = info.buf_name
    if not (info.filename) then
        return "Empty"
    end
    local formatted_name = vim.fn.fnamemodify(name, ":~:.")
    if string.match(formatted_name, "term:") then
        return "term"
    end
    local t = {}
    for token in string.gmatch(formatted_name, "[^/]+") do
        t[#t + 1] = token
    end
    local out = ""
    for index, value in ipairs(t) do
        if index == #t then
            out = out .. value
        else
            out = out .. string.sub(value, 1, 1) .. "/"
        end

    end
    return out
end

local function render(f)
    f.make_bufs(function(info)
        local icon, icon_color = f.icon(info.filename) or "", f.icon_color(info.filename) or get_color("fg1")
        local color_fg = info.current and icon_color
        local color_bg = blend_colors(icon_color, get_color("bg1"), info.current and 0.38 or 0.2)

        f.add({
            " " .. icon .. " ",
            bg = color_bg,
            fg = color_fg,
        })
        f.add({
            string.format("%s ", format_filename(info)),
            bg = color_bg,
            fg = info.current and get_color("fg1") or color_fg,
        })
        f.add({
            string.format("%s ", info.modified and "[+]" or ""),
            bg = color_bg,
            fg = info.modified and color_fg or (info.current and get_color("red") or color_fg),
        })
        f.add({
            string.format("%s ", get_mark(info)),
            bg = color_bg,
            fg = color_fg,
        })
    end)
    f.add_spacer()
    f.make_tabs(function(info)
        f.add(" " .. info.index .. " ")
    end)
end

setup({ render = render })

-- Fix for white colors on colorscheme change
-- HACK: find a way to update everything without calling setup again
vim.api.nvim_create_augroup("Tabline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    group = "Tabline",
    callback = function()
        setup_icons({
            override = {
                tl = { name = "Teal", icon = "", color = get_color("tea") },
                fnl = { name = "Fennel", icon = "", color = get_color("grn") },
                -- norg = { name = "Neorg", icon = "", color = get_color("grn") },
            },
        })
        setup({ render = render })
    end,
})
