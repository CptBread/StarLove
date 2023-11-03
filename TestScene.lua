-- require "Cards"
require "PowerSystems"
require "Button"
require "UiPowerSystem"
require "UiCard"
require "UiPile"
require "Hand"
require "DragTest"
require "World"

dofile("Data/TestCards.lua")

local lg = love.graphics

world = World()

world.hand = HandPile(nil, 10, {
	parent = root,
	x = 180, y = 300,
	w = 500,
})

local hand = world.hand


world.drawPile = DrawPile({parent = root, x = 10, y = 300})
local cardsLayer = Layer({parent = root})
world.discPile = DiscardPile({parent = root, x = 780, y = 300})

hand.playFunc = function(card, ...)
	card:playCard(...)
	hand:removeCard(card)
	card:moveToThenHide(780, 300)
	table.insert(world.discPile, card)
end

local deck = {
	Card("test0"),
	Card("test1"),
	Card("test2"),
	Card("test3"),
	Card("test4"),
	Card("test5"),
	Card("test6"),
}

for _,card in ipairs(deck) do
	hand:addCard(UiCard(card, {parent = cardsLayer}))
end

healthText = Text({parent = root, x = 10, y = 30});


scene = {}
function scene.update()
	healthText:setText(world.player.hp .. "/" .. world.player.hpMax)
end

function scene.draw()
end