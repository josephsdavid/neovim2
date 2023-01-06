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
    if E.take("harpoon") or first_run then
        local marks = require "harpoon".get_mark_config().marks
        marks_cache = {} -- invalidate the cache
        for i, mark in ipairs(marks) do
            marks_cache[mark.filename] = i
        end
        first_run = false
    end
    local idx = marks_cache[vim.fn.fnamemodify(info.buf_name, ":.")]
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

-- -- Defined in TM_FILE
-- local seen = {}
-- local function _pick_buffer()
--     local letters = {"a","s","d","f","j","k","l",";","q","w","p","o","z","x","c","v","b","n","m"}
-- end
--
-- local function pick_buffer(info)
--     seen = {}
--     if E.take("bufferpick") then
--
--     end
-- end

-- https://github.com/akinsho/bufferline.nvim/blob/0606ceeea77e85428ba06e21c9121e635992ccc7/lua/bufferline/pick.lua
local letters = "fewqrilpoBIPUASDF"

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
--
local api = vim.api

local function format_uri(uri)
    if vim.startswith(uri, 'jdt://') then
        local package = uri:match('contents/[%a%d._-]+/([%a%d._-]+)') or ''
        local class = uri:match('contents/[%a%d._-]+/[%a%d._-]+/([%a%d$]+).class') or ''
        return string.format('%s::%s', package, class)
    else
        return vim.fn.fnamemodify(vim.uri_to_fname(uri), ':~:.')
    end
end

function _G._file_or_lsp_status()
    -- Neovim keeps the messages sent from the language server in a buffer and
    -- get_progress_messages polls the messages
    if vim.api.nvim_buf_get_name(api.nvim_get_current_buf()) == "" then
        return ""
    end
    local messages = vim.lsp.util.get_progress_messages()
    local mode = api.nvim_get_mode().mode

    -- If neovim isn't in normal mode, or if there are no messages from the
    -- language server display the file name
    -- I'll show format_uri later on
    if mode ~= 'n' or vim.tbl_isempty(messages) then
        return format_uri(vim.uri_from_bufnr(api.nvim_get_current_buf()))
    end

    local percentage
    local result = {}
    -- Messages can have a `title`, `message` and `percentage` property
    -- The logic here renders all messages into a stringle string
    for _, msg in pairs(messages) do
        if msg.message then
            table.insert(result, msg.title .. ': ' .. msg.message)
        else
            table.insert(result, msg.title)
        end
        if msg.percentage then
            percentage = math.max(percentage or 0, msg.percentage)
        end
    end
    if percentage then
        return string.format('%03d: %s', percentage, table.concat(result, ', '))
    else
        return table.concat(result, ', ')
    end
end

--
function _G._diagnostic_status()
    -- count the number of diagnostics with severity warning
    local num_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    -- If there are any errors only show the error count, don't include the number of warnings
    if num_errors > 0 then
        return '  ' .. num_errors .. ' '
    end
    -- Otherwise show amount of warnings, or nothing if there aren't any.
    local num_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if num_warnings > 0 then
        return '  ' .. num_warnings .. ' '
    end
    return ''
end

--
local mode_names = { -- change the strings if you like it vvvvverbose!
    n = "Normal",
    no = "Normal",
    nov = "Normal",
    noV = "Normal",
    ["no\22"] = "Normal",
    niI = "Normal",
    niR = "Normal",
    niV = "Normal",
    nt = "Normal",
    v = "Visual",
    vs = "Visual",
    V = "Visual",
    Vs = "Visual",
    ["\22"] = "Visual",
    ["\22s"] = "Visual",
    s = "Select",
    S = "Select",
    ["\19"] = "Select",
    i = "Insert",
    ic = "Insert",
    ix = "Insert",
    R = "Replace",
    Rc = "Replace",
    Rx = "Replace",
    Rv = "Replace",
    Rvc = "Replace",
    Rvx = "Replace",
    c = "Command",
    cv = "Ex",
    r = "...",
    rm = "M",
    ["r?"] = "?",
    ["!"] = "!",
    t = "Terminal",
}
--
function _G._MODE()
    local mode = api.nvim_get_mode().mode
    return "[" .. mode_names[mode] .. "] "

end

--
function _G._LINE()
    local parts = {
        [[%{luaeval("_MODE()")}]],
        [[%< %{luaeval("_file_or_lsp_status()")} %m%r%=]],
        -- [[%{luaeval("_diagnostic_status()")}]],
        [[%{luaeval("_diagnostic_status()")} %l,%c %p%%]],
    }
    return table.concat(parts, '')
end

--
vim.cmd [[
    set statusline=%!v:lua._LINE()
]]
