require "UiPanel"
require "Button"

UiPanel:newClass("UiPowerSystems")

function UiPowerSystems:init(powerSystem, config)
	default(config, {input = true})
	UiPowerSystems.super.init(self, config)
	self._powerSystem = powerSystem
	self._systems = {}

	self._total = self:newText({font = fonts.monoNormal, keepW = 40, align = "center"})

	local x = 0
	local y = 20
	local last
	for id, _ in pairs(powerSystem.systems) do
		last = UiPowerSubsystem(powerSystem, id, {
			parent = self,
			x = 0, y = y,
		})

		table.insert(self._systems, last)
		last.onUpdated = function() self:updateText() end
		y = y + 35
	end
	self._total.x = last._text.x
	self.w = last.w
	self.h = last.y + last.h

	self:updateText()
end

function UiPowerSystems:updateText()
	self._total:setText({{1, 1, 1}, self._powerSystem._free.."/"..self._powerSystem._max})
end

-------------------------------------

UiPanel:newClass("UiPowerSubsystem")

function UiPowerSubsystem:init(powerSystem, id, config)
	default(config, {input = true})
	UiPowerSubsystem.super.init(self, config)

	self._id = id
	self._powerSystem = powerSystem
	self._powerSub = powerSystem.systems[id]

	local name = self:newText(fonts.monoNormal, self._powerSub.name)
	local y = name.h
	self._text = self:newText({font = fonts.monoNormal, keepW = 40, align = "center", y = y})
	self._up = TextButton({parent = self, font = fonts.monoNormal, text = "+", y = y})
	self._down = TextButton({parent = self, font = fonts.monoNormal, text = "-", y = y})

	self._text.x = self._up.w
	self._down.x = self._text.x + self._text.w
	self.h = self._down.y + self._down.h

	function self._up.trigger()
		self:changePower(1)
	end

	function self._down.trigger()
		self:changePower(-1)
	end

	self:updateText()
end

function UiPowerSubsystem:updateText()
	self._text:setText({{1, 1, 1}, self._powerSub.power.."/"..self._powerSub.max})
	self.w = self._down.x + self._down.w
end

function UiPowerSubsystem:changePower(diff)
	self._powerSystem:changePower(self._id, diff)
	self:updateText()
	if self.onUpdated then
		self:onUpdated()
	end
end