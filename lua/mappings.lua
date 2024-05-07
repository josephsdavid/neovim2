M  = {}

M.genleader = function(leader, f)
    if f == nil then
        local function ret(s)
            return table.concat({ leader, s })
        end

        return ret
    else
        local function ret(s)
            return table.concat(f({ leader, s }))
        end

        return ret
    end
end

local special = function(t)
    return { "<", t[1], "-", t[2], ">" }
end

M.leader = M.genleader("<Leader>")
M.localleader = M.genleader("<LocalLeader>")
M.ctrl = M.genleader("c", special)
M.alt = M.genleader("a", special)
M.shift = M.genleader("s", special)

function M.extendleader(f, k)
    return M.genleader(f(k))
end

function M.extendlocalleader(k)
    return M.genleader(M.localleader(k))
end


function M.rhs_surrounder(lhs, rhs)
    return function(s)
        return table.concat({ lhs, s, rhs })
    end
end

M.cmd = M.rhs_surrounder("<cmd>", "<cr>")
M.luacmd = M.rhs_surrounder("<cmd>lua ", "<cr>")
M.plugmapping = M.genleader("<Plug>")

local g = M.genleader("g")
local leader = M.leader
local Alt = M.alt
local Ctrl = M.ctrl
local cmd = M.cmd
local luacmd = M.luacmd

local scope = M.extendleader(leader, "f")
local bufl = M.extendleader(leader, "b")
local repl = M.extendleader(leader, "g")
local tabl = M.extendleader(leader, "t")
local cx = M.genleader(Ctrl("x"))
-- local cj = keymap.genleader(Ctrl("j"))
local cxc_ = function(s)
    return cx(Ctrl(s))
end

function M.clever_root()
    local root = require('lspconfig').util.root_pattern('Project.toml', '.git', 'pyproject.toml', '.envrc')(vim.api.nvim_buf_get_name(0))
    if root == nil then
        root = "%:p:h"
    end
    return root
end

local clever_tcd = function()
    vim.cmd("tcd " .. M.clever_root())
    vim.cmd("pwd")
end


