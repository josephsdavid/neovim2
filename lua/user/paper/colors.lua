-- vim:fdm=marker
-- Neovim Color File
-- Name:            doom-one
-- Maintainer:      https://github.com/NTBBloodbath
-- License:         The MIT License (MIT)
-- Based On:        https://github.com/romgrk/doom-one.vim and the original Doom Emacs one

local colors = {
  dark = {
    bg = "#282c34",
    fg = "#bbc2cf",

    bg_alt = "#21242b",
    fg_alt = "#5b6268",

		base0 = "#1b2229",
		base1 = "#1c1e1e",
		base2 = "#202328",
		base3 = "#23272e",
		base4 = "#3f444a",
		base5 = "#5b6268",
		base6 = "#73797e",
		base7 = "#9ca0a4",
		base8 = "#dfdfdf",

		grey = "#3f444a",
		red = "#ff6c6b",
		orange = "#da8548",
		green = "#98be65",
		teal = "#4db5bd",
		yellow = "#ecbe7b",
		blue = "#51afef",
		dark_blue = "#2257a0",
		magenta = "#c678dd",
		violet = "#a9a1e1",
		cyan = "#46d9ff",
		dark_cyan = "#5699af",
  },
	light = {
		bg = "#fffffa",
		fg = "#202421",

		bg_alt = "#fff0f0",
		fg_alt = "#444444",

		base0 = "#f0f0f0",
		base1 = "#e7e7e7",
		base2 = "#dfdfdf",
		base3 = "#c6c7c7",
		base4 = "#9ca0a4",
		base5 = "#424242",
		base6 = "#2e2e2e",
		base7 = "#1e1e1e",
		base8 = "#1b2229",

		grey = "#bcbcbc",
		red = "#af0000",
		orange = "#d75f00",
		green = "#008700",
		teal = "#009700",
		yellow = "#d7f500",
		blue = "#005f87",
		dark_blue = "#0087af",
		violet = "#8700af",
		magenta = "#d70087",
		cyan = "#005faf",
		dark_cyan = "#005478",
	},
}

colors.get_palette = function(current_bg)
	return colors[current_bg]
end

return colors

