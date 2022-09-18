local km = require("core.keymap")
local toggleterm = require "toggleterm"
M = {}

function M.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end




M.genterm = function(opts)
    local term = require("toggleterm.terminal").Terminal:new(opts)
    -- Defined in
    local out = function()
        term:toggle()
    end
    return out
end


M.toggle_horizontal = M.genterm({direction = "horizontal", hidden=true})
M.toggle_vertical = M.genterm({direction = "vertical", hidden=true})


M.setup = function()
    vim.cmd([[autocmd! TermOpen term://* lua require"config.terminal".set_terminal_keymaps()]])
    Bindings.config.terminal = {normal = {}}
    Bindings.config.terminal.normal[km.ctrl(",")] = {[[:lua require"config.toggleterm".toggle_horizontal()]], ""}
    Bindings.config.terminal.normal[km.ctrl(".")] = {[[:lua require"config.toggleterm".toggle_vertical()]], ""}
    toggleterm.setup({
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
            end
        end,
        open_mapping = km.ctrl("\\"),
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = false,
        shading_factor = 2,
        start_in_insert = false,
        insert_mappings = true,
        persist_size = true,
        direction = "vertical",
        close_on_exit = false,
        shell = vim.o.shell,
        float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    })
end


local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
  -- function to run on closing the terminal
})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<localleader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

return M
