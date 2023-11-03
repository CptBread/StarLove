require "UiPanel"
require "UiCard"
require "Table"

Class:newClass("HandPile")

function HandPile:init(playFunc, maxCards, config)
	default(config, {
		w = UiCard.W * 5, h = UiCard.H * 1.4,
	})
	self.parent = config.parent or root
	self.x, self.y = config.x, config.y
	self.w, self.h = config.w, config.h
	self.padd = config.padd or UiCard.W * 0.2
	self.max = maxCards
	self.map = {}
	self.playFunc = playFunc
end

function HandPile:addCard(card)
	card.playBtn.trigger = function(...)
		self.playFunc(card, ...)
	end

	table.insert(self, card)

	self:updatePoints()
	return card
end

function HandPile:removeCard(card)
	array.removeUnique(self, card)
	self:updatePoints()
end

function HandPile:updatePoints()
	local num = #self
	local dist = math.min(math.floor((self.w - self.padd * 2) / num), UiCard.W)
	local x = self.x + self.padd
	local y = self.y + self.h * 0.5
	for i,v in ipairs(self) do
		v:setHoldPos(x, y)
		x = x + dist
	end
end