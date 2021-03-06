require("neorg").setup({
	-- Tell Neorg what modules to load
	load = {
		["core.defaults"] = {}, -- Load all the default modules
		["core.gtd.base"] = {
			config = {
				-- workspace =   "example_gtd" , -- assign the workspace,
				workspace = "home",
				exclude = { "notes/" }, -- Optional: all excluded files from the workspace are not part of the gtd workflow
				projects = {
					show_completed_projects = false,
					show_projects_without_tasks = false,
				},
				custom_tag_completion = true,
			},
		},
		["core.presenter"] = {
			config = {
				zen_mode = "truezen",
			},
		},
		["core.integrations.telescope"] = {}, -- Enable the telescope module
		["core.looking-glass"] = {}, -- Enable the looking_glass module
		["core.integrations.truezen"] = {}, -- Enable the truezen module
		["core.export"] = {}, -- Enable the truezen module
		["core.export.markdown"] = {}, -- Enable the truezen module
		["core.norg.journal"] = {config = {workspace = "notes", strategy = "nested"}}, -- Enable the notes
		["core.norg.completion"] = { config = { engine = "nvim-cmp" } }, -- We current support nvim-compe and nvim-cmp only
		["core.norg.concealer"] = {
			config = {
				icon_preset = "varied",
			}, -- Allows for use of icons
		},
		["core.norg.qol.toc"] = {},
		["core.keybinds"] = { -- Configure core.keybinds
			config = {
				default_keybinds = true, -- Generate the default keybinds
				neorg_leader = Keys.norgleader(""), -- This is the default if unspecified
				hook = function(keybinds)
					keybinds.map_event("norg", "n", Keys.telescopeleader("l"), "core.integrations.telescope.find_linkable")
					keybinds.map_event("norg", "i", Keys.C("l"), "core.integrations.telescope.insert_link")
                    keybinds.map_event("norg", "n", Keys.norgleader("l"), "core.looking-glass.magnify-code-block")
					keybinds.map_event("norg", "i", Keys.C("b"), "core.looking-glass.magnify-code-block")
				end,
			},
		},
		["core.norg.dirman"] = { -- Manage your directories with Neorg
			config = {
				workspaces = {
					home = "~/neorg",
					-- personal = "~/neorg/personal",
					-- work = "~/neorg/work",
					notes = "~/neorg/notes",
					recipes = "~/neorg/notes/recipes",
					example_gtd = "~/example_workspaces/gtd",
					rtd = "~/tasq/realtime-deferment/src/functions/realtime/",
				},
				index = "index.norg",
				--[[ autodetect = true,
          autochdir = false, ]]
			},
		},
	},
})


