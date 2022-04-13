local function make_leader(leader)
	local function ret(s)
		return table.concat({ leader, s })
	end
	return ret
end

local function make_modifier(leader)
	local function ret(s)
		return table.concat({ "<", leader, "-", s, ">" })
	end
	return ret
end

Paths = {
	snippets = "/home/david/.config/nvim/lua/user/snips",
}
PDB = "__import__('pdb').set_trace()"

Keys = {}

Keys.leader = make_leader("<leader>")
Keys.peekleader = make_leader(Keys.leader("p"))
Keys.refactorleader = make_leader(Keys.leader("r"))
Keys.swapleader = make_leader(Keys.leader("m"))
Keys.docsleader = make_leader(Keys.leader("d"))
Keys.commentleader = make_leader(Keys.leader("c"))
Keys.telescopeleader = make_leader(Keys.leader("f"))
Keys.replleader = make_leader(Keys.leader("g"))
Keys.C = make_modifier("c")
Keys.A = make_modifier("a")
Keys.M = make_modifier("a")
Keys.S = make_modifier("s")
-- Keys.hopleader = make_leader(Keys.leader("h"))
Keys.go = make_leader("g")
Keys.gitleader = make_leader(Keys.leader("g"))
Keys.tableader = make_leader(Keys.leader("t"))
Keys.bufferleader = make_leader(Keys.leader("b"))
Keys.norgleader = make_leader(Keys.leader("o"))
Keys.harpoonleader = make_leader(Keys.leader("m"))
Keys.qfleader = make_leader(Keys.leader("q"))

Prequire = function(module) -- Stolen from danymat
	local ok, mod = pcall(require, module)
	return ok, mod
end

Notifications = {}

Notifications.cwd = function()
	require("notify")(vim.fn.getcwd(), "info", {
		title = "CWD Changed!",
		icon = "📂",
    timeout = 1000
	})
end

