require "UiPanel"

UiPanel:newClass("UiPile")

function UiPile:init(config)
	default(config, {
		input = true,
		w = 120, h = 150,
	})
	UiPile.super.init(self, config)
end

function UiPile:_draw()
	local lg = love.graphics

	lg.setColor(0,0,0)
	lg.rectangle("fill", 0, 0, self.w, self.h)
	lg.setColor(1,1,1)
	lg.setFont(fonts.normal)
	lg.rectangle("line", 0, 0, self.w, self.h)

	lg.printf(tostring(#self), 0, self.h * 0.5 - 7, self.w, "center")

	UiPile.super._draw(self)
end

UiPile:newClass("DrawPile")

function DrawPile:init(config)
	DrawPile.super.init(self, config)
	SimpleButton({
		parent = self, 
		x = 4, y = 4, 
		text = "draw",
		trigger = function() self:drawCard() end,
	})
end

function DrawPile:drawCard()
	local card = table.remove(self)
	if card then
		world.hand:addCard(card)
		card._hidden = nil
		local parent = card._uiParent
		parent:removeChild(card)
		parent:addChild(card)
		card:setPos(self.x, self.y)
	end
end

UiPile:newClass("DiscardPile")

function DiscardPile:init(config)
	DiscardPile.super.init(self, config)
	SimpleButton({
		parent = self, 
		x = 4, y = 4, 
		text = "shuffle",
		trigger = function() self:shuffleToDraw() end,
	})
end

function DiscardPile:shuffleToDraw() 
	local card = table.remove(self)
	while card do
		table.insert(world.drawPile, card)
		card = table.remove(self) 
	end
	array.shuffle(world.drawPile)
end