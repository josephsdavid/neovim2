local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end
local lspconfig =require"lspconfig"

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local helpers = require("null-ls.helpers")

-- local jet_julia = {
--   method = null_ls.methods.DIAGNOSTICS,
--   filetypes = { "julia" },
--   generator = null_ls.generator({
--     command = "jet",
--     to_stdin = true,
--     from_stderr = true,
--     timeout = 15000, -- arbitrary large number. Depending on how long JET takes, you may need to increase this number
--     format = "line",
--     check_exit_code = function(code)
--       return code <= 1
--     end,
--     args = function(params)
--       local filename = params.bufname
--       return { filename }
--     end,
--     on_output = helpers.diagnostics.from_patterns({
--       {
--         pattern = [[(%d+):(.*)]],
--         groups = { "row", "message" },
--       },
--     }),
--   }),
-- }
--
-- null_ls.register(jet_julia)


null_ls.setup({
	debug = false,
	sources = {
		formatting.yapf,
		formatting.stylua,
		formatting.isort,
    -- jet_julia,
		--[[ diagnostics.mypy.with({
			extra_args = {
				"--ignore-missing-imports",
				"--allow-untyped-calls",
				"--allow-untyped-defs",
        "--check-untyped-defs",
				"--allow-incomplete-defs",
				"--check-untyped-defs",
				"--implicit-optional",
				"--warn-redundant-casts",
				"--warn-no-return",
        "--warn-return-any",
				"--warn-unreachable",
				"--allow-untyped-globals",
				"--disallow-redefinition",
				"--no-implicit-reexport"
			},
		}), ]]
		--[[ diagnostics.pylama,
		diagnostics.pylint, ]]
    -- diagnostics.flake8.with({
    --   extra_args = { "--config", vim.fn.expand("~/.config/flake8") },
    -- }),
		diagnostics.hadolint,
		-- diagnostics.selene,
		diagnostics.shellcheck,
	},
  root_dir = lspconfig.util.root_pattern(
  "pyproject.toml",
  ".null-ls-root",
  ".git",
  ".env"
  )
})
