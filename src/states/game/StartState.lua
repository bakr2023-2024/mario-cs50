StartState = Class({ __includes = BaseState })

function StartState:init()
	self.map = LevelMaker.generate(100, 10)
	self.background = math.random(3)
end

function StartState:update(dt)
	if love.keyboard.active["enter"] or love.keyboard.active["return"] then
		gsm:change("play")
	end
end

function StartState:render()
	love.graphics.draw(textures["backgrounds"], frames["backgrounds"][self.background], 0, 0)
	love.graphics.draw(
		textures["backgrounds"],
		frames["backgrounds"][self.background],
		0,
		textures["backgrounds"]:getHeight() / 3 * 2,
		0,
		1,
		-1
	)
	self.map:render()

	love.graphics.setFont(fonts["title"])
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.printf("Super 50 Bros.", 1, VH2 - 40 + 1, VW, "center")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("Super 50 Bros.", 0, VH2 - 40, VW, "center")

	love.graphics.setFont(fonts["medium"])
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.printf("Press Enter", 1, VH2 + 17, VW, "center")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("Press Enter", 0, VH2 + 16, VW, "center")
end
