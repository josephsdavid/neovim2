local term = {
    "akinsho/toggleterm.nvim",
}



function term.config()
    local toggleterm = require("toggleterm")
    toggleterm.setup({
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
            end
        end,
        open_mapping = Mappings.alt("\\"),
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = false,
        shading_factor = 2,
        start_in_insert = false,
        insert_mappings = false,
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

add_plugin(term)

add_plugin({ "vimlab/split-term.vim", cmd = { "Term", "VTerm" } })
add_plugin(
    {
        'chomosuke/term-edit.nvim',
        lazy = false, -- or ft = 'toggleterm' if you use toggleterm.nvim
        version = '1.*',
        config = function()
            -- Calling require 'term-edit'.setup(opts) is mandatory
            require 'term-edit'.setup {
                -- Mandatory option:
                -- Set this to a lua pattern that would match the end of your prompt.
                -- Or a table of multiple lua patterns where at least one would match the
                -- end of your prompt at any given time.
                -- For most bash/zsh user this is '%$ '.
                -- For most powershell/fish user this is '> '.
                -- For most windows cmd user this is '>'.
                prompt_end = { '%$ ', '▶ ', '> ', ">>> ", "❯ " }
                -- How to write lua patterns: https://www.lua.org/pil/20.2.html
            }
        end
    }
)
