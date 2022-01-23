local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

local mappings = require("user.utils").mappings

comment.setup {
  pre_hook = function(ctx)
    local U = require "Comment.utils"

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring {
      key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
      location = location,
    }
  end,
  toggler = {
    ---Line-comment toggle keymap
    line = mappings.commentleader("c"),
    ---Block-comment toggle keymap
    block = mappings.commentleader("b"),
  },
  ---LHS of operator-pending mappings in NORMAL + VISUAL mode
  ---@type table
  opleader = {
    ---Line-comment keymap
    line = mappings.vcommentleader("c"),
    ---Block-comment keymap
    block = mappings.vcommentleader("b"),
  },

  ---LHS of extra mappings
  ---@type table
  extra = {
    ---Add comment on the line above
    above = mappings.commentleader("O"),
    ---Add comment on the line below
    below = mappings.commentleader("o"),
    ---Add comment at the end of line
    eol = mappings.commentleader("O"),
  },
}
