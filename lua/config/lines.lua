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
        local marks = require"harpoon".get_mark_config().marks
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
    local t = {} for token in string.gmatch(formatted_name, "[^/]+") do
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


local heirline = require("heirline")
local utils = require("heirline.utils")
local conditions = require("heirline.conditions")

--- Colors
local function setup_colors()
	local doom_one_palette = require("doom-one.colors").get_palette(vim.o.background)
	return {
		fg1 = utils.get_highlight("StatusLine").fg,
		bg1 = utils.get_highlight("StatusLine").bg,
		red = doom_one_palette.red,
		ylw = doom_one_palette.yellow,
		org = doom_one_palette.orange,
		grn = doom_one_palette.green,
		cya = doom_one_palette.cyan,
		blu = doom_one_palette.blue,
		mag = doom_one_palette.magenta,
		vio = doom_one_palette.violet,
	}
end
heirline.load_colors(setup_colors())

--- Components
--
-- Spacing
local align, space = { provider = "%=" }, { provider = " " }

-- Vi-mode
local vi_mode = {
	static = {
		names = {
			n = "Normal",
			no = "Normal",
			i = "Insert",
			t = "Terminal",
			v = "Visual",
			V = "Visual Line",
            Vs = "Visual Block",
            ["\22"] = "Visual Block",
            ["\22s"] = "Visual Block",
			s = "Select",
			S = "Select Line",
			R = "Replace ",
			Rv = "Replace",
			r = "Prompt",
			c = "Command",
		},
		colors = {
			n = "red",
			no = "red",
			i = "grn",
			t = "red",
			v = "blu",
			V = "blu",
            Vs = "blu",
            ["\22"] = "blu",
            ["\22s"] = "blu",
			s = "cya",
			S = "cya",
			R = "mag",
			Rv = "mag",
			r = "cya",
			c = "mag",
		},
	},

	init = function(self)
		self.mode = vim.fn.mode()
	end,
	provider = function(self)
		local mode = self.mode:sub(1, 1)
        return table.concat({" [",self.names[mode],"] "})
	end,
	hl = function(self)
		local mode = self.mode:sub(1, 1)
		return {
			fg = "bg1",
			bg = self.colors[mode],
			bold = true,
		}
	end,
}

-- File (name, icon)
local file_name = utils.make_flexible_component(2, {
	provider = function()
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
		return filename:len() == 0 and "[No Name]" or filename
	end,
}, {
	provider = function()
		return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
	end,
})
file_name.hl = function(self)
	return { bg = "bg1", fg = "fg1" }
end

local file_flags = {
	{
		provider = function()
			return vim.bo.modified and " " or ""
		end,
		hl = { bg = "bg1", fg = "ylw" },
	},
	{
		provider = function()
			if not vim.bo.modifiable or vim.bo.readonly then
				return " "
			end
			return ""
		end,
		hl = { bg = "bg1", fg = "ylw" },
	},
}
local file_info = {
	init = function(self)
		self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
		self.extension = vim.fn.fnamemodify(self.filename, ":e")
	end,
	file_name,
	space,
	space,
	file_flags,
	{ provider = "%<" },
}

-- Ruler
-- %l = current line number
-- %L = number of lines in the buffer
-- %c = column number
-- %P = percentage through file of displayed window
local ruler = { provider = "%7(%l/%3L%):%2c  %P" }

-- Git
local git_branch = {
	{ provider = " ", hl = { fg = "red" } },
	{
		provider = function(self)
			return " " .. self.status_dict.head
		end,
	},
	space,
}

local git_diff_spacing = {
	provider = " ",
	condition = function(self)
		return self.has_changes
	end,
}
local git_added = {
	provider = function(self)
		local count = self.status_dict.added
		if count and count > 0 then
			string.format(" %d", count)
		end
	end,
	hl = { fg = "grn" },
}
local git_removed = {
	provider = function(self)
		local count = self.status_dict.removed
		if count and count > 0 then
			string.format(" %d", count)
		end
	end,
	hl = { fg = "red" },
}
local git_changed = {
	provider = function(self)
		local count = self.status_dict.changed
		if count and count > 0 then
			string.format(" %d", count)
		end
	end,
	hl = { fg = "org" },
}

local git = {
	condition = conditions.is_git_repo,
	init = function(self)
		self.has_changes = false
		self.status_dict = vim.b.gitsigns_status_dict
		if
			not self.status_dict.added == 0
			or not self.status_dict.removed == 0
			or not self.status_dict.changed == 0
		then
			self.has_changes = true
		end
	end,
	git_branch,
	git_diff_spacing,
	git_added,
	git_diff_spacing,
	git_removed,
	git_diff_spacing,
	git_changed,
	git_diff_spacing,
}

-- Diagnostics
local diagnostics = {
	condition = conditions.has_diagnostics,
	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	end,
	{
		provider = function(self)
			if self.errors > 0 then
				return " " .. self.errors .. " "
			end
		end,
		hl = { fg = "red" },
	},
	{
		provider = function(self)
			if self.warnings > 0 then
				return " " .. self.warnings .. " "
			end
		end,
		hl = { fg = "ylw" },
	},
	{
		provider = function(self)
			if self.hints > 0 then
				return " " .. self.hints .. " "
			end
		end,
		hl = { fg = "grn" },
	},
	{
		provider = function(self)
			if self.info > 0 then
				return " " .. self.info .. " "
			end
		end,
		hl = { fg = "cya" },
	},
}

-- Terminal name
local terminal_name = {
	provider = function(self)
		string.format("Terminal %d", vim.b.toggle_number)
	end,
}

--- Statuslines
--
-- Default
local default = {  vi_mode, space, file_info, diagnostics, align, git, space, ruler, space }
default.hl = function(self)
	return { bg = "bg1", fg = "fg1" }
end

-- Terminal
local terminal = { space, terminal_name, align }
terminal.hl = function(self)
	return { bg = "bg1", fg = "fg1" }
end
terminal.condition = function(self)
	return vim.bo.filetype == "toggleterm"
end

heirline.setup({
	fallthrough = false,
	terminal,
	default,
})

-- Fix for white colors on colorscheme change
vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = "Heirline",
	callback = function()
		local colors = setup_colors()
		utils.on_colorscheme(colors)
	end,
})
