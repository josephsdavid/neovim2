require('bqf').setup({
    auto_enable = true,
    magic_window = true,
    auto_resize_height = false,
    preview = {
        auto_preview = true,
        border_chars = {'│', '│', '─', '─', '╭', '╮', '╰', '╯', '█'},

        delay_syntax = 50,
        win_height = 15,
        win_vheight = 15,
        wrap = false,
        should_preview_cb = nil
    },
    filter = {
        fzf = {
            action_for = {
              ['cr'] = 'openc',
              ['ctrl-t'] = 'tabedit',
              ['ctrl-v'] = 'vsplit',
              ['ctrl-x'] = 'split',
              ['ctrl-q'] = 'signtoggle',
              ['ctrl-c'] = 'closeall'
            },
        }
    }
})
