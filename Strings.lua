
if not Strings then
	Strings = {
		lang = "default",
		missing = {},
	}
end


function Strings:setup()
	-- local files = {}
	-- TODO

	self.default = {
		sys_weapon = "Weapon",
		sys_shield = "Shield",
	}
end

function Strings:convert(id)
	local res = self[self.lang][id]
	if res then return res end

	res = self.missing[id]
	if not res then
		print("Missing string with id'"..id.."'")
		self.missing[id] = true
	end
	return id
end