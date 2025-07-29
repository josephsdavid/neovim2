vim.cmd([[
  syntax off
  filetype off
  filetype plugin indent off
]])

Plugins = {}

function add_plugin(plugin)
    Plugins[#Plugins + 1] = plugin
    return Plugins
end

function add_plugins(plugins)
    for _, plugin in ipairs(plugins) do
        add_plugin(plugin)
    end
    return Plugins
end

require("bootstrap")
require("options")
require("colorscheme")
require("autocmds")
Mappings = require("mappings")
require("ui")
require("lsp")
require("completion")
require("search")
require("git")
require("terminal")
require("debugger")
require("testing")
require("norgconfig")
require("misc_plugins")
require("ai")
require("tsconfig")
require("gemini")

Mappings.setup()



require("lazy").setup(Plugins, {
    install = {
        -- install missing plugins on startup. This doesn't increase startup time.
        missing = true,
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "vimbones" },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            }
        }
    },
})




vim.cmd([[
  colorscheme doom-one
  colorscheme doom-one
  syntax on
  filetype on
  filetype plugin indent on
]])
