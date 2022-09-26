vim.api.nvim_create_autocmd({ "DirChanged"}, {
    pattern = "tabpage",
    callback = E.notifier("harpoon", true),
})
vim.api.nvim_create_autocmd({ "DirChanged"}, {
    pattern = "global",
    callback = E.notifier("harpoon", true),
})

vim.api.nvim_create_autocmd({ "BufWritePost"}, {
    pattern = "*",
    callback = E.notifier("harpoon", true),
})

vim.api.nvim_create_autocmd({ "TabEnter"}, {
    pattern = "*",
    callback = E.notifier("harpoon", true),
})

vim.api.nvim_create_augroup("bufcheck", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "bufcheck",
    pattern = { "gitcommit", "gitrebase", "NeogitCommitMessage" },
    command = "startinsert | 1",
})

vim.api.nvim_create_autocmd("TabLeave", {
    pattern = { "*" },
    command = "let g:lasttab = tabpagenr()",
})

-- local function make_conjure_command()
--     local root = require('lspconfig').util.root_pattern('Project.toml')(vim.api.nvim_buf_get_name(0))
--     if root == nil then
--         root = "."
--     end
--     vim.g["conjure#client#julia#stdio#command"] = "julia --banner=no --color=no --startup-file=yes --history-file=no --project=" .. root
-- end
--
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--     pattern = "*.jl",
--     callback = make_conjure_command,
-- })




vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    { pattern = { "*.txt", "*.md", "*.tex", "*.norg" }, command = "setlocal spell" }
)

vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    { pattern = { "*.txt", "*.md", "*.tex", "*.norg" }, command = "setlocal wrap" }
)
vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    { pattern = { "*.txt", "*.md", "*.tex", "*.norg" }, command = "setlocal linebreak" }
)

-- the lua way is stupid
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

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end
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
]]

-- TODO: some vim sensei stuff

-- https://hub.netzgemeinde.eu/channel/vim_sensei?mid=b64.aHR0cHM6Ly9odWIuaG90ZWxkYWFuLm5sL2l0ZW0vZGU2MjI1MDgtZjc1Ni00MGUzLWI1MTgtYjE1YTkwYTg2MWJiugroup

-- augroup VimSensei
--     autocmd!
--     " Log to analyze user behaviour
--     autocmd VimEnter * call ch_logfile($HOME . "/.vim/log-" . getpid())
--     autocmd InsertEnter * call ch_log("::Entering Insert Mode::")
--     autocmd InsertLeave * call ch_log("::Leaving Insert Mode::")
--     autocmd CmdwinEnter * call ch_log("::Entering command-line window::")
--     autocmd CmdwinLeave * call ch_log("::Leaving command-line window::")
--     autocmd CmdlineEnter * call ch_log("::Entering command-line mode::")
--     autocmd CmdlineLeave * call ch_log("::Leaving command-line mode::")
-- augroup END
