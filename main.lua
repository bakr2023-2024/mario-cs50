require("src.Dependencies")
function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	math.randomseed(os.time())

	gsm = StateMachine({
		["start"] = function()
			return StartState()
		end,
		["play"] = function()
			return PlayState()
		end,
	})
	gsm:change("start")
	love.window.setMode(WW, WH, { fullscreen = false, vsync = true, resizable = true })
	push:setupScreen(VW, VH, WW, WH, { fullscreen = false, resizable = true })

	love.keyboard.active = {}
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	love.keyboard.active[key] = true
end

function love.update(dt)
	gsm:update(dt)
	love.keyboard.active = {}
end

function love.draw()
	push:start()
	gsm:render()
	push:finish()
end
