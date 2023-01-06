M = {}

function M.setkey(k)
    local function out(kk, v)
        vim[k][kk] = v
    end

    return out
end

vim.cmd([[set whichwrap+=<,>,[,],h,l]])
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]])
vim.cmd([[filetype plugin on]])

M.setopt = M.setkey("opt")
M.setglobal = M.setkey("g")
M.setbuffer = M.setkey("b")

M.setters = { opt = M.setopt, global = M.setglobal, buffer = M.setbuffer }


-- M.setopt("so", 7)



-- M.setglobal("conjure#mapping#doc_word", "<LocalLeader>K")
-- M.setglobal("JuliaFormatter_always_launch_server", 1)
-- M.setglobal("conjure#filetype", {"clojure", "fennel", "janet", "racket", "scheme"})
-- M.setglobaldelete_replaced_bufferdelete_replaced_buffer("unception_open_buffer_in_new_tab", true)

vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
vim.cmd[[hi clear DiffText]]
vim.api.nvim_set_hl(0, 'DiffText', { link = 'DiffChange' })
-- vim.api.nvim_set_hl(0,"Spell", {undercurl=true})
return M
