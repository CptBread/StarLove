require "Class"

Class:newClass("Rect")

function Rect:init(x, y, w, h)
	self.x = x or 0
	self.y = y or 0
	self.w = w or 0
	self.h = h or 0
end

function Rect:left()
	return self.x
end

function Rect:setLeft(x)
	self.x = x
end

function Rect:right()
	return self.x + self.w
end

function Rect:setRight(x)
	self.x = x - self.w
end

function Rect:top()
	return self.y
end

function Rect:setTop(y)
	self.y = y
end

function Rect:bottom()
	return self.y + self.h
end

function Rect:setBottom(y)
	self.y = y - self.h
end

function Rect:left()
	return self.x
end
