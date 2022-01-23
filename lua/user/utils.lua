local function make_leader(leader)
  local function ret(s)
    return leader .. s
  end
  return ret
end

local function make_mod(leader)
  local function ret(s)
    return "<"..leader.."-" .. s..">"
  end
  return ret
end

local tz_config =  {
	ui = {
		bottom = {
			laststatus = 0,
			ruler = false,
			showmode = false,
			showcmd = false,
			cmdheight = 1,
		},
		top = {
			showtabline = 0,
		},
		left = {
			number = false,
			relativenumber = false,
			signcolumn = "no",
		},
	},
	modes = {
		ataraxis = {
			left_padding = 20,
			right_padding = 20,
			top_padding = 1,
			bottom_padding = 1,
			ideal_writing_area_width = { 0 },
			auto_padding = true,
			keep_default_fold_fillchars = true,
			custom_bg = { "none", "" },
			bg_configuration = true,
			quit = "untoggle",
			ignore_floating_windows = true,
			affected_higroups = {
				NonText = true,
				FoldColumn = true,
				ColorColumn = true,
				VertSplit = true,
				StatusLine = true,
				StatusLineNC = true,
				SignColumn = true,
			},
		},
		focus = {
			margin_of_error = 5,
			focus_method = "experimental",
		},
	},
	integrations = {
		vim_gitgutter = false,
		galaxyline = false,
		tmux = false,
		gitsigns = false,
		nvim_bufferline = false,
		limelight = false,
		twilight = true,
		vim_airline = false,
		vim_powerline = false,
		vim_signify = false,
		express_line = false,
		lualine = true,
		lightline = false,
		feline = false,
	},
	misc = {
		on_off_commands = false,
		ui_elements_commands = false,
		cursor_by_mode = false,
	},
}

M = {}

local mappings = {}

mappings.leader = make_leader("<leader>")
mappings.swapleader = make_leader(mappings.leader("m"))
mappings.peekleader = make_leader(mappings.leader("p"))
mappings.refactorleader = make_leader(mappings.leader("r"))
mappings.docsleader = make_leader(mappings.leader("n"))
mappings.commentleader = make_leader(mappings.leader("c"))
mappings.vcommentleader = make_leader(mappings.leader("v"))
mappings.actionleader = make_leader(mappings.leader("c"))
mappings.telescopeleader = make_leader(mappings.leader("f"))
mappings.troubleleader = make_leader(mappings.leader("x"))
mappings.zeplleader = make_leader(mappings.leader("s"))
mappings.C = make_mod("c")
mappings.A = make_mod("a")
mappings.S  = make_mod("s")
mappings.hopleader =  make_leader(mappings.leader("h"))
mappings.go = make_leader("g")
mappings.tableader = make_leader(mappings.leader("t"))
mappings.bufferleader = make_leader(mappings.leader("b"))
mappings.norgleader = make_leader(mappings.leader('o'))



M.mappings = mappings
M.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
M.tz_config = tz_config


return M
