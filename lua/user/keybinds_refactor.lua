--[[ this is not working yet ]]
local mappings = require('user.utils').mappings



local function apply_maps(list, opts)
    for key, value in pairs(list) do
        vim.api.nvim_set_keymap(key[1], key[2], value, opts)
    end
end

local function leader_map(leader, list, opts)
    for key, value in pairs(list) do
        vim.api.nvim_set_keymap(leader(key[1]), key[2], value, opts)
    end
end


vim.cmd[[
function! InsertLine()
  let trace = expand("__import__('pdb').set_trace()")
  execute "normal O".trace
endfunction
]]

vim.g.mapleader = " "
vim.g.maplocalleader = " "



local basic_maps = {
  [{"", "< >"}] = "<Nop>",
  [{"", "0"}] = "^",
  [{"n", mappings.leader("e")}] = ":Lex 30<cr>",
  [{"i", "jk"}] = "<ESC>",
  [{"n", mappings.leader("D")}] = ":Dirbuf<CR>",
  [{"n", "_"}] = "<C-^>",
}

apply_maps(basic_maps, {noremap = true, silent = true})


local c_maps = {
  [{"", "b"}] = ":call InsertLine()<CR>",
  [{"n", "h"}] = "<C-w>h",
  [{"n", "j"}] = "<C-w>j",
  [{"n", "k"}] = "<C-w>k",
  [{"n", "l"}] = "<C-w>l",
  [{"n", "Up"}] = ":resize +2<CR>",
  [{"n", "Left"}] = ":vertical resize -2<CR>",
  [{"n", "Right"}] = ":vertical resize +2<CR>",
  [{"n", "Down"}] = ":resize -2<CR>",
  [{'n', 'p'}] = ':BufferPick<CR>',
}

local a_maps = {
  [{"v", "k"}] = ":m -.2<CR>==",
  [{"v", "j"}] = ":m +.1<CR>==",
  [{"x", "j"}] = ":move '>+1<CR>gv-gv",
  [{"x", "k"}] = ":move '<-2<CR>gv-gv",
  [{'n', ','}] = ':BufferPrevious<CR>',
  [{'n', '.'}] = ':BufferNext<CR>',
  [{'n', '<'}] = ':BufferMovePrevious<CR>',
  [{'n', '>'}] = ' :BufferMoveNext<CR>',
  [{'n', '1'}] = ':BufferGoto 1<CR>',
  [{'n', '2'}] = ':BufferGoto 2<CR>',
  [{'n', '3'}] = ':BufferGoto 3<CR>',
  [{'n', '4'}] = ':BufferGoto 4<CR>',
  [{'n', '5'}] = ':BufferGoto 5<CR>',
  [{'n', '6'}] = ':BufferGoto 6<CR>',
  [{'n', '7'}] = ':BufferGoto 7<CR>',
  [{'n', '8'}] = ':BufferGoto 8<CR>',
  [{'n', '9'}] = ':BufferGoto 9<CR>',
  [{'n', '0'}] = ':BufferLast<CR>',
  [{'n', 'x'}] = ':BufferClose<CR>',
  [{"n", "h"}] = "<C-w>h",
  [{"n", "j"}] = "<C-w>j",
  [{"n", "k"}] = "<C-w>k",
  [{"n", "l"}] = "<C-w>l",
  [{"n", "Up"}] = ":bnext<CR>",
  [{"n", "Down"}] = ":bprevious<CR>",

}

leader_map(mappings.C, c_maps)
leader_map(mappings.A, a_maps)



