require "Class"
require "Strings"

Class:newClass("PowerSystems")

function PowerSystems:init(max, systems)
	self._max = max or 0
	self._free = self._max
	self.systems = {}

	for id, v in pairs(systems) do
		self.systems[id] = {max = v, power = 0, name = Strings:convert("sys_"..id)}
	end
end

function PowerSystems:getPower(id)
	local sys = self.systems[id]
	return sys and sys.power or 0
end

function PowerSystems:setPower(id, power)
	local sys = self.systems[id]

	power = math.max(math.min(sys.max, power), 0)
	local diff = math.min(power - sys.power, self._free)

	self._free = self._free - diff
	sys.power = sys.power + diff

	return sys.power
end

function PowerSystems:changePower(id, diff)
	local sys = self.systems[id]

	local power = math.max(math.min(sys.max, sys.power + diff), 0)
	diff = math.min(power - sys.power, self._free)

	self._free = self._free - diff
	sys.power = sys.power + diff

	return sys.power
end
