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


-- configure everything here
require("colorscheme")
require("options")
Mappings = require("mappings")
require("misc_plugins")
require("completion")
require("ai")
require("lsp")
require("search")
require("tsconfig")
require("terminal")
require("testing")
require("autocmds")
require("debugger")
-- require("norgconfig")
require("ui")
require("git")

require("lazy").setup(Plugins, {
    install = {
        -- install missing plugins on startup. This doesn't increase startup time.
        missing = true,
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "doom-one" },
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

Mappings.setup()



vim.cmd([[
  syntax on
  filetype on
  filetype plugin indent on
  colorscheme doom-one
]])
