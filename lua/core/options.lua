M = {}

function M.setkey(k)
    local function out(kk, v)
        vim[k][kk] = v
    end
end

M.setopt = setkey("opt")
M.setglobal = setkey("g")
M.setbuffer = setkey("b")

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work


M.setopt("background", "dark")
M.setopt("foldlevel", 999)
M.setopt("backup", false) -- creates a backup file)
M.setopt("clipboard", "unnamedplus") -- allows neovim to access the system clipboard)
M.setopt("cmdheight", 2)
M.setopt("completeopt", { "menuone", "longest", })
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
return M
