require('impatient').enable_profile()
require "plugins"
require "globals"
require "keybinds"
require "options"
require "lsp".setup()
require "ts"
require "snippets"
require "completion"
require "term"
require "bars"
require "search"
require "norg"
require "neogen".setup()
require "Comment".setup()
require "gh"
require('leap').set_default_keymaps()


vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
vim.cmd("colorscheme forestbones")


vim.o.qftf = '{info -> v:lua._G.qftf(info)}'

function _G.Toggle_venn()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if venn_enabled == "nil" then
    vim.b.venn_enabled = true
    vim.cmd[[setlocal ve=all]]
    -- draw a line on HJKL keystokes
    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
    -- draw a box by pressing "f" with visual selection
    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
  else
    vim.cmd[[setlocal ve=]]
    vim.cmd[[mapclear <buffer>]]
    vim.b.venn_enabled = nil
  end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})
vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd InsertLeave,WinEnter * set cursorline
    autocmd InsertEnter,WinLeave * set nocursorline
    autocmd FileType qf set nobuflisted
  augroup end
  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end
  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal linebreak
    autocmd FileType markdown setlocal spell
    autocmd FileType norg setlocal wrap
    autocmd FileType norg setlocal linebreak
    " autocmd FileType norg setlocal spell
  augroup end
  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end
  " augroup ProjectDrawer
  "     autocmd!
  "     autocmd VimEnter * if argc() == 0 | Explore! | endif
  " augroup END
  " autocmd BufEnter * if expand("%:p:h") !~ '*.norg' | silent! lcd %:p:h | endif
  let g:hiPairs_enable_matchParen = 0
  let g:hiPairs_timeout = 1
  let g:hiPairs_insert_timeout = 1
  let g:hiPairs_hl_matchPair = { 'term'    : 'underline,bold',
              \                  'cterm'   : 'underline,bold',
              \                  'ctermfg' : '0',
              \                  'ctermbg' : '180',
              \                  'gui'     : 'underline,bold,italic',
              \                  'guifg'   : '#fb94ff',
              \                  'guibg'   : 'NONE' }
autocmd FileType haskell setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType r setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType julia setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType rmd setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType lua setlocal expandtab shiftwidth=2 softtabstop=2
" Run currently focused python script with F9
" autocmd FileType python nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
" autocmd FileType markdown nnoremap <buffer> <F9> :exec '!md2pdf' shellescape(@%, 1)<cr>
" format code with f8
autocmd FileType yaml nnoremap <buffer> <F8> :exec '!cfn-lint' shellescape(@%, 1)<cr>
autocmd FileType python nnoremap <buffer> <F8> :exec '!yapf -i' shellescape(@%, 1)<cr>
autocmd FileType rust nnoremap <buffer> <F8> :exec '!cargo fmt'<cr>
autocmd FileType sh nnoremap <buffer> <F8> :exec '!shfmt -w' shellescape(@%, 1)<cr>
autocmd FileType nix nnoremap <buffer> <F8> :exec '!nixfmt' shellescape(@%, 1)<cr>
autocmd FileType lua nnoremap <buffer> <F8> :exec '!stylua' shellescape(@%, 1)<cr>
filetype plugin on
filetype indent on
syntax enable
fun! CleanExtraSpaces()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	silent! %s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfun
if has("autocmd")
	autocmd BufWritePre *.txt,*.jl,*.js,*.py,*.wiki,*.sh,*.coffee,*.lua :call CleanExtraSpaces()
endif
runtime zepl/contrib/python.vim  " Enable the Python contrib module.
runtime zepl/contrib/nvim_autoscroll_hack.vim
let g:repl_config = {
            \   'python': {
            \     'cmd': 'python',
            \     'formatter': function('zepl#contrib#python#formatter')
            \   },
            \   'lua': { 'cmd': 'lua' },
            \ }
" tnoremap <Esc> <C-\><C-n>
runtime zepl/contrib/nvim_autoscroll_hack.vim
]]
