local tz_config = require("user.utils").tz_config
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
		["core.integrations.truezen"] = {}, -- Enable the truezen module
		["core.norg.completion"] = { config = { engine = "nvim-cmp" } }, -- We current support nvim-compe and nvim-cmp only
		["core.norg.concealer"] = {
			config = {
				icon_preset = "diamond",
				markup_preset = "dimmed",
			}, -- Allows for use of icons
		},
		["core.norg.qol.toc"] = {},
		["core.keybinds"] = { -- Configure core.keybinds
			config = {
				default_keybinds = true, -- Generate the default keybinds
				neorg_leader = Keys.norgleader(""), -- This is the default if unspecified
			},
		},
		["core.norg.dirman"] = { -- Manage your directories with Neorg
			config = {
				workspaces = {
					home = "~/neorg",
					-- personal = "~/neorg/personal",
					-- work = "~/neorg/work",
					notes = "~/neorg/notes",
					example_gtd = "~/example_workspaces/gtd",
				},
				index = "index.norg",
				--[[ autodetect = true,
          autochdir = false, ]]
			},
		},
	},
})

local neorg_callbacks = require("neorg.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
	-- Map all the below keybinds only when the "norg" mode is active
	keybinds.map_event_to_mode("norg", {
		n = { -- Bind keys in normal mode
			{ Keys.telescopeleader("l"), "core.integrations.telescope.find_linkable" },
			{ Keys.C("j"), "core.norg.manoeuvre.item_down" },
			{ Keys.C("k"), "core.norg.manoeuvre.item_up" },
			{ Keys.C("k"), "core.norg.manoeuvre.item_up" },
		},

		i = { -- Bind in insert mode
			{ Keys.C("l"), "core.integrations.telescope.insert_link" },
		},
	}, {
		silent = true,
		noremap = true,
	})

	keybinds.map_event_to_mode("presenter", {
		n = { -- Bind keys in normal mode
			{ Keys.S("l"), "core.presenter.next_page" },
			{ Keys.S("h"), "core.presenter.previous_page" },
			{ Keys.S("c"), "core.presenter.close" },
		},
	}, {
		silent = true,
		noremap = true,
		nowait = true,
	})
end)