M.n = {
    -- [" "] = { "<Nop>", "" },
    [Ctrl("c")] = { cmd("noh"), "clear highlight search" },
    ["0"] = { "^", "start of line" },
    ["_"] = { Ctrl("^"), "last buffer" },
    ["cl"] = { "s", "delete and insert" },
    [M.localleader("f")] = {cmd("Format"), "format"},
    [M.localleader("F")] = {cmd("FormatModifications"), "format modifications"},
    [leader("w")] = { cmd("w!"), "save" },
    [leader("cc")] = { cmd("tcd %:p:h<cr><cmd>pwd"), "cd to current file" },
    [leader("cd")] = { clever_tcd, "cd to current project or file" },
    [Alt("Up")] = { luacmd("require('tmux').resize_top()"), "Increase window size horizontal" },
    [Alt("Left")] = { luacmd("require('tmux').resize_left()"), "Decrease window size vertical" },
    [Alt("Right")] = { luacmd("require('tmux').resize_right()"), "Increase window size vertical" },
    [Alt("Down")] = { luacmd("require('tmux').resize_bottom()"), "Decrease window size horizontal" },
    [Ctrl(".")] = { cmd("bp"), "Previous buffer" },
    [Ctrl(",")] = { cmd("bn"), "next buffer" },
    [g("G")] = { luacmd("require'neogit'.open()"), "Git" },
    --[cxc_("h")] = { harpoon_notify(hm.add_file), "harpoon mark" },
    --[cx("h")] = { harpoon_notify(hm.add_file), "harpoon mark" },
    --[cx("x")] = { harpoon_notify(hm.add_file), "harpoon mark" },
    --[cxc_("x")] = { harpoon_notify(hm.add_file), "harpoon mark" },
    --[cxc_("n")] = { harpoon_notify(require('harpoon.ui').nav_next), "harpoon next" },
    --[cx("n")] = { harpoon_notify(require('harpoon.ui').nav_next), "harpoon next" },
    --[cxc_("p")] = { harpoon_notify(require('harpoon.ui').nav_prev), "harpoon prev" },
    --[cx("p")] = { harpoon_notify(require('harpoon.ui').nav_prev), "harpoon prev" },
    --[cxc_("m")] = { harpoon_notify(require('harpoon.cmd-ui').toggle_quick_menu), "harpoon command menu" },
    --[cx("m")] = { harpoon_notify(require('harpoon.cmd-ui').toggle_quick_menu), "harpoon command menu" },
    --[cxc_("f")] = { harpoon_notify(require('harpoon.ui').toggle_quick_menu), "harpoon menu" },
    --[cx("f")] = { harpoon_notify(require('harpoon.ui').toggle_quick_menu), "harpoon menu" },
    --[cxc_("o")] = { harpoon_notify(require('harpoon.ui').toggle_quick_menu), "harpoon menu" },
    --[cx("o")] = { harpoon_notify(require('harpoon.ui').toggle_quick_menu), "harpoon menu" },
    [scope(" ")] = { cmd("Telescope current_buffer_fuzzy_find theme=ivy previewer=false"), "current buffer find" },
    [scope("n")] = { cmd("Telescope ghn"), "find notifications" },
    [scope("h")] = { cmd("Telescope harpoon marks"), "harpoon" },
    [scope("f")] = { cmd("Telescope fd theme=ivy"), "find files" },
    [scope("r")] = { cmd("Telescope resume"), "resume" },
    [scope("g")] = { cmd("Telescope live_grep theme=ivy"), "live grep" },
    [scope("o")] = { cmd("Telescope oldfiles theme=ivy"), "find oldfiles" },
    -- [scope("B")] = { cmd("BufferLinePick"), "find buffers" },
    [scope("b")] = { cmd("Telescope buffers theme=ivy"), "find buffers" },
    [scope("t")] = { cmd("TodoTelescope theme=ivy"), "find todos" },
    ["z="] = { cmd("Telescope spell_suggest theme=ivy"), "spell suggest" },
    -- [scope("T")] = { cmd("TodoTelescope"), "find tabs" },
    [scope("i")] = { cmd("Octo issue list"), "Search issues" },
    [scope("p")] = { cmd("Octo pr list"), "Search prs" },
    [scope("M")] = { cmd("Telescope marks theme=ivy"), "find marks" },
    [scope("m")] = { cmd("Telescope harpoon marks theme=ivy"), "find harpoon marks" },
    [scope("j")] = { cmd("Telescope jumplist theme=ivy"), "find jumps" },
    [scope("e")] = { cmd("Telescope symbols theme=ivy"), "find symbols" },
    [scope("r")] = { cmd("Telescope reloader theme=ivy"), "reload" },
    [scope("d")] = { cmd("Telescope lsp_definitions theme=ivy"), "find lsp definitions" },
    [scope("D")] = { cmd("Telescope lsp_type_definitions theme=ivy"), "find lsp type definitions" },
    -- [scope("r")] = { cmd("Telescope lsp_references theme=ivy"), "find lsp references" },
    [Ctrl("p")] = { cmd("Telescope oldfiles theme=ivy"), "find oldfiles" },
    [Ctrl("f")] = { cmd("Telescope live_grep theme=ivy"), "live_grep" },
    -- [Ctrl("s")] = { cmd("Telescope fd theme=ivy previewer=false"), "find oldfiles" },
    -- [scope(" ")] = { cmd("Telescope frecency"), "find frecency" }
    [repl("g")] = { M.plugmapping("SendLine"), "Send to repl (line)" },
    [repl(" ")] = { M.plugmapping("SendLine"), "Send to repl (line)" },
    [repl("")] = { M.plugmapping("Send"), "Send to repl" },
    [tabl("n")] = { cmd("tabnext"), "next tab" },
    [tabl("N")] = { cmd("tabnew"), "new tab" },
    [tabl("o")] = { cmd("tabonly"), "close all tabs but current" },
    [tabl(" ")] = { cmd("tabnext"), "next tab" },
    [tabl("e")] = { ":tabedit ", "edit new file in new tab" },
    [tabl("m")] = { ":tabmove ", "move tabs" },
    [tabl("l")] = { cmd("exe 'tabn '.g:lasttab"), "previos tab" },
    [bufl("n")] = { cmd("bnext"), "next buffer" },
    [bufl("p")] = { cmd("bprevious"), "previous buffer" },
    [bufl("l")] = { cmd("bprevious"), "previous buffer" },
    [bufl(" ")] = { cmd("bnext"), "next buffer" },
    [bufl("b")] = { cmd("bnext"), "next buffer" },
    [bufl("x")] = { cmd("bdelete"), "close buffer" },
    [bufl("s")] = { cmd("Telescope buffers theme=ivy"), "select buffer" },
    [bufl("f")] = { cmd("Telescope buffers theme=ivy"), "select buffer" },
    [bufl("1")] = { cmd("bfirst"), "first buffer" },
    [bufl("0")] = { cmd("blast"), "last buffer" },


}


