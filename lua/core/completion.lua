local km = require("core.keymap")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local ok, luasnip = pcall(require, "luasnip")
if not ok then
    return
end

local ok, lspkind = pcall(require, "lspkind")
if not ok then
    return
end

lspkind.init()

local with_control = function(t)
    local ret = {}
    for k, v in pairs(t) do
        ret[km.ctrl(k)] = v
    end
    return ret
end

local mapping = with_control({
    n = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    p = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    d = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
            require("luasnip").change_choice(-1)
        elseif cmp.visible() then
            cmp.scroll_docs(-4)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    f = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
            require("luasnip").change_choice(1)
        elseif cmp.visible() then
            cmp.scroll_docs(4)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    e = cmp.mapping.abort(),
    o = cmp.mapping(
        cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }, { "i", "c" }),
    y = cmp.mapping(
        cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }, { "i", "c" }),
    ["Space"] = cmp.mapping.confirm({ select = true }),
    q = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    },
    j = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.mapping.abort()
            cmp.mapping.close()
        end
        if luasnip.expandable() then
            luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    k = cmp.mapping(function(fallback)

        if cmp.visible() then
            cmp.mapping.abort()
            cmp.mapping.close()
        end
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
})

mapping["<CR>"] = cmp.mapping.confirm({
    select = true,
    behavior = cmp.ConfirmBehavior.Insert,
})

local sources = {
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    {name = "rg"--[[ , keyword_length=3 ]]},
    { name = "path" },
    { name = "neorg" },
    { name = "treesitter",  },
    -- { name = "conjure" },
    { name = "buffer",   },
    { name = "latex_symbols" },
}

local sorting = {
    comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find "^_+"
            local _, entry2_under = entry2.completion_item.label:find "^_+"
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
                return false
            elseif entry1_under < entry2_under then
                return true
            end
        end,

        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
    },
}


local snippet = {
    expand = function(args)
        require("luasnip").lsp_expand(args.body)
    end
}

local formatting = {
    format = lspkind.cmp_format {
        with_text = true,
        menu = {
            nvim_lua = "[lua]",
            luasnip = "[snip]",
            nvim_lsp = "[lsp]",
            path = "[path]",
            neorg = "[norg]",
            treesitter = "[ts]",
            -- conjure = "[conj]",
            buffer = "[buf]",
            rg = "[rg]",
            latex_symbols = "[tex]" },
    }
}

cmp.setup {
    mapping = mapping,
    sources = sources,
    sorting = sorting,
    snippet = snippet,
    formatting = formatting,
    experimental = { native_menu = false, ghost_text = true }
}

cmp.setup.cmdline("/", {
    completion = {
        autocomplete = false,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" },
    }, {
    }),
})

cmp.setup.cmdline(":", {
    completion = {
        autocomplete = false,
    },

    sources = cmp.config.sources({
        {
            name = "path",
        },
    }, {
        {
            name = "cmdline",
            max_item_count = 20,
            keyword_length = 4,
        },
    }),
})

