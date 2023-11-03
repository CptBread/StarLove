require "Table"
require "Note"
require "UiPanel"
require "Strings"
require "Util"

lg = love.graphics
world = {}
fonts = fonts or {}

function safeReload(input)
	input = input or ""
	input = input:sub(1, 4)
	hotReload(needFullReload or input:lower() == "full")
end

debugDrawPanel = false

function hotReload(full)
	-- for k,v in pairs(package.loaded) do
	-- 	if v == true then
	-- 		package.loaded[k] = nil
	-- 	end
	-- end
	print(full and "RESET" or "RELOAD", pcall(dofile, "main.lua") )

	if full then
		setup()
	end
end

function safeCall(...)
	return safe_call(safeReload, ...)
end

function setup(reset)
	love.window.setMode(1200, 960)
	Strings:setup()

	local oldRoot = root
	root = nil -- in case destroying root doesn't work
	if oldRoot then oldRoot:destroy() end

	root = Root({})
	fonts.normal = fonts.normal or love.graphics.newFont( 14 )
	fonts.monoNormal = fonts.monoNormal or love.graphics.newFont( "fonts/consola.ttf", 14 )

	-- EffectNode.owner = world.player
	needFullReload = true
	safeCall(dofile, "TestScene.lua")
	needFullReload = false
end

function love.load()
	-- Load assets
	-- Place assets
	setup()
end

function love.draw()
	lg.reset()
	root:draw()

	if draw then
		draw(dt)
	end

	lg.setColor(1, 0, 0)
	local grb = " " .. tostring(math.floor(collectgarbage("count"))) .. "Kb"
	lg.print(love.timer.getFPS()..grb, 0, 0)
	lg.setColor(1, 1, 1)

	Note.draw()
end

function love.keypressed( key, scancode, isrepeat )
	if key == "r"  then
		if love.keyboard.isDown("lctrl", "rctrl") then
			hotReload()
		elseif love.keyboard.isDown("lshift", "rshift") then
			hotReload(true)
		end
	end
end

function love.mousepressed( x, y, button, istouch, presses )
	root:onMouseDown(x, y, button)
end

function love.mousereleased( x, y, button, istouch, presses )
	root:onMouseUp(x, y, button)
end

function love.mousemoved( x, y, dx, dy, istouch )
	root:onMouseMove(x, y, dx, dy)
end

function love.update(dt)
	Note.update(dt)

	if root then
		root:update(dt)
	end

	if update then
		update(dt)
	end

	if not elapsedTime then elapsedTime = 0 end
	elapsedTime = elapsedTime + dt
	if elapsedTime > 1 then
		elapsedTime = elapsedTime - 1
		collectgarbage()
	end
end

-- Now lets stop löve from making it impossible to recover from errors
-- NOTE: Remember to add any other love callbacks here
love.load = make_safe_func( safeReload, love.load )
love.draw = make_safe_func( safeReload, love.draw )
love.keypressed = make_safe_func( safeReload, love.keypressed )
love.mousepressed = make_safe_func( safeReload, love.mousepressed )
love.mousereleased = make_safe_func( safeReload, love.mousereleased )
love.mousemoved = make_safe_func( safeReload, love.mousemoved )
love.update = make_safe_func( safeReload, love.update )