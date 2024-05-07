local ui = { 'akinsho/bufferline.nvim', version = "*",      dependencies = 'nvim-tree/nvim-web-devicons' }

ui.config = function ()
    require("bufferline").setup()
end
add_plugin(ui)
