require("impatient").enable_profile()
E = require("core.events")

if table.unpack == nil then
    table.unpack = unpack
end


function partial(f, ...)
    local args = ...
    return function(...)
        return f(table.unpack(args), ...)
    end
end

function map(f, ...)
    local t = {}
    for k, v in ipairs(...) do
        t[#t+1] = f(v)
    end
    return t
end

function dmap(f, ...)
    local t = {}
    for k, v in pairs(...) do
        t[k] = f(v)
    end
    return t
end

function filter(f, ...)
    local t = {}
    for _, v in ipairs(...) do
        if f(v) == true then
            t[#t+1] = (v)
        end
    end
    return t
end

function dfilter(f, ...)
    local t = {}
    for k, v in pairs(...) do
        if f(v) == true then
            t[k] = (v)
        end
    end
    return t
end

require"core"
require "config"
require "user"

-- venn.nvim: enable or disable keymappings
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})
