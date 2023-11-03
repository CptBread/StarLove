require "UiPanel"
require "Button"
require "Card"


UiPanel:newClass("UiCard")

UiCard.H = 150
UiCard.W = 120

function UiCard:init(card, config)
	default(config, {
		input = true,
		w = self.W, h = self.H,
	})
	UiCard.super.init(self, config)

	self.card = card
	self.hx, self.hy = self.x, self.y
	self.ax, self.ay = self.x, self.y

	self.playBtn = SimpleButton({parent = self, x = 4, y = 90, text = "play"})

	local update = self._uiRoot and self._uiRoot.tickList
	if update then
		update:insert(self)
	end
end

function UiCard:playCard(...)
	self.card:playCard(...)
end

function UiCard:setHoldPos(x, y, onThere)
	self.hx, self.hy = x, y
	self.onThere = onThere
end

function UiCard:moveToThenHide(x, y)
	self:setHoldPos(x, y, function(self) self._hidden = true end)
end

function UiCard:setPos(x, y)
	self.x, self.y = x, y
	self.ax, self.ay = self.x, self.y
end

function UiCard:destroy()
	UiCard.super.destroy(self)
	if self._tickNode then
		self._tickNode:remove()
	end
end

function UiCard:update(dt)
	if not self.drag then
		self.ax = self.ax + (self.hx - self.ax) * 6 * dt
		self.ay = self.ay + (self.hy - self.ay) * 6 * dt

		self.x = math.floor(self.ax + 0.5)
		self.y = math.floor(self.ay + 0.5)
		if self.x == self.hx and self.y == self.hy and self.onThere then
			self.onThere(self)
			self.onThere = nil
		end
	end
end

function UiCard:_draw()
	local lg = love.graphics
	lg.setColor(0, 0, 0)
	lg.rectangle("fill", 0, 0, self.w, self.h)
	lg.setColor(1, 1, 1)
	lg.rectangle("line", 0, 0, self.w, self.h)

	lg.setFont(fonts.normal)
	lg.print(self.card.title, 4, 4)

	UiCard.super._draw(self)
end

function UiCard:onMouseDown(x, y, ...)
	if self.onThere then return end
	self.drag = self:isInside(x, y)
	return self.drag or UiCard.super.onMouseDown(self, x, y, ...)
end

function UiCard:onMouseUp(...)
	if self.onThere then return end
	self.drag = false
	return UiCard.super.onMouseUp(self, ...)
end

function UiCard:onMouseMove(x, y, dx, dy)
	if self.drag then
		self.x = self.x + dx
		self.y = self.y + dy
		self.ax, self.ay = self.x, self.y
	end
	return UiCard.super.onMouseMove(self, x, y, dx, dy)
end