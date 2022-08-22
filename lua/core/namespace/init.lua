M = {}

local function partial(f, ...)
    local args = ...
    return function(...)
        return f(args, ...)
    end
end

M.Mode = {}
M.Mode.__index = M.Mode

function M.Mode:new(name, traits, cmd, keybind, desc, on_enter, on_exit)
    -- fail fast
    if keybind == nil and cmd == nil then
        error("Must set either a keybind or a command!", 1)
    end
  return setmetatable({
        name=name,
        traits=traits,
        cmd=cmd or nil,
        keybind=keybind or nil,
        desc=desc or nil,
        on_enter=on_enter or nil,
        on_exit=on_exit or nil,
        active = false
    }, self)
end

function M.new_mode(name, traits, cmd, keybind, desc, on_enter, on_exit)
    return M.Mode:new(name, traits, cmd, keybind, desc, on_enter, on_exit)
end

function M.Mode:toggle()
    for _, trait in pairs(self.traits) do
        trait.toggle()
    end
    self.active = not(self.active)
end


local trait = {}
trait.__index = trait
function trait:new(spec, enable, disable)
  return setmetatable({
        spec = spec,
        enable = enable,
        disable = disable,
        active = false
    }, self)
end


function trait:toggle()
    if self.active then
        self.disable(self.spec)
    else
        self.enable(self.spec)
    end
    self.active = not(self.active)
end

function M.keybind_trait(spec)
    return trait:new(spec, partial(vim.keymap.set, unpack(spec)), partial(vim.keymap.del,spec.mode, spec.lhs))
end

function M.export(mode)
    -- redundancy
    if mode.cmd == nil and mode.keybind == nil then
        error("cannot export a minor mode without a command or keybind", 1)
    end
    if not(mode.cmd == nil) then
        vim.api.nvim_create_user_command(mode.cmd, mode.toggle, {})
    end
    if not(mode.keybind == nil) then
        vim.keymap.set("n", mode.keybind, mode.toggle, {noremap=true, silent=false})
    end
end

return M
