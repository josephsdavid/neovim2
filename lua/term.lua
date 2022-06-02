local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end
local wk = require("which-key")


toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = Keys.C("\\"),
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

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal

local vert = Terminal:new({ hidden = true, direction = "vertical" })
local horiz = Terminal:new({ hidden = true, direction = "horizontal" })

function _VERT_TOGGLE()
  vert:toggle()
end

function _HORIZ_TOGGLE()
  horiz:toggle()
end

vim.api.nvim_set_keymap("n", Keys.C("."), "<cmd>lua _VERT_TOGGLE()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", Keys.C(","), "<cmd>lua _HORIZ_TOGGLE()<CR>", { noremap = true, silent = true })


local jltest = Terminal:new({ cmd = "julia -e 'using Pkg; Pkg.test()'", hidden = true, direction = "float", close_on_exit=false })

function _TEST_TOGGLE()
  jltest:toggle()
end

vim.api.nvim_set_keymap("n", Keys.yabsleader("t"), "<cmd>lua _TEST_TOGGLE()<CR>", { noremap = true, silent = true })

local node = Terminal:new({ cmd = "node", hidden = true })

function _NODE_TOGGLE()
  node:toggle()
end

local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })

function _NCDU_TOGGLE()
  ncdu:toggle()
end

local htop = Terminal:new({ cmd = "htop", hidden = true, direction = "horizontal" })

function _HTOP_TOGGLE()
  htop:toggle()
end

-- vim.api.nvim_set_keymap("n", "<leader>h", "<cmd>lua _HTOP_TOGGLE()<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>lua _PYTHON_TOGGLE()<CR>", {noremap = true, silent = true})
--
