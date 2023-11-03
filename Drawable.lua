require "Class"
require "Collision"
require "UiObject"

local lg = love.graphics

UiObject:newClass("DrawableBase")

function DrawableBase:init(config)
	DrawableBase.super.init(self, config)

	if config.parent then
		config.parent:addDrawable(self)
	end
end

function DrawableBase:destroy()
	if self._uiParent then
		self._uiParent:removeDrawable(self)
	end
end

function DrawableBase:draw()
	if self._hidden then return end

	lg.push()
	lg.translate(self.x, self.y)
	self._lastWorld = { lg.transformPoint(0, 0) }
	self:_draw()
	lg.pop()
end

-- function DrawableBase:_draw()

-------------------------------------
-- DrawableObj, i.e drawable that from one of the base löve objects

DrawableBase:newClass("DrawableObj")

function DrawableObj:init(obj, config)
	DrawableObj.super.init(self, config)
	self.obj = obj
end

function DrawableObj:destroy()
	DrawableObj.super.destroy(self)
	self.obj:release()
	self.obj = nil
end

function DrawableObj:__gc()
	if self.obj then
		self:destroy()
	end
end

function DrawableObj:_draw()
	if self.color then
		lg.setColor(self.color)
	end
	lg.draw(self.obj)
end

-------------------------------------

align = align or {}
align.right = "right"
align.center = "center"
align.left = "left"

DrawableObj:newClass("Text")

function Text:init(config)
	default(config, {font = fonts.normal, text = "", color = {1,1,1}})
	if type(config.keepW) == "number" then
		config.w = config.keepW
	end
	if type(config.keepH) == "number" then
		config.h = config.keepH
	end

	Text.super.init(self, lg.newText(config.font), config)

	self.keepW = config.keepW or config.keepSize
	self.keepH = config.keepH or config.keepSize
	self._align = config.align or align.left
	self.color = config.color

	self:setText(config.text)
end

function Text:setText(text, keepSize)
	self._textData = text
	if keepSize or self.keepW then
		self.obj:setf(text, self.w, self._align)
	else
		self.obj:set(text)
	end

	if not keepSize then
		self:makeFit()
	end
end

function Text:setTextid(textId, keepSize)
	-- TODO!
	
	self._textData = text
	if keepSize or self.keepW then
		self.obj:setf(text, self.w, self._align)
	else
		self.obj:set(text)
	end

	if not keepSize then
		self:makeFit()
	end
end

function Text:setAlign(align)
	assert(align[align])
	if align == self._align then return end

	self._align = align
	if self.keepW then
		self:setText(self._textData)
	end
end

function Text:makeFit()
	local ow, oh = self.w, self.h

	local w, h = self.obj:getDimensions()
	self.w = self.keepW and self.w or w
	self.h = self.keepH and self.h or h
end
