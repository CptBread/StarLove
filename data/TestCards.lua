require "../DefineCard"

defineCard({
	id = "test0",
	play = function()
		world.player.hp = world.player.hp + 1;
	end,
	upgrade = "test0+",
})

defineCard({
	id = "test0+",
	play = function()
		world.player.hp = world.player.hp + 10;
	end,
})

defineCard({
	id = "test1",
	play = function()
		print("HELLO THERE!");
	end,
})

defineCard({
	id = "test2",
	play = function()
		print("HELLO THERE!");
	end,
})