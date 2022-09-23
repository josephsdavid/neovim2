-- compat stuff
if table.unpack == nil then
    table.unpack = unpack
end
require("core.options")
require("core.plugins")
require("core.keymap")
-- require("core.namespace")
require("core.completion")
require("core.events")

