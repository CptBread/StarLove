require "UiPanel"

local lg = love.graphics

UiPanel:newClass("Button")

function Button:init(config)
	config.input = true
	Button.super.init(self, config)
	self._hover = false
	self.trigger = config.trigger or self.trigger
end

function Button:onMouseUp(x, y, button)
	if not self:isInside(x, y) then return end

	if self.trigger then
		self:trigger()
		return true
	end
end

function Button:onMouseMove( x, y )
	local inside = self:isInside(x, y)
	if inside ~= self._hover then
		self._hover = inside
		self:_hoverChanged()
	end
end

function Button:_hoverChanged()
end

-- Text button
Button:newClass("TextButton")

function TextButton:init(config)
	config = default(config, {
		text = "",
		font = fonts.normal,
		textColor = {1, 1, 1},
		hoverTextColor = {0.6, 0.6, 0.6},
	})

	TextButton.super.init(self, config)

	self.textColor = config.textColor
	self.hoverTextColor = config.hoverTextColor

	self._text = self:newText( config.font, config.text )
	-- Custom drawing of text
	self._text.draw = function() end

	self:setSize(self._text:getSize())
end

function TextButton:setText(text, keep_size)
	text = text or ""
	self._text:setText(text, keep_size)
	self:setSize(self._text:getSize())
end

function TextButton:_draw()
	-- if self._hover then
	-- 	love.graphics.setColor(0.5, 1, 1, 0.3)
	-- 	love.graphics.rectangle("fill", 0, 0, self.w, self.h)
	-- end
	if self._text then
		local color = self._hover and self.hoverTextColor or self.textColor

		lg.setColor(unpack(color))
		lg.draw(self._text.obj)
	end
end

-- Text button
TextButton:newClass("SimpleButton")

function SimpleButton:init(config)
	config = default(config, {
		backColor = {0.5, 0.5, 0.5},
		hoverBackColor = {0.3, 0.3, 0.3},
		hoverTextColor = config.textColor or {1, 1, 1},
	})
	SimpleButton.super.init(self, config)

	self.backColor = config.backColor
	self.hoverBackColor = config.hoverBackColor
end

function SimpleButton:_draw()
	local color = self._hover and self.hoverBackColor or self.backColor
	lg.setColor(unpack(color))
	lg.rectangle("fill", 0, 0, self.w, self.h)

	SimpleButton.super._draw(self)
end