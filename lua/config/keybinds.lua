local km = require("core.keymap")
local km2 = require("core.km2")
-- local op = require("core.options")
-- local wk = require("which-key")

M = {}



local leader = km2.leader
local Alt = km2.alt
local Ctrl = km2.ctrl


local scope = km2.extendleader(leader, "f")
local bufl = km2.extendleader(leader, "b")
local repl = km2.extendleader(leader, "g")
local tabl = km2.extendleader(leader, "t")
local g = km2.genleader("g")
-- local bufl = leader_suffix("b")
-- local repl = leader_suffix("g")
-- local tabl = leader_suffix("t")






local tcd = function()
    local root = require('lspconfig').util.root_pattern('Project.toml', '.git')(vim.api.nvim_buf_get_name(0))
    if root == nil then
        root = " %:p:h"
    end
    vim.cmd("tcd " .. root)
    vim.cmd("pwd")
end

M.config = {
    general = {
        normal = {
            -- [" "] = { "<Nop>", "" },
            ["H"] = { ":DocsViewToggle<CR>", "docs view" },
            ["0"] = { "^", "start of line" },
            ["_"] = { Ctrl("^"), "last buffer" },
            ["cl"] = { "s", "delete and insert" },
            [leader("F")] = { ":Lex 30<CR>", "Netrw" },
            [leader("w")] = { ":w!<CR>", "save" },
            [leader("cc")] = { "<cmd>tcd %:p:h<cr><cmd>pwd<cr>", "cd to current file" },
            [leader("cd")] = { tcd, "cd to current project or file" },
            [Alt("Up")] = { ":resize +2<CR>", "Increase window size horizontal" },
            [Alt("Left")] = { ":vertical resize -2<CR>", "Decrease window size vertical" },
            [Alt("Right")] = { ":vertical resize +2<CR>", "Increase window size vertical" },
            [Alt("Down")] = { ":resize -2<CR>", "Decrease window size horizontal" },
            [Ctrl(".")] = { ":bp<CR>", "Previous buffer" },
            [Ctrl(",")] = { ":bn<CR>", "next buffer" },
            [g("G")] = {":Neogit<CR>", "Git"},
            [Ctrl("h")] = { ":lua require('harpoon.mark').add_file()<CR>", "harpoon mark" },
            [leader("hm")] = { ":lua require('harpoon.mark').add_file()<CR>", "harpoon mark" },
            [leader("h ")] = { ":lua require('harpoon.ui').nav_next()<CR>", "harpoon mark next" },
            [leader("hn")] = { ":lua require('harpoon.ui').nav_next()<CR>", "harpoon mark next" },
            [leader("hp")] = { ":lua require('harpoon.ui').nav_prev()<CR>", "harpoon mark prev" },
            [leader("hl")] = { ":lua require('harpoon.ui').nav_prev()<CR>", "harpoon mark prev" },
        },
        terminal = {
            ["<Esc>"] = { "<C-\\><C-n>", "Terminal escape" },
        },
        visual = {
            ["<"] = { "<gv", "Move text left" },
            [">"] = { ">gv", "Move text right" },
            ["p"] = { '"_dP', "paste in place" },
            ["K"] = { ":move '>-2<CR>gv-gv", "Move text down" },
            ["J"] = { ":move '>+1<CR>gv-gv", "Move text up" },
        },
        xmode = {
            ["K"] = { ":move '>-2<CR>gv-gv", "Move text down" },
            ["J"] = { ":move '>+1<CR>gv-gv", "Move text up" },
        },
        -- omni = {
        -- },
        insert = {
            [Ctrl("j")] = { "<Plug>(TaboutMulti)", "" },
            [Ctrl("k")] = { "<Plug>(TaboutBackMulti)", "" }
        }


    },
    telescope = {
        normal = {
            [scope(" ")] = { "<cmd>Telescope current_buffer_fuzzy_find theme=ivy<cr>", "swiper" },
            [scope("F")] = { "<cmd>FzfLua files<cr>", "find files" },
            [scope("n")] = { "<cmd>Telescope ghn<cr>", "find notifications" },
            [scope("h")] = { "<cmd>Telescope harpoon marks<cr>", "harpoon" },
            [scope("f")] = { "<cmd>Telescope find_files theme=ivy<cr>", "find files" },
            [scope("r")] = { "<cmd>FzfLua resume<cr>", "resume" },
            [scope("R")] = { "<cmd>Telescope resume<cr>", "resume" },
            [scope("G")] = { "<cmd>FzfLua live_grep_native<cr>", "live grep" },
            [scope("g")] = { "<cmd>Telescope live_grep theme=ivy<cr>", "live grep" },
            [scope("o")] = { "<cmd>Telescope oldfiles theme=ivy<cr>", "find oldfiles" },
            [scope("b")] = { "<cmd>BufferLinePick<cr>", "find buffers" },
            [scope("B")] = { "<cmd>Telescope buffers theme=ivy<cr>", "find buffers" },
            [scope("t")] = { "<cmd>TodoTelescope theme=ivy<cr>", "find todos" },
            ["z="] = { "<cmd>Telescope spell_suggest theme=ivy<cr>", "spell suggest" },
            -- [scope("T")] = { "<cmd>TodoTelescope<cr>", "find tabs" },
            [scope("i")] = { "<cmd>Octo issue list<cr>", "Search issues" },
            [scope("p")] = { "<cmd>Octo pr list<cr>", "Search prs" },
            [scope("m")] = { "<cmd>Telescope marks theme=ivy<cr>", "find marks" },
            [scope("j")] = { "<cmd>Telescope jumplist theme=ivy<cr>", "find jumps" },
            [scope("e")] = { "<cmd>Telescope symbols theme=ivy<cr>", "find symbols" },
            [scope("r")] = { "<cmd>Telescope reloader theme=ivy<cr>", "reload" },
            [scope("d")] = { "<cmd>Telescope lsp_definitions theme=ivy<cr>", "find lsp definitions" },
            [scope("D")] = { "<cmd>Telescope lsp_type_definitions theme=ivy<cr>", "find lsp type definitions" },
            -- [scope("r")] = { "<cmd>Telescope lsp_references theme=ivy<cr>", "find lsp references" },
            [Ctrl("p")] = { "<cmd>Telescope oldfiles theme=ivy<cr>", "find oldfiles" },
            -- [scope(" ")] = { "<cmd>Telescope frecency<cr>", "find frecency" }
        },
    }
}

