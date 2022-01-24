-- local colorscheme = "rigel"
-- local colorscheme = "tokyonight"
-- local colorscheme = "purify"
local colorscheme = "everforest"
vim.g.everforest_background = 'soft'

vim.g.everforest_enable_italic = 1
vim.g.everforest_disable_italic_comment = 0
vim.g.everforest_ui_contrast = 'high'
vim.g.everforest_diagnostic_text_highlight = 1
vim.g.everforest_current_word = 'bold'
-- vim.g.everforest_better_performance = 1



-- vim.g.kanagawabones = { solid_line_nr = true, darken_comments = 45, darkness="stark" }
-- vim.g.tokyonight_style = "night"
-- vim.g.tokyonight_italic_functions = true
-- vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
--
-- -- Change the "hint" color to the "orange" color, and make the "error" color bright red
-- vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }
-- -- local colorscheme = "kanagawabones"
--


local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

local bases = {
    base00 = "1F1F28",
    base01 = "2A2A37",
    base02 = "54546D",
    base03 = "717C7C",
    base04 = "C8C093",
    base05 = "DCD7BA",
    base06 = "e1dcbf",
    base07 = "e1dcbf",
    base08 = "7AA89F",
    base09 = "FFA066",
    base0A = "7AA89F",
    base0B = "98BB6C",
    base0C = "C0A36E",
    base0D = "7E9CD8",
    base0E = "8d77b0",
    base0F = "9CABCA",
}
