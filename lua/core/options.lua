M = {}

function M.setkey(k)
    local function out(kk, v)
        vim[k][kk] = v
    end

    return out
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work
vim.cmd([[filetype plugin on]]) -- TODO: this doesn't seem to work

M.setopt = M.setkey("opt")
M.setglobal = M.setkey("g")
M.setbuffer = M.setkey("b")

M.setters = { opt = M.setopt, global = M.setglobal, buffer = M.setbuffer }

local ctime = os.date("*t")
if ctime.hour < 21 and ctime.hour >= 8 then
    M.setopt("background", "light")
    vim.cmd [[colorscheme doom-one]]
    vim.cmd [[hi macro gui=bold]]
else
    M.setopt("background", "dark")

    -- vim.cmd[[hi function gui=bold]]
    vim.cmd [[colorscheme doom-one]]
    vim.cmd [[hi macro gui=bold]]



end
M.setopt("laststatus", 3)
M.setopt("foldlevel", 999)
M.setopt("backup", false) -- creates a backup file)
M.setopt("clipboard", "unnamedplus") -- allows neovim to access the system clipboard)
M.setopt("cmdheight", 2)
M.setopt("completeopt", { "menu", "noselect", "menuone", "longest", })
M.setopt("conceallevel", 0)
M.setopt("fileencoding", "utf8")
M.setopt("hlsearch", true)
M.setopt("incsearch", true)
M.setopt("magic", true)
M.setopt("ignorecase", true)
M.setopt("mouse", "a")
M.setopt("pumheight", 10)
M.setopt("showmode", false)
M.setopt("showtabline", 2)
M.setopt("smartcase", true)
M.setopt("smartindent", true)
M.setopt("splitbelow", true)
M.setopt("splitright", true)
M.setopt("swapfile", true)
M.setopt("termguicolors", true)
M.setopt("timeoutlen", 1000)
M.setopt("undofile", true)
M.setopt("lazyredraw", true)
M.setopt("updatetime", 250)
M.setopt("writebackup", false)
M.setopt("expandtab", true)
M.setopt("shiftwidth", 4)
M.setopt("tabstop", 4)
M.setopt("cursorline", true)
M.setopt("number", true)
M.setopt("relativenumber", true)
M.setopt("numberwidth", 4)
M.setopt("signcolumn", "yes")
M.setopt("wrap", false)
M.setopt("hidden", true)
M.setopt("scrolloff", 8)
M.setopt("sidescrolloff", 8)
M.setopt("guifont", "monospace:h17")
M.setopt("autoread", true)
M.setopt("so", 7)
vim.opt.shortmess:append("c")


M.setglobal("netrw_banner", 0)
M.setglobal("netrw_liststyle", 3)
M.setglobal("netrw_browse_split", 25)
M.setglobal("netrw_altv", 1)
M.setglobal("netrw_winsize", 25)
M.setglobal("loaded_gzip", 1)
M.setglobal("loaded_tar", 1)
M.setglobal("loaded_tarPlugin", 1)
M.setglobal("loaded_zipPlugin", 1)
M.setglobal("loaded_2html_plugin", 1)
M.setglobal("mapleader", " ")
M.setglobal("maplocalleader", ",")
M.setglobal("lasttab", 1)
M.setglobal("loaded_matchit", 1)
M.setglobal("loaded_spec", 1)
M.setglobal("qs_highlight_on_keys", { 'f', 'F', 't', 'T' })
M.setglobal("matchup_matchparen_enabled", 0)
M.setglobal("qs_lazy_highlight", 1)
M.setglobal("hiPairs_enable_matchParen", 0)
M.setglobal("hiPairs_timeout", 1)
M.setglobal("hiPairs_insert_timeout", 1)
M.setglobal("hiPairs_hl_matchPair",
    { term = 'underline,bold', cterm = 'underline,bold', ctermfg = '0', ctermbg = '180',
        gui = 'underline,bold,italic', guifg = '#fb94ff', guibg = 'NONE' })
M.setglobal("send_disable_mapping", 1)

M.setglobal("conjure#mapping#doc_word", "<LocalLeader>K")
M.setglobal("JuliaFormatter_always_launch_server", 1)
-- M.setglobaldelete_replaced_bufferdelete_replaced_buffer("unception_open_buffer_in_new_tab", true)
M.setglobal("asterisk#keeppos", 1)
M.setglobal("parinfer_filetypes", {
    "clojure", "scheme", "lisp", "racket",
    "hy", "fennel", "janet", "carp",
    "wast", "yuck", "jl", "julia"
})


return M