for k, value in pairs({ left = "h", down = "j", up = "k", right = "l" }) do
    M.config.general.normal[Ctrl(value)]   = { Ctrl("w") .. value, "Window" .. k }
    M.config.general.terminal[Ctrl(value)] = { "<C-\\><C-N><C-w>" .. value, "Window" .. k }
    M.config.general.terminal[Alt(value)]  = { "<C-\\><C-N><C-w>" .. value, "Window" .. k }
end

M.config.buffer = {
    normal = {
        [leader("B")] = {":BufmodeEnter<CR>", "buffermode"},
        [bufl("n")] = { ":bnext<CR>", "next buffer" },
        [bufl("p")] = { ":bprevious<CR>", "previous buffer" },
        [bufl("l")] = { ":bprevious<CR>", "previous buffer" },
        [bufl(" ")] = { ":bnext<CR>", "next buffer" },
        [bufl("b")] = { ":bnext<CR>", "next buffer" },
        [bufl("x")] = { ":BufferLinePickClose<CR>", "close buffer" },
        [bufl("s")] = { ":Telescope buffers<CR>", "select buffer" },
        [bufl("S")] = { ":BufferLinePick<CR>", "select buffer" },
        [bufl("1")] = { ":bfirst<CR>", "first buffer" },
        [bufl("0")] = { ":blast<CR>", "last buffer" },
    }
}


M.config.tab = {
    normal = {
        [leader("T")] = {":TabmodeEnter<CR>", "tabmode"},
        [tabl("n")] = { ":tabnext<CR>", "next tab" },
        [tabl("N")] = { ":tabnew<CR>", "new tab" },
        [tabl("o")] = { ":tabonly<CR>", "close all tabs but current" },
        [tabl(" ")] = { ":tabnext<CR>", "next tab" },
        [tabl("e")] = { ":tabedit ", "edit new file in new tab" },
        [tabl("m")] = { ":tabmove ", "move tabs" },
        [tabl("l")] = { ":exe 'tabn '.g:lasttab<CR>", "previos tab" },
    }
}

M.config.repl = {}
M.config.repl.normal = {
    [repl("g")] = { km.plugmapping("SendLine"), "Send to repl (line)" },
    [repl(" ")] = { km.plugmapping("SendLine"), "Send to repl (line)" },
    [repl("")] = { km.plugmapping("Send"), "Send to repl" },
}
M.config.repl.visual = {
    [repl("")] = { km.plugmapping("Send"), "Send to repl" },
}
M.config.leap = {}

local addmap = function (key, t, mode)
    local ret = function (lhs, rhs)
        t[key][mode][lhs] = rhs
    end
    return ret
end


local nmap = addmap("general", M.config, "normal")
local vmap = addmap("general", M.config, "visual")
local asterisk = {"*", "#"}
for _, star in ipairs(asterisk) do
    nmap(star, {km.plugmapping("(asterisk-z".. star ..")"), ""})
    nmap(g(star), {km.plugmapping("(asterisk-gz".. star ..")"), ""})
    vmap(g(star), {km.plugmapping("(asterisk-gz".. star ..")"), ""})
end


local mode_map = { normal = "n", visual = "v", terminal = "t", insert = "t", xmode = "x", omni = "o" }

M.setup = function(config)
    for _, v in pairs(config) do
        for mode, def in pairs(v) do
            local modestr = mode_map[mode]
            for lhs, rhs in pairs(def) do
                vim.keymap.set(modestr, lhs, rhs[1], {noremap=true, silent=true, desc=rhs[2]})
            end
        end
    end
end


return M
