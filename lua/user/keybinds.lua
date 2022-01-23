local opts = { noremap = true, silent = true }
local tab_opts = { noremap = true, silent = false }
local buf_opts = { noremap = true, silent = true}

local zepl_opts = { noremap = false, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

local mappings = require('user.utils').mappings

--Remap comma as leader key
keymap("", "< >", "<Nop>", opts)
-- keymap("", "<Space>", "/", opts)
-- keymap("", "<C-Space>", "?", opts)
-- keyamp("", "/", ",", opts)
keymap("", "0", "^", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<M-h>", "<C-w>h", opts)
keymap("n", "<M-j>", "<C-w>j", opts)
keymap("n", "<M-k>", "<C-w>k", opts)
keymap("n", "<M-l>", "<C-w>l", opts)

keymap("n", "<leader>e", ":Lex 30<cr>", opts)
-- keymap("n", "<leader>kk" ,"<cmd>WhichKey<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<M-Up>", ":bnext<CR>", opts)
keymap("n", "<M-Down>", ":bprevious<CR>", opts)
keymap("n", "_", "<C-^>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
keymap("t", "<M-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<M-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<M-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<M-l>", "<C-\\><C-N><C-w>l", term_opts)
keymap("t", "<Esc>", "<C-\\><C-n>", term_opts)
keymap("n", mappings.docsleader("c"), ":lua require('neogen').generate({ type = 'class' })<CR>", opts)
keymap("n", mappings.docsleader("f"), ":lua require('neogen').generate()<CR>", opts)

-- lightspeed --
--
---- place this in one of your configuration file(s)
--[[ keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {}) ]]
keymap("n", mappings.hopleader("w"), ":HopWord<CR>", opts)
keymap("n", mappings.hopleader("l"), ":HopLine<CR>", opts)
keymap("n", mappings.hopleader("L"), ":HopLineStart<CR>", opts)
keymap("n", mappings.hopleader("s"), ":HopChar2<CR>", opts)
keymap("n", mappings.hopleader("c"), ":HopChar1<CR>", opts)
keymap("n", mappings.hopleader("p"), ":HopPattern<CR>", opts)
keymap("o", mappings.hopleader("t"), ":<C-U>lua require('tsht').nodes()<CR>", opts)
keymap("n", mappings.hopleader("t"), ":lua require('tsht').nodes()<CR>", opts)
keymap("v", mappings.hopleader("t"), ":lua require('tsht').nodes()<CR>", opts)

-- zepl stuff
keymap("n", mappings.zeplleader(""), "<Plug>ReplSend_Motion", zepl_opts)
keymap("v", mappings.zeplleader(""), "<Plug>ReplSend_Visual", zepl_opts)
keymap("n", mappings.zeplleader("s"), ":ReplSend <CR>", zepl_opts)

-- cd to current directory
keymap("n", mappings.leader("cd"), ":cd %:p:h<CR>:pwd<CR>", opts)

-- save with leader
keymap("n", mappings.leader("w"), ":w!<CR>", opts)

-- tab magic
keymap("", mappings.tableader("n"), ":tabnext<CR>", opts)
keymap("", mappings.tableader("N"), ":tabnew<CR>", opts)
keymap("", mappings.tableader("o"), ":tabonly<CR>", opts)
keymap("", mappings.tableader("c"), ":tabclose<CR>", opts)
keymap("", mappings.tableader("m"), ":tabmove ",tab_opts)
keymap("", mappings.tableader("e"), ":tabedit ", tab_opts)
keymap("", mappings.tableader(mappings.leader("")), ":tabnext<CR>", opts)
vim.g.lasttab = 1
keymap("", mappings.tableader("l"), ":exe 'tabn '.g:lasttab<CR>", opts)
vim.cmd[[au TabLeave * let g:lasttab = tabpagenr()]]

-- buffer magic
-- nnoremap <silent>[b :BufferLineCycleNext<CR>
-- nnoremap <silent>b] :BufferLineCyclePrev<CR>


vim.cmd[[
function! InsertLine()
  let trace = expand("__import__('pdb').set_trace()")
  execute "normal O".trace
endfunction
]]
keymap("", mappings.C("b"), ":call InsertLine()<CR>", opts)

-- keymap("n", mappings.troubleleader("x"), "<cmd>TroubleToggle<cr>", opts)
-- keymap("n", mappings.troubleleader("w"), "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
-- keymap("n", mappings.troubleleader("d"), "<cmd>TroubleToggle document_diagnostics<cr>", opts)
-- keymap("n", mappings.troubleleader("q"), "<cmd>TroubleToggle quickfix<cr>", opts)
-- keymap("n", mappings.troubleleader("l"), "<cmd>TroubleToggle loclist<cr>", opts)
-- keymap("n", mappings.troubleleader("r"), "<cmd>TroubleToggle lsp_references<cr>", opts)


-- dirbuf
keymap("n", mappings.leader("D"), ":Dirbuf<CR>", { noremap = true, silent = true, nowait=true })



