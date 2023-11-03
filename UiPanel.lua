require "Class"
require "UiObject"
require "Drawable"
require "Collision"
require "Table"
require "IntrusiveList"

UiObject:newClass("UiPanel")

function Root(config)
	config = default(config, {input = true})
	local res = UiPanel(config)
	res:setRoot(res)
	res.tickList = iList("_tickNode")
	res._allowOutside = true

	function res:update(dt)
		for _,v in self.tickList:iter() do
			v:update(dt)
		end
	end

	return res
end

function Layer(config)
	config = default(config, {input = true})
	local res = UiPanel(config)
	res._allowOutside = true
	return res
end

function UiPanel:init(config)
	config = config or {}
	UiPanel.super.init(self, config)
	self._input = config.input
	self._lastWorld = {0, 0}
	self._child = iList("_node")
	self._hidden = config.hidden
	self._uiRoot = config.root

	if config.parent then
		config.parent:addChild(self)
	end
end

function UiPanel:setRoot(root)
	if self._uiRoot == root then return end

	self._uiRoot = root
	for _,v in self._child:iter() do
		if v:instanceOf(UiPanel) then		
			v:setRoot(root)
		end
	end
end

function UiPanel:addChild(child)
	self:addDrawable(child)

	child:setRoot(self._uiRoot)
end

function UiPanel:removeChild(child)
	self:removeDrawable(child)
end

function UiPanel:addDrawable(obj)
	obj._uiParent = self
	self._child:insert(obj)
end

function UiPanel:removeDrawable(obj)
	obj._uiParent = nil
	self._child:remove(obj)
end

function UiPanel:destroy()
	if self._uiParent then
		self._uiParent:removeChild(self)
	end

	for _,obj in self._child:iter() do
		obj:destroy()
	end

	self._child = nil
end

function UiPanel:__gc()
	-- Should only be nil if we're already destroyed
	if self._child then
		self:destroy()
	end
end

-------------------------------------
-- Draw
function UiPanel:draw()
	if self._hidden then return end

	local lg = love.graphics

	lg.push("all")
	lg.translate(self.x, self.y)
	local x, y = lg.transformPoint(0, 0)
	self._lastWorld = { x, y }
	if debugDrawPanel then
		lg.rectangle("line", 0, 0, self.w, self.h)
	end
	if self._allowOutside then
		lg.setScissor()
	else
		lg.intersectScissor(x, y, self.w, self.h)
	end
	self:_draw()
	lg.pop()
end

function UiPanel:drawDrawables()
	for _,obj in self._child:iter() do
		obj:draw()
	end
end

function UiPanel:_draw()
	self:drawDrawables()
end

-------------------------------------
-- Collision

function UiPanel:isInside(x, y)
	if rect.inside(self, x, y) then
		return true
	end
	if self.childrenOutside then
		x,y = self:translatePoint(x,y)
		for _,v in self._child:iter() do
			if v:isInside(x, y) then 
				return true
			end
		end
	end
end

function UiPanel:childAt(x, y)
	x,y = self:translatePoint(x,y)
	for _,v in self._child:iter() do
		if v:isInside(x, y) then 
			return v:getInside(x, y) or v
		end
	end
end

function UiPanel:findNearest(x, y, cond, best, bestDist)
	x,y = self:translatePoint(x,y)
	for _,v in self._child:iter() do
		if not cond or cond(v) then
			if v:isInside(x, y) then
				best, bestDist = v:findNearest(x, y, cond, best, bestDist)
				if not best or bestDist > -1 then
					return v, -1
				end
			end
			local distSq = v:distSq(x, y) 
			if not best or bestDist > distSq then
				best = v
				bestDist = distSq
			end
		end
		best, bestDist = v:findNearest(x, y, cond, best, bestDist)
	end
	return best, bestDist
end

-------------------------------------
-- Input

function UiPanel:allowInput()
	return self._input and not self._hidden
end

function UiPanel:onMouseDown(x, y, ...)
	if not self:allowInput() then return end

	x,y = self:translatePoint(x,y)
	for _, child in self._child:riter() do
		if child:allowInput() then
			local res = child:onMouseDown(x, y, ...)
			if res then
				return res 
			end
		end
	end
end

function UiPanel:onMouseUp(x, y, ...)
	if not self:allowInput() then return end

	x,y = self:translatePoint(x,y)
	for _, child in self._child:riter() do
		if child:allowInput() then
			local res = child:onMouseUp(x, y, ...)
			if res then 
				return res 
			end
		end
	end
end

function UiPanel:onMouseMove(x, y, ...)
	if not self:allowInput() then return end

	x,y = self:translatePoint(x,y)
	for _, child in self._child:riter() do
		if child:allowInput() then
			child:onMouseMove(x, y, ...)
		end
	end
end

function UiPanel:onKeyDown(...)
	if not self:allowInput() then return end

	for _, child in self._child:riter() do
		if child:allowInput() then
			local res = child:onKeyDown(...)
			if res then
				return res
			end
		end
	end
end

function UiPanel:onKeyUp(...)
	if not self:allowInput() then return end

	for _, child in self._child:riter() do
		if child:allowInput() then
			local res = child:onKeyUp(...)
			if res then
				return res
			end
		end
	end
end

-------------------------------------
-- Create new drawables

function UiPanel:newText(config, text)
	if config == nil or type(config) == "table" then
		config = default(config, {parent = self})
	else
		config = {font = config, text = text, parent = self}
	end
	return Text(config)
end
