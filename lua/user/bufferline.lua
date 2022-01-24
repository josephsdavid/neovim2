-- local map = vim.api.nvim_set_keymap
-- local mappings = require('user.utils').mappings
-- local opts = { noremap = true, silent = true }
--
-- -- Move to previous/next
-- -- Wipeout buffer
-- --                 :BufferWipeout<CR>
-- -- Close commands
-- --                 :BufferCloseAllButCurrent<CR>
-- --                 :BufferCloseBuffersLeft<CR>
-- --                 :BufferCloseBuffersRight<CR>
-- -- Magic buffer-picking mode
-- map('n', '<C-p>', ':BufferPick<CR>', opts)
-- -- Sort automatically by...
-- map('n', mappings.bufferleader("l"), ':bprevious<CR>', opts)
-- map('n', mappings.bufferleader("p"), ':bprevious<CR>', opts)
-- map('n', mappings.bufferleader("n"), ':bnext<CR>', opts)
-- map('n', mappings.bufferleader("b"), ':bnext<CR>', opts)
-- map('n', mappings.bufferleader(" "), ':bnext<CR>', opts)
-- map('n', mappings.bufferleader("x"), ':BufferClose<CR>', opts) -- i never really close buffers so it does not matter too much
-- map('n', mappings.bufferleader("s"), ' :b ', {silent = false, noremap=true})
-- map('n',mappings.bufferleader('1'), ':bfirst<CR>', opts)
-- map('n',mappings.bufferleader('2'), ':b 2<CR>', opts)
-- map('n',mappings.bufferleader('3'), ':b 3<CR>', opts)
-- map('n',mappings.bufferleader('4'), ':b 4<CR>', opts)
-- map('n',mappings.bufferleader('5'), ':b 5<CR>', opts)
-- map('n',mappings.bufferleader('6'), ':b 6<CR>', opts)
-- map('n',mappings.bufferleader('7'), ':b 7<CR>', opts)
-- map('n',mappings.bufferleader('8'), ':b 8<CR>', opts)
-- map('n',mappings.bufferleader('9'), ':b 9<CR>', opts)
-- map('n',mappings.bufferleader('0'), ':blast<CR>', opts)

-- Set barbar's options
vim.g.bufferline = {
  -- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  --[[ exclude_ft = {'javascript'},
  exclude_name = {'package.json'}, ]]

  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = true,

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 4,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
