Entity = Class()

function Entity:init(def)
	self.x, self.y = def.x, def.y
	self.dx, self.dy = 0, 0
	self.width, self.height = def.width, def.height
	self.width2, self.height2 = self.width / 2, self.height / 2
	self.texture = def.texture
	self.direction = "left"
	self.stateMachine = def.stateMachine
	self.map = def.map
	self.level = def.level
end

function Entity:changeState(state, params)
	self.stateMachine:change(state, params)
end

function Entity:update(dt)
	self.stateMachine:update(dt)
end

function Entity:collides(entity)
	return not (
		self.x > entity.x + entity.width
		or entity.x > self.x + self.width
		or self.y > entity.y + entity.height
		or entity.y > self.y + self.height
	)
end

function Entity:render()
	love.graphics.draw(
		textures[self.texture],
		frames[self.texture][self.currentAnimation:getCurrentFrame()],
		math.floor(self.x) + self.width2,
		math.floor(self.y) + self.height2,
		0,
		self.direction == "left" and -1 or 1,
		1,
		self.width2,
		self.height2
	)
end
