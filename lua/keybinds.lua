local wk = require("which-key")
local function apply_maps(list, opts) for key, value in pairs(list) do
		vim.api.nvim_set_keymap(key[1], key[2], value[1], opts)
		wk.register({ [key[2]] = value[2] })
	end
end

local function leader_map(leader, list, opts)
	for key, value in pairs(list) do
		vim.api.nvim_set_keymap(key[1], leader(key[2]), value[1], opts)
		wk.register({ [leader(key[2])] = value[2] })
	end
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.lasttab = 1
vim.cmd([[au TabLeave * let g:lasttab = tabpagenr()]])
vim.cmd([[
function! InsertLine()
  let trace = expand("__import__('pdb').set_trace()")
  execute "normal O".trace
endfunction
]])

local map_table = {

	basic = { -- basic mappings that dont fit elsehwere
		leader = nil,
		name = nil,
		opts = { noremap = true, silent = true },
		maps = {
			[{ "", " " }] = { "<Nop>", "" },
			[{ "", "0" }] = { "^", "start of line" },
			-- [{ "i", "jk" }] = "<ESC>",
			[{ "t", "<Esc>" }] = { "<C-\\><C-n>", "Terminal escape" },
			[{ "n", "_" }] = { "<C-^>", "Last Buffer" },
			[{ "n", "cl" }] = { "s", "delete and insert mode" },
			[{ "v", "<" }] = { "<gv", "Move text left" },
			[{ "v", ">" }] = { ">gv", "Move text right" },
			[{ "v", "p" }] = { '"_dP', "" },
			[{ "x", "J" }] = { ":move '>+1<CR>gv-gv", "Move text up" },
			[{ "x", "K" }] = { ":move '<-2<CR>gv-gv", "Move text down" },
			[{ "n", "<F9>" }] = { "<cmd>lua require('yabs'):run_default_task()<cr>", "Run file" },
      -- yabs:run_default_task()
		},
	},

	leader = { -- general mappings such as leader-w, leader then key combination
		leader = Keys.leader,
		name = "leader",
		opts = { noremap = true, silent = true },
		maps = {
			[{ "n", "e" }] = { ":Lex 30<cr>", "File Explorer" },
			[{ "n", "jf" }] = { ":JuliaFormatterFormat<cr>", "Format Julia file" },
			[{ "v", "jf" }] = { ":JuliaFormatterFormat<cr>", "Format Julia file" },
			[{ "n", "jps" }] = { ":!plot_server<cr>", "Start plot server" },
			[{ "n", "jpr" }] = { ":!plot_server -r<cr>", "Restart plot server" },
			[{ "n", "jpk" }] = { ":!plot_server -k<cr>", "Kill plot server" },
			[{ "n", "jpc" }] = { ":!plot_server -c<cr>", "Clean plot server" },
			[{ "n", "w" }] = { ":w!<cr>", "save" },
			[{ "n", "cd" }] = { "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", "cd to current file" },
			-- [{ "n", "l" }] = { "<cmd>ISwapWith<cr>", "Swap elements" },
			-- [{ "n", "L" }] = { "<cmd>ISwap<cr>", "Swap elements (hard mode)" },
		},
	},

	ctrl = { -- mappings to <C-
		leader = Keys.C,
		name = "CTRL",
		opts = { noremap = true, silent = true, nowait = true },
		maps = {
			-- [{ "", "b" }] = { ":call InsertLine()<CR>", "pdb" },
			[{ "n", "h" }] = { "<C-w>h", "Window left" },
			[{ "n", "j" }] = { "<C-w>j", "Window down" },
			[{ "n", "k" }] = { "<C-w>k", "Window up" },
			[{ "n", "l" }] = { "<C-w>l", "Window right" },
			[{ "t", "h" }] = { "<C-\\><C-N><C-w>h", "Terminal window left" },
			[{ "t", "j" }] = { "<C-\\><C-N><C-w>j", "Terminal window down" },
			[{ "t", "k" }] = { "<C-\\><C-N><C-w>k", "Terminal window up" },
			[{ "t", "l" }] = { "<C-\\><C-N><C-w>l", "Terminal window right" },
			-- [{ "n", "P" }] = { ":BufferPick<CR>", "Pick buffer" },
			-- [{ "n", "P" }] = { "<cmd>lua require('fzf-lua').files()<cr>", "fzf" },
			[{ "n", "p" }] = { "<cmd>lua require('fzf-lua').oldfiles()<cr>", "oldfiles" },
			-- [{ "i", "j" }] ={ ":move '>+1<CR>gv-gv",""},
			-- [{ "i", "k" }] ={ ":move '<-2<CR>gv-gv",""},
		},
	},

	alt = { -- mappings to <A- and <M-
		leader = Keys.A,
		name = "ALT",
		opts = { noremap = true, silent = true, nowait = true },
		maps = {
			[{ "v", "K" }] = { ":m -.2<CR>==", "Move text down" },
			[{ "v", "J" }] = { ":m +.1<CR>==", "Move text up" },
			[{ "x", "J" }] = { ":move '>+1<CR>gv-gv", "Move text up" },
			[{ "x", "K" }] = { ":move '<-2<CR>gv-gv", "Move text down" },
			[{ "t", "h" }] = { "<C-\\><C-N><C-w>h", "Terminal window left" },
			[{ "t", "j" }] = { "<C-\\><C-N><C-w>j", "Terminal window down" },
			[{ "t", "k" }] = { "<C-\\><C-N><C-w>k", "Terminal window up" },
			[{ "t", "l" }] = { "<C-\\><C-N><C-w>l", "Terminal window right" },
			[{ "n", "Up" }] = { ":resize +2<CR>", "Increase window size horizontal" },
			[{ "n", "Left" }] = { ":vertical resize -2<CR>", "Decrease window size vertical" },
			[{ "n", "Right" }] = { ":vertical resize +2<CR>", "Increase window size vertical" },
			[{ "n", "Down" }] = { ":resize -2<CR>", "Decrease window size horizontal" },
			[{ "n", "," }] = { ":bprevious<CR>", "Previous buffer" },
			[{ "n", "." }] = { ":bnext<CR>", "Next buffer" },
			-- [{ "n", "h" }] = { ":lua require'dap'.continue()<CR>", "dap continue" },
			-- [{ "n", "j" }] = { ":lua require'dap'.step_over()<CR>", "dap step over" },
			-- [{ "n", "k" }] = { ":lua require'dap'.step_out()<CR>", "dap step out" },
			-- [{ "n", "l" }] = { ":lua require'dap'.step_into()<CR>", "dap step into" },
		},
	},

	buf = { -- mappings to buffer leader
		leader = Keys.bufferleader,
		name = "buffer",
		opts = { noremap = true, silent = false },
		maps = {
			[{ "", "n" }] = { ":bnext<CR>", "next buffer" },
			[{ "", "p" }] = { ":bprevious<CR>", "previous buffer" },
			[{ "", "l" }] = { ":bprevious<CR>", "previous buffer" },
			[{ "", " " }] = { ":bnext<CR>", "next buffer" },
			[{ "", "b" }] = { ":bnext<CR>", "next buffer" },
			[{ "", "x" }] = { ":lua MiniBufremove.wipeout()<CR>", "close buffer" },
			[{ "", "s" }] = { ":b ", "select buffer" },
			[{ "", "1" }] = { ":bfirst<CR>", "first buffer" },
			[{ "", "0" }] = { ":blast<CR>", "last buffer" },
		},
	},

	docs = { -- mappings to docsleader
		leader = Keys.docsleader,
		name = "duck/docs",
		opts = { noremap = true, silent = false },
		maps = {
			[{ "n", "C" }] = { ":lua require('neogen').generate({type = 'class'})<CR>", "Document class" },
			[{ "n", "s" }] = { ":lua require('neogen').generate({type = 'struct'})<CR>", "Document class" },
			[{ "n", "f" }] = { ":lua require('neogen').generate()<CR>", "Document function" },
			[{ "n", " " }] = { ":lua require('neogen').generate()<CR>", "Document function" },
			[{ "n", "d" }] = { ":lua require('duck').hatch('🐔')<CR>", "make duck" },
			[{ "n", "D" }] = { ":lua require('duck').cook()<CR>", "kill duck" },
			-- [{ "n", "h" }] = { ":lua require('dap').toggle_breakpoint()<CR>", "breakpoint" },
			-- [{ "n", "H" }] = { ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", "conditional breakpoint" },
			-- [{ "n", "n" }] = { ":lua require('dap').run_to_cursor()<CR>", "run to cursor" },
			-- [{ "n", "k" }] = { ":lua require('dap').up()<CR>", "dap up" },
			-- [{ "n", "j" }] = { ":lua require('dap').down()<CR>", "dap down" },
			-- [{ "n", "x" }] = { ":lua require('dap').terminate()<CR>", "dap terminate" },
			-- [{ "n", "r" }] = { ":lua require('dap').repl.toggle({}, 'vsplit')<CR><C-w>l", "dap repl" },
			-- [{ "n", "h" }] = { ":lua require('dap').lua require'dap'.set_exception_breakpoints({'all'})<CR>", "breakpoints at exceptions" },
			-- [{ "n", "e" }] = { ":lua require('dapui').eval()<CR>", "Evaluate" },
			-- [{ "n", "?" }] = { ":lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>", "scopes" },
		},
	},
	refactor = { -- mappings to refactorleader
		leader = Keys.refactorleader,
		name = "refactor",
		opts = { noremap = true, silent = false },
		maps = {
			[{ "v", "r" }] = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>", "Refactor function" },
			[{ "v", "f" }] = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", "Refactor funciton to file" },
			[{ "v", "v" }] = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>", "Refactor var" },
			[{ "v", "i" }] = { "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", "Refactor  var inline" },
			[{ "v", " " }] = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Refactor help" },
		},
	},

	-- hop = { -- mappings to hopleader
	-- 	leader = Keys.hopleader,
	-- 	name = "hop",
	-- 	opts = { noremap = true, silent = true },
	-- 	maps = {
	-- 		[{ "n", "w" }] = { ":HopWord<CR>", "Hop Word" },
	-- 		[{ "n", "l" }] = { ":HopLine<CR>", "Hop Lines" },
	-- 		[{ "n", "L" }] = { ":HopLineStart<CR>", "Hop Lines (start)" },
	-- 		[{ "n", "s" }] = { ":HopChar2<CR>", "Hop 2 char pattern" },
	-- 		[{ "n", "f" }] = { ":HopChar1<CR>", "Hop 1 car pattern" },
	-- 		[{ "n", "p" }] = { ":HopPattern<CR>", "Hop Pattern" },
	-- 		[{ "o", "t" }] = { ":<C-U>lua require('tsht').nodes()<CR>", "Hop ts node" },
	-- 		[{ "n", "t" }] = { ":lua require('tsht').nodes()<CR>", "Hop ts node" },
	-- 		[{ "n", "v" }] = { ":lua require('tsht').nodes()<CR>", "Hop ts node" },
	-- 	},
	-- },

	repl = { -- mappings to replleader
		leader = Keys.replleader,
		name = "repl",
		opts = { noremap = false, silent = true },
		maps = {
			[{ "n", "" }]= { "<Plug>Send", "Send to repl" },
			-- [{ "v", "" }] = { "<Plug>ReplSend_Visual", "Send to repl" },
			[{ "v", "" }] = { "<Plug>Send", "Send to repl" },
			-- [{ "n", "s" }] = { ":ReplSend<CR>", "Send to repl (line)" },
			[{ "n", "g" }] = { "<Plug>SendLine", "Send to repl (line)" },
			[{ "n", " " }] = { "<Plug>SendLine", "Send to repl (line)" },
		},
	},

	tab = { -- mappings to tab leader
		leader = Keys.tableader,
		name = "tabs",
		opts = { noremap = true, silent = false },
		maps = {
			[{ "", "n" }] = { ":tabnext<CR>", "next tab" },
			[{ "", "N" }] = { ":tabnew<CR>", "new tab" },
			[{ "", "o" }] = { ":tabonly<CR>", "close all tabs but current" },
			[{ "", " " }] = { ":tabnext<CR>", "next tab" },
			[{ "", "e" }] = { ":tabedit ", "edit new file in new tab" },
			[{ "", "m" }] = { ":tabmove ", "move tabs" },
			[{ "", "l" }] = { ":exe 'tabn '.g:lasttab<CR>", "previos tab" },
		},
	},

	norg = { -- mappings to norg leader
		leader = Keys.norgleader,
		name = "norg",
		opts = { noremap = true, silent = true },
		maps = {
			[{ "n", "gh" }] = { ":tabe ~/neorg/index.norg<CR>", "Open neorg home" },
			[{ "n", "gn" }] = { ":tabe ~/neorg/notes/index.norg<CR>", "Open neorg notes" },
			[{ "n", "gt" }] = { ":Neorg toc split<CR>", "Open TOC" },
			[{ "n", "gs" }] = { ":NeorgStart<CR>", "start neorg" },
			[{ "n", "gi" }] = { ":tabe ~/neorg/inbox.norg<CR>", "Open neorg inbox" },
			[{ "n", "gb" }] = { ":tabe ~/neorg/notes/beacon/inbox.norg<CR>", "Open beacon notes" },
		},
	},

	telescope = { -- mappings to telescope leader
		leader = Keys.telescopeleader,
		name = "telescope",
		opts = { noremap = true, silent = true },
		maps = {
			[{ "n", "f" }] = {
				"<cmd>lua require('fzf-lua').files()<cr>",
				"find files",
			},
			[{ "n", "g" }] = { "<cmd>lua require('fzf-lua').live_grep_native()<cr>", "Live grep" },
			[{ "n", "o" }] = { "Telescope oldfiles<cr>", "oldfiles" },
			[{ "n", "G" }] = { "<cmd>Telescope neorg find_project_tasks<cr>", "Find norg projects" },
			[{ "n", "t" }] = { "<cmd>TodoTelescope<cr>", "Todo" },
			[{ "n", "b" }] = {
				"<cmd>lua require('fzf-lua').buffers()<cr>",
				"find buffers",
			},
			[{ "n", "B" }] = {
				"<cmd>lua require('fzf-lua').blines()<cr>",
				"find buffers",
			},
			[{ "n", "H" }] = { "<cmd>lua require('fzf-lua').help_tags()<cr>", "get help" },
			[{ "n", "i" }] = { "<cmd>Octo issue list<cr>", "Search issues" },
			[{ "n", "p" }] = { "<cmd>Octo pr list<cr>", "Search PRs" },
			[{ "n", "m" }] = { "<cmd>lua require('fzf-lua').marks()<cr>", "find markers" },
			[{ "n", "c" }] = { "<cmd>Telescope cder<cr>", "change cwd" },
			[{ "n", "w" }] = { ":lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", "switch git worktrees" },
			[{ "n", "W" }] = { ":lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", "create git worktrees" },
			[{ "n", " " }] = { "<cmd>Telescope oldfiles<CR>", "find recents" },
			[{ "n", "/" }] = { "<cmd>lua require('telescope.builtin').search_history()<cr>", "find searches" },
			[{ "n", "R" }] = { "<cmd>lua require('telescope.builtin').reloader()<cr>", "reload configs" },
			[{ "n", "j" }] = { "<cmd>lua require('fzf-lua').jumps()<cr>", "find jumps" },
			[{ "n", "s" }] = { "<cmd>lua require('telescope.builtin').symbols()<cr>", "find symbols" },
			[{ "n", "e" }] = { "<cmd>lua require('telescope').extensions.emoji.emoji()<cr>", "find emoji" },
			[{ "n", "d" }] = { "lua require('fzf-lua').lsp_definitions()", "find lsp definitions" },
			[{ "n", "r" }] = { "<cmd>lua require('fzf-lua').lsp_references()<cr>", "find lsp references" },
			-- [{ "n", "h" }] = { "<cmd>Telescope harpoon marks<cr>", "marks" },
			[{ "n", "D" }] = {
				"<cmd>lua require('fzf-lua').lsp_typedefs()<cr>",
				"find lsp type definitions",
			},
			[{ "n", "t" }] = { "<cmd>lua require('telescope.builtin').treesitter()<cr>", "treesitter magic" },
		},
	},

	-- harpoon = { -- mappings to harpoonleader
	-- 	leader = Keys.harpoonleader,
	-- 	name = "harpoon",
	-- 	opts = { noremap = true, silent = true },
	-- 	maps = {
	-- 		[{ "n", "f" }] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "add file" },
	-- 		[{ "n", "a" }] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "add file" },
	-- 		[{ "n", "m" }] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "quick menu" },
	-- 		[{ "n", "n" }] = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "next" },
	-- 		[{ "n", " " }] = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "next" },
	-- 		[{ "n", "p" }] = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "previous" },
	-- 		[{ "n", "t" }] = { "<cmd>Telescope harpoon marks<cr>", "marks" },
	-- 		[{ "n", "c" }] = { "<cmd>cd %:p:h<cr>", "cd to current file" },
	-- 	},
	-- },
	qf = { -- mappings to harpoonleader
		leader = Keys.qfleader,
		name = "quickfix",
		opts = { noremap = true, silent = true },
		maps = {

			[{ "n", "t" }] = { "<cmd>TodoQuickFix<cr>", "Todos" },
			[{ "n", "d" }] = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "diagnostics" },
			[{ "n", "r" }] = { "<cmd>lua vim.lsp.buf.references()<CR>", "references" },
			[{ "n", "s" }] = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "symbols" },
			[{ "n", "S" }] = { "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "symbols (more)" },
		},
	},
	build = { -- mappings to harpoonleader
		leader = Keys.yabsleader,
		name = "build",
		opts = { noremap = true, silent = true },
		maps = {

			[{ "n", "t" }] = {  "<cmd>lua _TEST_TOGGLE()<CR>", "test" },
			[{ "n", "r" }] = { "<cmd>lua require'yabs':run_task('run')<CR>", "run" },
		},
	},
}

for _, v in pairs(map_table) do
	if v.leader == nil then
		apply_maps(v.maps, v.opts)
	else
		leader_map(v.leader, v.maps, v.opts)
		wk.register({ [v.leader("")] = { name = v.name } })
	end
end

