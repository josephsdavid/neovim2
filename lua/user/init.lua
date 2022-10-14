require("user.jltest")
local cache = {}

local function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function spoof()
    -- probably this is a plenary thing
    -- somehting like `while(read(input))`
    local input = vim.fn.input(":")
    -- feed ":" to neovim
    -- while input is going
    -- feed that key to neovim,
    -- also store that key in the cache
    -- concatenate all the keys together
    -- split by "/"
end

local function redo()
    local cmd = "%"..cache[1].."/" ..cache[3].."/"
    -- feed : to nvim
    -- feed cmd to nvim
    -- probably this is a plenary thing
    local input = vim.fn.input(":"..cmd)
    -- feed input to neovim
end


return {spoof = spoof, redo = redo}
