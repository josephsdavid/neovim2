local km = require("core.keymap")
local op = require("core.options")

M = {}

op.setglobal("mapleader", " ")
op.setglobal("maplocalleader", ",")

op.setglobal("lasttab", 1)
vim.cmd([[au TabLeave * let g:lasttab = tabpagenr()]])

local function leader_suffix(k)
    return km.genleader(km.leader(k))
end

local scope = leader_suffix("f")
local bufl = leader_suffix("b")
local repl = leader_suffix("g")
local tabl = leader_suffix("t")
local ctrl = km.Ctrl

local binds = {
    general = {
        normal = {
            [{ " " }] = { "<Nop>", "" },
            [{ "0" }] = { "^", "start of line" },
            [{ "_" }] = { ctrl("^"), "last buffer" },
            [{ "cl" }] = { "s", "delete and insert" },
            [{ km.leader("F") }] = { ":Lex 30<CR>", "Netrw" },
            [{ km.leader("w") }] = { ":w!<CR>", "save" },
            [{ km.leader("cd") }] = { "<cmd>tcd %:p:h<cr><cmd>pwd<cr>", "cd to current file" },
            [{ km.Alt("Up") }] = { ":resize +2<CR>", "Increase window size horizontal" },
            [{ km.Alt("Left") }] = { ":vertical resize -2<CR>", "Decrease window size vertical" },
            [{ km.Alt("Right") }] = { ":vertical resize +2<CR>", "Increase window size vertical" },
            [{ km.Alt("Down") }] = { ":resize -2<CR>", "Decrease window size horizontal" },
            [{ km.Alt(",") }] = { ":bprevious<CR>", "Previous buffer" },
            [{ km.Alt(".") }] = { ":bnext<CR>", "next buffer" },
        },
        terminal = {
            [{ "<Esc>" }] = { "<C-\\><C-n>", "Terminal escape" },
        },
        visual = {
            [{ "<" }] = { "<gv", "Move text left" },
            [{ ">" }] = { ">gv", "Move text right" },
            [{ "p" }] = { '"_dP', "paste in place" },
            [{ "J" }] = { ":move '>+1<CR>gv-gv", "Move text up" },
            [{ "K" }] = { ":move '>-2<CR>gv-gv", "Move text down" },
        },
        xmode = {
            [{ "J" }] = { ":move '>+1<CR>gv-gv", "Move text up" },
            [{ "K" }] = { ":move '>-2<CR>gv-gv", "Move text down" },
        }

    },
    telescope = {
        normal = {
            [scope("f")] = { "<cmd>Telescope find_files<cr>", "find files" },
            [scope("g")] = { "<cmd>Telescope live_grep<cr>", "live grep" },
            [scope("o")] = { "<cmd>Telescope oldfiles<cr>", "find oldfiles" },
            [scope("b")] = { "<cmd>Telescope buffers<cr>", "find buffers" },
            [scope("t")] = { "<cmd>Telescope tabs<cr>", "find tabs" },
            ["z="] = { "<cmd>Telescope spell_suggest<cr>", "spell suggest" },
            [scope("T")] = { "<cmd>TodoTelescope<cr>", "find tabs" },
            [scope("i")] = { "<cmd>Octo issue list<cr>", "Search issues" },
            [scope("p")] = { "<cmd>Octo pr list<cr>", "Search prs" },
            [scope("m")] = { "<cmd>Telescope marks<cr>", "find marks" },
            [scope("j")] = { "<cmd>Telescope jumplist<cr>", "find jumps" },
            [scope("e")] = { "<cmd>Telescope symbols<cr>", "find symbols" },
            [scope("r")] = { "<cmd>Telescope reloader<cr>", "reload" },
            [scope("d")] = { "<cmd>Telescope lsp_definitions<cr>", "find lsp definitions" },
            [scope("D")] = { "<cmd>Telescope lsp_type_definitions<cr>", "find lsp type definitions" },
            [scope("r")] = { "<cmd>Telescope lsp_references<cr>", "find lsp references" },
            [ctrl("p")] = { "<cmd>Telescope oldfiles<cr>", "find oldfiles" }
        },
    }
}

for k, value in pairs({ left = "h", down = "j", up = "k", right = "l" }) do
    binds.general.normal[ctrl(value)]     = { ctrl("w") .. value, "Window" .. k }
    binds.general.terminal[ctrl(value)]   = { "<C-\\><C-N><C-w>" .. value, "Window" .. k }
    binds.general.terminal[km.Alt(value)] = { "<C-\\><C-N><C-w>" .. value, "Window" .. k }
end

binds.buffer = {
    normal = {
        [{ bufl("n") }] = { ":bnext<CR>", "next buffer" },
        [{ bufl("p") }] = { ":bprevious<CR>", "previous buffer" },
        [{ bufl("l") }] = { ":bprevious<CR>", "previous buffer" },
        [{ bufl(" ") }] = { ":bnext<CR>", "next buffer" },
        [{ bufl("b") }] = { ":bnext<CR>", "next buffer" },
        [{ bufl("x") }] = { ":lua MiniBufremove.wipeout()<CR>", "close buffer" },
        [{ bufl("s") }] = { ":Telescope buffers<CR>", "select buffer" },
        [{ bufl("1") }] = { ":bfirst<CR>", "first buffer" },
        [{ bufl("0") }] = { ":blast<CR>", "last buffer" },
    }
}


binds.tab = {
    normal = {
        [{ tabl("n") }] = { ":tabnext<CR>", "next tab" },
        [{ tabl("N") }] = { ":tabnew<CR>", "new tab" },
        [{ tabl("o") }] = { ":tabonly<CR>", "close all tabs but current" },
        [{ tabl(" ") }] = { ":tabnext<CR>", "next tab" },
        [{ tabl("e") }] = { ":tabedit ", "edit new file in new tab" },
        [{ tabl("m") }] = { ":tabmove ", "move tabs" },
        [{ tabl("l") }] = { ":exe 'tabn '.g:lasttab<CR>", "previos tab" },
    }
}

binds.repl = {}
binds.repl.normal = {
    [{ repl("g") }] = { km.plugmapping("SendLine"), "Send to repl (line)" },
    [{ repl(" ") }] = { km.plugmapping("SendLine"), "Send to repl (line)" },
    [{ repl("") }] = { km.plugmapping("Send"), "Send to repl" },
}
binds.repl.visual = {
      [{ repl("") }] = {km.plugmapping( "Send"), "Send to repl" },
}

km.process_binds(binds)
