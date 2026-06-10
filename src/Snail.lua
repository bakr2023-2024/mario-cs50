Snail = Class({ __includes = Entity })

function Snail:init(def)
	Entity.init(self, def)
end
function Snail:render()
	love.graphics.draw(
		textures[self.texture],
		frames[self.texture][self.currentAnimation:getCurrentFrame()],
		math.floor(self.x) + self.width2,
		math.floor(self.y) + self.height2,
		0,
		self.direction == "left" and 1 or -1,
		1,
		self.width2,
		self.height2
	)
end
