require "Class"
require "Collision"
require "Table"

Class:newClass("UiObject")

function UiObject:init(config)
	config = default(config, {
		x = 0, y = 0,
		w = 0, h = 0,
	})
	self.x = config.x
	self.y = config.y
	self.w = config.w
	self.h = config.h
end

--- function UiObject:draw()
--- function UiObject:destroy()

-------------------------------------
-- Position/size

function UiObject:getSize()
	return self.w, self.h
end

function UiObject:setSize(w, h)
	self.w = w or self.w
	self.h = h or self.h
end

function UiObject:allowInput()
	return false
end

function UiObject:setPosAligned(x, y, xAlign, yAlign)
	x = x or (xAlign and self.x)
	if x then
		self.x = x - self.w * xAlign
	end
	y = y or (yAlign and self.y)
	if y then
		self.y = y - self.h * yAlign
	end
end

function UiObject:setCenter(x, y)
	self.x = x - self.w * 0.5
	self.y = y - self.h * 0.5
end

function UiObject:setCenterX(x)
	self.x = x - self.w * 0.5
end

function UiObject:setCenterY(y)
	self.y = y - self.h * 0.5
end

-- left top right bottom
function UiObject:getSides()
	return self.x, self.y, self.x + self.w, self.y + self.h
end

-------------------------------------
-- Collision

function UiObject:isInside(x, y)
	return rect.inside(self, x, y)
end

-- function UiObject:distance(x, y)
-- 	return math.sqrt( vector.distSq(x, y, self:center()) )
-- end

-- function UiObject:distSq(x, y)
-- 	return vector.distSq(x, y, self:center())
-- end

-- From parent to local
function UiObject:translatePoint(x, y)
	return x - self.x, y - self.y
end

function UiObject:center()
	return self.x + self.w * .5, self.y + self.h * .5
end

