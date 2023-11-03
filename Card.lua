require "Class"
require "DefineCard"

Class:newClass("Card")

function Card:init(id)
	self.req = {systems = {}}

	self.level = 1
	self.title = "title_"..id
	self.details = {
		id = "detail_"..id,
		-- args = {"damage"} TODO
	}
	self.def = card_data[id];
	if not self.def then
		print("Could not find card definition for card: '" .. id .. "'.")
	end
end

function Card:playCard(...)
	if self.def then
		self.def.play(...)
	end
end

function Card:drawCard(table)
end

function Card:discardCard() -- Params?
end

function Card:__gc()
	print("CG!!! Card")
end

-- As in can be shuffled into draw pile
function Card:canAdd()
	return true
end