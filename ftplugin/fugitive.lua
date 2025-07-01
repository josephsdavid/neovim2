
-- vim.keymap.set("n", "<leader>cv", "<cmd>Git commit --no-verify<cr>", { buffer = true })
-- Python-specific keymap
vim.api.nvim_buf_set_keymap(0, "n", "cv",  "<cmd>Git commit --no-verify<cr>", { noremap = true, silent = true })
