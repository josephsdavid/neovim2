local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		formatting.yapf,
		formatting.stylua,
		formatting.isort,
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
		diagnostics.hadolint,
    diagnostics.selene,
    diagnostics.shellcheck,
	},
})
