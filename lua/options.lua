vim.opt.foldlevel = 999
vim.opt.backup = false -- creates a backup file
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "longest", } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.hlsearch = true -- highlight all matches on previous search patterns
vim.opt.incsearch = true
vim.opt.magic = true
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 2 -- always show tabs
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.swapfile = true -- creates a swapfile
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true -- enable persistent undo
vim.opt.lazyredraw = true
vim.opt.updatetime = 250 -- faster completion (4000ms default)
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 2 spaces for a tab
vim.opt.cursorline = true -- highlight the current line
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.numberwidth = 4 -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false -- display lines as one long line
vim.opt.hidden = true
vim.opt.scrolloff = 8 -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
vim.opt.autoread = true
vim.opt.so = 7

vim.opt.shortmess:append("c")

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work

vim.opt.background = "dark"

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 25
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.zepl_default_maps = 0
vim.g.send_disable_mapping = true
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_spec = 1
vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
vim.g.qs_lazy_highlight = 1
vim.g.parinfer_filetypes = {"clojure", "scheme", "lisp", "racket", "hy", "fennel", "janet", "carp", "wast", "yuck", "julia"}
vim.g.parinfer_no_maps = false
-- TODO: Make this diff for julia than the ; languages
vim.g.parinfer_comment_chars = { }
-- vim.g.sexp_filetypes = "clojure,scheme,lisp,timl,julia"
vim.g.matchup_matchparen_enabled = 0
vim.g.JuliaFormatter_always_launch_server=1

