local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end
local gps = require("nvim-gps")
gps.setup({
	depth = 4,
	icons = {
		["class-name"] = " ", -- Classes and class-like objects
		["function-name"] = " ", -- Functions
		["method-name"] = " ", -- Methods (functions inside class-like objects)
		["container-name"] = "💼 ", -- Containers (example: lua tables)
		["tag-name"] = "炙", -- Tags (example: html tags)
		["conditional-name"] = "",
		["loop-name"] = "ﯩ",
	},
})

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = true,
	update_in_insert = false,
	always_visible = true,
}

-- local diff = {
-- 	"diff",
-- 	colored = false,
-- 	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
-- 	cond = hide_in_width,
-- }

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local gps_fn = function()
	local loc = gps.get_location()
	if loc == "error" then
		loc = ""
	end
	return loc
end

local filetype = {
	"filetype",
	icons_enabled = true,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
}

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local config = {
	options = {
		icons_enabled = true,
		theme = "auto",
		-- theme = "vscode",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
		globalstatus=true,
	},
	sections = {
		lualine_a = { "filename" },
		lualine_b = { mode },
		lualine_c = { gps_fn },
		-- lualine_x = { "encoding", "fileformat", "filetype", spaces,filetype,},
		lualine_x = {  branch},
		lualine_y = { location },
		lualine_z = { progress },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
}

local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	"lsp_progress",
	-- display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' }},
	-- With spinner
	-- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
	-- colors = {
	--   percentage  = colors.cyan,
	--   title  = colors.cyan,
	--   message  = colors.cyan,
	--   spinner = colors.cyan,
	--   lsp_client_name = colors.magenta,
	--   use = true,
	-- },
	-- separators = { is typing slow? I dont think so? typing is insantant
	-- 	component = ' ',
	-- 	progress = ' | ',
	-- 	message = { pre = '(', post = ')'},
	-- 	percentage = { pre = '', post = '%% ' },
	-- 	title = { pre = '', post = ': ' },
	-- 	lsp_client_name = { pre = '[', post = ']' },
	-- 	spinner = { pre = '', post = '' },
	-- 	message = { commenced = 'In Progress', completed = 'Completed' },
	-- },
	display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
	timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
	spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
})

lualine.setup(config)



-- Set barbar's options
vim.g.bufferline = {
	-- Enable/disable animations
	animation = true,

	-- Enable/disable auto-hiding the tab bar when there is a single buffer
	auto_hide = false,

	-- Enable/disable current/total tabpages indicator (top right corner)
	tabpages = true,

	-- Enable/disable close button
	closable = true,

	-- Enables/disable clickable tabs
	--  - left-click: go to buffer
	--  - middle-click: delete buffer
	clickable = true,

	-- Excludes buffers from the tabline
	--[[ exclude_ft = {'javascript'},
  exclude_name = {'package.json'}, ]]

	-- Enable/disable icons
	-- if set to 'numbers', will show buffer index in the tabline
	-- if set to 'both', will show buffer index and icons in the tabline
	icons = true,

	-- If set, the icon color will follow its corresponding buffer
	-- highlight group. By default, the Buffer*Icon group is linked to the
	-- Buffer* group (see Highlighting below). Otherwise, it will take its
	-- default value as defined by devicons.
	icon_custom_colors = false,

	-- Configure icons on the bufferline.
	icon_separator_active = "▎",
	icon_separator_inactive = "▎",
	icon_close_tab = "",
	icon_close_tab_modified = "●",
	icon_pinned = "車",

	-- If true, new buffers will be inserted at the start/end of the list.
	-- Default is to insert after current buffer.
	insert_at_end = false,
	insert_at_start = false,

	-- Sets the maximum padding width with which to surround each tab
	maximum_padding = 4,

	-- Sets the maximum buffer name length.
	maximum_length = 30,

	-- If set, the letters for each buffer in buffer-pick mode will be
	-- assigned based on their name. Otherwise or in case all letters are
	-- already assigned, the behavior is to assign letters in order of
	-- usability (see order below)
	semantic_letters = true,

	-- New buffer letters are assigned in this order. This order is
	-- optimal for the qwerty keyboard layout but might need adjustement
	-- for other layouts.
	letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

	-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
	-- where X is the buffer number. But only a static string is accepted here.
	no_name_title = nil,
}

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
