local wk = require("which-key")

local function apply_maps(list, opts)
	for key, value in pairs(list) do
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
			[{ "v", "<" }] = { "<gv", "Move text left" },
			[{ "v", ">" }] = { ">gv", "Move text right" },
			[{ "v", "p" }] = { '"_dP', "" },
			[{ "x", "J" }] = { ":move '>+1<CR>gv-gv", "Move text up" },
			[{ "x", "K" }] = { ":move '<-2<CR>gv-gv", "Move text down" },
		},
	},

	leader = { -- general mappings such as leader-w, leader then single key
		leader = Keys.leader,
		name = "leader",
		opts = { noremap = true, silent = true },
		maps = {
			[{ "n", "e" }] = { ":Lex 30<cr>", "File Explorer" },
			[{ "n", "D" }] = { ":Dirbuf<cr>", "Dirbuf" },
			[{ "n", "w" }] = { ":w!<cr>", "save" },
			-- [{ "n", "cd" }] = ":cd %:p:h<CR>:pwd<CR>",
		},
	},

	ctrl = { -- mappings to <C-
		leader = Keys.C,
		name = "CTRL",
		opts = { noremap = true, silent = true, nowait = true },
		maps = {
			[{ "", "b" }] = { ":call InsertLine()<CR>", "pdb" },
			[{ "n", "h" }] = { "<C-w>h", "Window left" },
			[{ "n", "j" }] = { "<C-w>j", "Window down" },
			[{ "n", "k" }] = { "<C-w>k", "Window up" },
			[{ "n", "l" }] = { "<C-w>l", "Window right" },
			[{ "n", "Up" }] = { ":resize +2<CR>", "Increase window size horizontal" },
			[{ "n", "Left" }] = { ":vertical resize -2<CR>", "Decrease window size vertical" },
			[{ "n", "Right" }] = { ":vertical resize +2<CR>", "Increase window size vertical" },
			[{ "n", "Down" }] = { ":resize -2<CR>", "Decrease window size horizontal" },
			[{ "t", "h" }] = { "<C-\\><C-N><C-w>h", "Terminal window left" },
			[{ "t", "j" }] = { "<C-\\><C-N><C-w>j", "Terminal window down" },
			[{ "t", "k" }] = { "<C-\\><C-N><C-w>k", "Terminal window up" },
			[{ "t", "l" }] = { "<C-\\><C-N><C-w>l", "Terminal window right" },
			[{ "n", "p" }] = { ":BufferPick<CR>", "Pick buffer" },
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
			[{ "n", "Up" }] = { ":bnext<CR>", "Next buffer" },
			[{ "n", "Down" }] = { ":bprevious<CR>", "Previous buffer" },
			[{ "n", "," }] = { ":BufferPrevious<CR>", "Previous buffer" },
			[{ "n", "." }] = { ":BufferNext<CR>", "Next buffer" },
			[{ "n", "<" }] = { ":BufferMovePrevious<CR>", "Move buffer previous" },
			[{ "n", ">" }] = { ":BufferMoveNext<CR>", "Move buffer next" },
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
			[{ "", "x" }] = { ":BufferClose<CR>", "close buffer" },
			[{ "", "s" }] = { ":b ", "select buffer" },
			[{ "", "1" }] = { ":bfirst<CR>", "first buffer" },
			[{ "", "0" }] = { ":blast<CR>", "last buffer" },
		},
	},

	docs = { -- mappings to docsleader
		leader = Keys.docsleader,
		name = "neogen",
		opts = { noremap = true, silent = true },
		maps = {
			[{ "n", "c" }] = { ":lua require('neogen').generate({type = 'class'})<CR>", "Document class" },
			[{ "n", "f" }] = { ":lua require('neogen').generate()<CR>", "Document function" },
			[{ "n", " " }] = { ":lua require('neogen').generate()<CR>", "Document function" },
		},
	},

	hop = { -- mappings to hopleader
		leader = Keys.hopleader,
		name = "hop",
		opts = { noremap = true, silent = true },
		maps = {
			[{ "n", "w" }] = { ":HopWord<CR>", "Hop Word" },
			[{ "n", "l" }] = { ":HopLine<CR>", "Hop Lines" },
			[{ "n", "L" }] = { ":HopLineStart<CR>", "Hop Lines (start)" },
			[{ "n", "s" }] = { ":HopChar2<CR>", "Hop 2 char pattern" },
			[{ "n", "f" }] = { ":HopChar1<CR>", "Hop 1 car pattern" },
			[{ "n", "p" }] = { ":HopPattern<CR>", "Hop Pattern" },
			[{ "o", "t" }] = { ":<C-U>lua require('tsht').nodes()<CR>", "Hop ts node" },
			[{ "n", "t" }] = { ":lua require('tsht').nodes()<CR>", "Hop ts node" },
			[{ "n", "v" }] = { ":lua require('tsht').nodes()<CR>", "Hop ts node" },
		},
	},

	zepl = { -- mappings to zeplleader
		leader = Keys.zeplleader,
		name = "zepl",
		opts = { noremap = false, silent = true },
		maps = {
			[{ "n", "" }] = { "<Plug>ReplSend_Motion", "Send to repl" },
			[{ "v", "" }] = { "<Plug>ReplSend_Visual", "Send to repl" },
			[{ "n", "s" }] = { ":ReplSend<CR>", "Send to repl (line)" },
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
		},
	},

	telescope = { -- mappings to telescope leader
		leader = Keys.telescopeleader,
		name = "telescope",
		opts = { noremap = true, silent = true },
		maps = {
			[{ "n", "f" }] = {
				"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
				"find files",
			},
			[{ "n", "g" }] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Live grep" },
			[{ "n", "b" }] = {
				"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
				"find buffers",
			},
			[{ "n", "h" }] = { "<cmd>lua require('telescope.builtins').help_tags()<cr>", "get help" },
			[{ "n", "m" }] = { "<cmd>lua require('telescope.builtins').marks()<cr>", "find markers" },
			[{ "n", "p" }] = { "<cmd>lua require('telescope').extensions.project.project()<cr>", "find projects" },
			[{ "n", " " }] = { "<cmd>lua require('telescope').extensions.frecency.frecency()<CR>", "find recents" },
			[{ "n", "/" }] = { "<cmd>lua require('telescope.builtins').search_history()<cr>", "find searches" },
			[{ "n", "R" }] = { "<cmd>lua require('telescope.builtins').reloader()<cr>", "reload configs" },
			[{ "n", "j" }] = { "<cmd>lua require('telescope.builtins').jumplist()<cr>", "find jumps" },
			[{ "n", "e" }] = { "<cmd>lua require('telescope').extensions.emoji.emoji()<cr>", "find emoji" },
			[{ "n", "d" }] = { "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", "find lsp definitions" },
			[{ "n", "r" }] = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "find lsp references" },
			[{ "n", "D" }] = {
				"<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>",
				"find lsp type definitions",
			},
			[{ "n", "t" }] = { "<cmd>lua require('telescope.builtin').treesitter()<cr>", "treesitter magic" },
		},
	},

	harpoon = { -- mappings to harpoonleader
		leader = Keys.harpoonleader,
		name = "harpoon",
		opts = { noremap = true, silent = true },
		maps = {
			[{ "n", "f" }] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "add file" },
			[{ "n", "a" }] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "add file" },
			[{ "n", "m" }] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "quick menu" },
			[{ "n", "n" }] = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "next" },
			[{ "n", " " }] = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "next" },
			[{ "n", "p" }] = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "previous" },
			[{ "n", "t" }] = { "<cmd>Telescope harpoon marks<cr>", "previous" },
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
