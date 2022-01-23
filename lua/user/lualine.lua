local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end
local gps = require("nvim-gps")
gps.setup({
  depth = 4,
  icons = {
      ["class-name"] = ' ',      -- Classes and class-like objects
      ["function-name"] = ' ',   -- Functions
      ["method-name"] = ' ',     -- Methods (functions inside class-like objects)
      ["container-name"] = '⛶ ',  -- Containers (example: lua tables)
      ["tag-name"] = '炙',         -- Tags (example: html tags)
      ["conditional-name"] = '',
      ["loop-name"] = 'ﯩ',
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

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

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
		theme = "everforest",
    -- theme = "vscode",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = {"filename"},
		lualine_b = { mode },
		lualine_c = { gps_fn },
		-- lualine_x = { "encoding", "fileformat", "filetype", spaces,filetype,},
		lualine_x = { diagnostics,branch, diff},
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

ins_left {
	'lsp_progress',
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
	display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
	timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
	spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
}

lualine.setup(config)
