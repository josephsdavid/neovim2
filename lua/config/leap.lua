return { setup = function()
    local leap = require "leap"
    vim.cmd([[autocmd ColorScheme * lua require('leap').init_highlight(true)]])
    leap.setup {
        max_aot_targets = nil,
        highlight_unlabeled = true,
        case_sensitive = true,
        -- Groups of characters that should match each other.
        -- Obvious candidates are braces & quotes ('([{', ')]}', '`"\'').
        equivalence_classes = {
            ' \t\r\n',
            ')]}>',
            '([{<',
            { '"', "'", '`' },
        },
        -- Leaving the appropriate list empty effectively disables "smart" mode,
        -- and forces auto-jump to be on or off.
        -- safe_labels = { . . . },
        -- labels = { . . . },
        -- These keys are captured directly by the plugin at runtime.
        -- (For `prev_match`, I suggest <s-enter> if possible in the terminal/GUI.)
        special_keys = {
            repeat_search = '<enter>',
            next_match    = '<space>',
            prev_match    = '<C-space>',
            next_group    = '<tab>',
            prev_group    = '<S-tab>',
        },
    }
    leap.set_default_keymaps()
end
}