M.t = {
            ["<Esc>"] = { "<C-\\><C-n>", "Terminal escape" },
}
M.v = {
    [repl("")] = { M.plugmapping("Send"), "Send to repl" },
            ["<"] = { "<gv", "Move text left" },
            [">"] = { ">gv", "Move text right" },
            ["p"] = { '"_dP', "paste in place" },
            ["K"] = { ":move '>-2<CR>gv-gv", "Move text up (broken)" },
            ["J"] = { ":move '>+1<CR>gv-gv", "Move text down" },
}
M.x = {
            ["p"] = { '"_dP', "paste in place" },
            ["K"] = { ":move '>-2<CR>gv-gv", "Move text up (broken)" },
            ["J"] = { ":move '>+1<CR>gv-gv", "Move text down" },
}
M.o = {}
M.i = {}


for k, value in pairs({ left = "h", bottom = "j", top = "k", right = "l" }) do
    M.n[Ctrl(value)]   = { luacmd("require('tmux').move_"..k.."()"), "Window " .. k }
    M.t[Ctrl(value)] = { "<C-\\><C-N><C-w>" .. value, "Window " .. k }
    M.t[Alt(value)]  = { "<C-\\><C-N><C-w>" .. value, "Window " .. k }
end

local asterisk = { "*", "#" }
for _, star in ipairs(asterisk) do
    M.n[star] = { M.plugmapping("(asterisk-z" .. star .. ")"), "" }
    M.n[g(star)] = { M.plugmapping("(asterisk-gz" .. star .. ")"), "" }
    M.v[star] = { M.plugmapping("(asterisk-z" .. star .. ")"), "" }
    M.v[g(star)] = { M.plugmapping("(asterisk-gz" .. star .. ")"), "" }
    M.n["z" .. star] = { M.plugmapping("(asterisk-" .. star .. ")"), "" }
    M.n[g("z" .. star)] = { M.plugmapping("(asterisk-g" .. star .. ")"), "" }
    M.v["z" .. star] = { M.plugmapping("(asterisk-" .. star .. ")"), "" }
    M.v[g("z" .. star)] = { M.plugmapping("(asterisk-g" .. star .. ")"), "" }
end


local function _zz(s)
    return table.concat({ s, "zz" })
end

local function zz_(s)
    return table.concat({ "zz", s })
end

-- center everything
for _, jumps in ipairs({
    "G", "n", "N", "(", ")", "[[", "]]", "{", "}", "L", "H", Ctrl("u"), Ctrl("d"), Ctrl("i"), Ctrl("o"), Ctrl("t")
}) do

    M.n[jumps] = { _zz(jumps), "" }
    M.v[jumps] = { _zz(jumps), "" }

end


M.bound = {}
for _, v in ipairs({"n", "t", "v", "x", "o", "i"}) do
    M.bound[v] = {}
end

function M.keymap(mode, lhs, rhs, opts, desc)
    if M.bound[mode][lhs] ~= nil then
        vim.notify("duplicate keybind " .. lhs , 4)
        return nil
    end
    if desc ~= nil then
        opts.desc = desc
    end
    vim.keymap.set(mode, lhs, rhs, opts)

    M.bound[mode][lhs] = 1
end

function M.setup()
    for _, mode in ipairs({"n", "t", "v", "x", "o", "i"}) do
        local binds = M[mode]
        for lhs, rhs in pairs(binds) do
            M.keymap(mode, lhs, rhs[1], {noremap=true, silent=true}, rhs[2])
        end
    end
end

return M
