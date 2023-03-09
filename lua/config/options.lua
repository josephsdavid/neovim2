local options = {
    opt = {
        background = "light",
        laststatus = 3,
        foldlevel = 999,
        backup = false,
        clipboard = "unnamedplus",
        cmdheight = 1,
        completeopt = { "menu", "noselect", "menuone", "longest", },
        conceallevel = 3,
        fileencoding = "utf8",
        hlsearch = true,
        incsearch = true,
        magic = true,
        ignorecase = true,
        mouse = "a",
        pumheight = 10,
        showmode = false,
        showtabline = 2,
        smartcase = true,
        smartindent = true,
        splitbelow = true,
        splitright = true,
        swapfile = true,
        termguicolors = true,
        timeoutlen = 1000,
        undofile = true,
        expandtab = true,
        shiftwidth = 4,
        tabstop = 4,
        cursorline = true,
        number = true,
        relativenumber = true,
        numberwidth = 4,
        signcolumn = "yes",
        wrap = false,
        hidden = true,
        scrolloff = 12,
        sidescrolloff = 8,
        guifont = "monospace:h17",
        autoread = true,
    },
    g = {
        netrw_banner = 0,
        netrw_liststyle = 3,
        netrw_browse_split = 25,
        netrw_altv = 1,
        netrw_winsize = 25,
        mapleader = " ",
        maplocalleader = ",",
        lasttab = 1,
        qs_highlight_on_keys = { 'f', 'F', 't', 'T' },
        qs_lazy_highlight = 1,
        send_disable_mapping = 1,
        asterisk = 1,
        parinfer_filetypes = {
            "clojure", "scheme", "lisp", "racket",
            "hy", "fennel", "janet", "carp",
            "wast", "yuck", "query"
        },
        parinfer_no_maps = true,
    }
}
return {
    setup = function()
        vim.cmd([[set whichwrap+=<,>,[,],h,l]])
        vim.cmd([[set iskeyword+=-]])
        vim.cmd([[set formatoptions-=cro]])
        vim.cmd([[set lazyredraw]])
        -- vim.cmd [[hi function gui=bold]]
        vim.cmd [[hi macro gui=bold]]
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
        vim.cmd [[hi clear DiffText]]
        vim.api.nvim_set_hl(0, 'DiffText', { link = 'DiffChange' })
        vim.opt.shortmess:append("c")
        for k, v in pairs(options) do
            for kk, vv in pairs(v) do
                vim[k][kk] = vv
            end
        end
    end
}
