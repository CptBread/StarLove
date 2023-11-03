require "Class"
require "UiPile"

Class:newClass("World")

function World:init()
	self.player = {deck={}, draw={}, discard={}, hp=5, hpMax=5}
end