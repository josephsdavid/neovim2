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
Keys.swapleader = make_leader(Keys.leader("m"))
Keys.peekleader = make_leader(Keys.leader("p"))
Keys.refactorleader = make_leader(Keys.leader("r"))
Keys.docsleader = make_leader(Keys.leader("d"))
Keys.commentleader = make_leader(Keys.leader("c"))
Keys.vcommentleader = make_leader(Keys.leader("v"))
Keys.actionleader = make_leader(Keys.leader("a"))
Keys.telescopeleader = make_leader(Keys.leader("f"))
Keys.troubleleader = make_leader(Keys.leader("x"))
Keys.zeplleader = make_leader(Keys.leader("s"))
Keys.C = make_modifier("c")
Keys.A = make_modifier("a")
Keys.M = make_modifier("a")
Keys.S = make_modifier("s")
Keys.hopleader = make_leader(Keys.leader("j"))
Keys.go = make_leader("g")
Keys.tableader = make_leader(Keys.leader("t"))
Keys.bufferleader = make_leader(Keys.leader("b"))
Keys.norgleader = make_leader(Keys.leader("o"))
Keys.harpoonleader = make_leader(Keys.leader("h"))

Prequire = function(module) -- Stolen from danymat
	local ok, mod = pcall(require, module)
	return ok, mod
end
