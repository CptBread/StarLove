require "Class"

Class:newClass("UiPlacer")

function UiPlacer:init(x, y, xPadding, yPadding)
	self._xPadding = xPadding or 0
	self._yPadding = yPadding or 0

	x = x or 0
	y = y or 0

	self._xStart = x
	self._yStart = y

	self._left = x
	self._right = x
	self._top = y
	self._bottom = y

	self._most = {}
	self._most.left = x + self._xPadding
	self._most.right = x
	self._most.top = y + self._yPadding
	self._most.bottom = y

	self._stack = {}
	self._first = true
end

-- function UiPlacer:_padding()
-- end

function UiPlacer:addRight(item, padding)
	padding = self:_paddX(padding)
	if item then
		item.x = self._right + padding
		item.y = self._top
		self:setAtFrom(item)
	else
		return self:setAt(self._right + padding, self._top)
	end
	return item
end


-- function UiPlacer:addRightAligned(item, align, padding)
-- 	padding = self:_paddX(padding)
-- 	if item then
-- 		item.x = self.right + padding
-- 		item:setCenterY(self);
-- 		self:setAtFrom( item )
-- 	else
-- 		return self:setAt( self._right + padding, self._top )
-- 	end
-- 	return item
-- end

function UiPlacer:setAt(x, y)
	self._left = 	x or self._left
	self._right = 	x or self._right
	self._top = 	y or self._top
	self._bottom = 	y or self._bottom
	return x, y
end

function UiPlacer:setAtFrom(item)
	self:_updateMost(item:getExtent())

	if self._keep then
		if type( self._keep ) == "number" then
			self._keep = self._keep - 1
			self._keep = self._keep > 0 and self._keep or nil
		end
		return
	end
	self._left, self._top = item:lefttop()
	self._right, self._bottom = item:rightbottom()

	self._first = nil
end

function UiPlacer:_updateMost( l, t, r, b, from_branch )
	if from_branch then return end

	self._most.left = 	math.min( self._most.left, l )
	self._most.top = 	math.min( self._most.top, t )
	self._most.right = 	math.max( self._most.right, r )
	self._most.bottom = math.max( self._most.bottom, b )
end