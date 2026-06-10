GameObject = Class()

function GameObject:init(def)
	self.x, self.y = def.x, def.y
	self.width, self.height = def.width, def.height
	self.texture, self.frame = def.texture, def.frame
	self.solid = def.solid
	self.collidable = def.collidable
	self.consumable = def.consumable
	self.onCollide = def.onCollide
	self.onConsume = def.onConsume
	self.hit = def.hit
end

function GameObject:collides(target)
	return not (
		target.x > self.x + self.width
		or self.x > target.x + target.width
		or target.y > self.y + self.height
		or self.y > target.y + target.height
	)
end

function GameObject:update(dt) end

function GameObject:render()
	love.graphics.draw(textures[self.texture], frames[self.texture][self.frame], self.x, self.y)
end
