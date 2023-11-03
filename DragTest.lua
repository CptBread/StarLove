require "Class"
require "UiPanel"

UiPanel:newClass("DragTest")

function DragTest:init(config)
	default(config, {input=true})
	DragTest.super.init(self, config)
	self.color = {math.random(), math.random(), math.random()}
end

function DragTest:_draw()
	local lg = love.graphics
	lg.setColor(self.color)
	lg.rectangle("fill", 0, 0, self.w, self.h)
end

function DragTest:onMouseDown(x, y, ...)
	self.drag = self:isInside(x, y)
	return self.drag or DragTest.super.onMouseDown(self, x, y, ...)
end

function DragTest:onMouseUp()
	self.drag = false
end

function DragTest:onMouseMove(x, y, dx, dy)
	if self.drag then
		self.x = self.x + dx
		self.y = self.y + dy
	end
end