local status_ok, line = pcall(require, "staline")
if not status_ok then
  return
end



line.setup {
  mode_colors = {
    n = "#a7c080",
    i = "#7fbbb3",
    v = "#d699b6",
    iv = "#d699b6",
    c = "#e67e80"
  },
	sections = {
		left = { "-file_name" , "mode" }, -- change thickness: "_", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"
		mid = {},
		right = {}
	},
}
