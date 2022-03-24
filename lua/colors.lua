-- local colorscheme = "rigel"
-- local colorscheme = "tokyonight"
-- local colorscheme = "purify"
local colorscheme = "forestbones"
vim.g.everforest_background = "soft"

vim.g.everforest_enable_italic = 1
vim.g.everforest_disable_italic_comment = 0
vim.g.everforest_ui_contrast = "high"
vim.g.everforest_diagnostic_text_highlight = 1
-- vim.g.everforest_current_word = "bold"
vim.g.everforest_better_performance = 1

vim.g.kanagawabones = { solid_line_nr = false, darken_comments = 45, darkness="stark" }
vim.g.forestbones = { solid_line_nr = true, darken_comments = 45, darkness="warm" }
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

-- -- Change the "hint" color to the "orange" color, and make the "error" color bright red
vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }
-- -- local colorscheme = "kanagawabones"
--

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

