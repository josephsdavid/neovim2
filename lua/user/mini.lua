local mrequire = function (m)
  return require(table.concat({"mini.", m}))
end

mrequire("bufremove").setup()

-- require("mini.base16").setup()

mrequire("comment").setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Toggle comment (like `gcip` - comment inner paragraph) for both
    -- Normal and Visual modes
    comment = 'gc',

    -- Toggle comment on current line
    comment_line = 'gcc',

    -- Define 'comment' textobject (like `dgc` - delete whole comment block)
    textobject = 'gc',
  },
})

mrequire("jump").setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    forward = 'f',
    backward = 'F',
    forward_till = 't',
    backward_till = 'T',
    repeat_jump = ';',
  },

  -- Delay (in ms) between jump and highlighting all possible jumps. Set to
  -- a very big number (like 10^7) to virtually disable highlighting.
  highlight_delay = 250,
})
mrequire("misc").setup({"put_text", "put"})


-- mrequire("tabline").setup()

-- mrequire("statusline").setup({
-- 	content = {
-- 		active = function()
--       -- stylua: ignore start
--       local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
--       local spell         = vim.wo.spell and (MiniStatusline.is_truncated(120) and 'S' or 'SPELL') or ''
--       local wrap          = vim.wo.wrap  and (MiniStatusline.is_truncated(120) and 'W' or 'WRAP')  or ''
--       local git           = MiniStatusline.section_git({ trunc_width = 75 })
--       -- Default diagnstics icon has some problems displaying in Kitty terminal
--       local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75, icon = '' })
--       local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
--       local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
--       local searchcount   = MiniStatusline.section_searchcount({ trunc_width = 75})
--       local location      = MiniStatusline.section_location({ trunc_width = 75 })
--
--       -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
--       -- correct padding with spaces between groups (accounts for 'missing'
--       -- sections, etc.)
--       return MiniStatusline.combine_groups({
--         { hl = mode_hl,                  strings = { mode, spell, wrap } },
--         '%<', -- Mark general truncate point
--         { hl = 'MiniStatuslineFilename', strings = { filename } },
--         '%=', -- End left alignment
--         { hl = 'MiniStatuslineDevinfo',  strings = { git, diagnostics } },
--         '%<', -- Mark general truncate point
--         -- { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
--         { hl = mode_hl,                  strings = { searchcount, location } },
--       })
-- 			-- stylua: ignore end
-- 		end,
-- 	},
-- })

-- mrequire("surround").setup({
--   -- Number of lines within which surrounding is searched
--   n_lines = 20,
--
--   -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
--   highlight_duration = 20,
--
--   -- Pattern to match function name in 'function call' surrounding
--   -- By default it is a string of letters, '_' or '.'
--   funname_pattern = '[%w_%.]+',
--
--   -- Module mappings. Use `''` (empty string) to disable one.
--   mappings = {
--     add = 'ys', -- Add surrounding
--     delete = 'ds', -- Delete surrounding
--     find = '', -- Find surrounding (to the right)
--     find_left = '', -- Find surrounding (to the left)
--     highlight = '', -- Highlight surrounding
--     replace = 'cs', -- Replace surrounding
--     update_n_lines = '', -- Update `n_lines`
--   },
-- })

