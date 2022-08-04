vim.api.nvim_create_augroup("bufcheck", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "bufcheck",
    pattern = { "gitcommit", "gitrebase" },
    command = "startinsert | 1",
})

-- local augroup = function(name, commands)
--     local id = vim.api.nvim_create_augroup(name, { clear = true })
--     for _, autocmd in ipairs(commands) do
--         local is_callback = type(autocmd.command) == "function"
--         vim.api.nvim_create_autocmd(autocmd.event, {
--             group = name,
--             pattern = autocmd.pattern,
--             desc = autocmd.description,
--             callback = is_callback and autocmd.command or nil,
--             command = not is_callback and autocmd.command or nil,
--             once = autocmd.once,
--             nested = autocmd.nested,
--             buffer = autocmd.buffer,
--         })
--     end
--     return id
-- end
--
-- function _G.make_conjure_command()
--     local root = require('lspconfig').util.root_pattern('Project.toml')(vim.api.nvim_buf_get_name(0))
--     if root == nil then
--         root = "."
--     end
--     return "julia --banner=no --color=no --project=" .. root
-- end
--
-- augroup("Julia_Conjure", {
--     event = "FileType",
--     pattern = "*",
--     command = function()
--         vim.g["conjure#client#julia#stdio#command"] = make_conjure_command()
--     end
--
-- })

local function make_conjure_command()
    local root = require('lspconfig').util.root_pattern('Project.toml')(vim.api.nvim_buf_get_name(0))
    if root == nil then
        root = "."
    end
    vim.g["conjure#client#julia#stdio#command"] = "julia --banner=no --color=no --project=" .. root
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = "*.jl",
    callback = make_conjure_command,
})


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
