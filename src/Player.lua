Player = Class({ __includes = Entity })
function Player:init(def)
	Entity.init(self, def)
	self.score = def.score -- keep track of total score
	self.invincible = false -- check if player is invincible or not
	-- particle system to visually indicate invincible state
	self.pSystem = love.graphics.newParticleSystem(textures["particle"], 32)
	self.pSystem:setParticleLifetime(2, 4)
	self.pSystem:setEmissionRate(5)
	self.pSystem:setLinearAcceleration(-20, -20, 20, 20)
	self.pSystem:setColors(1, 0, 1, 0.75, 1, 0.752, 0.796, 0)
end
function Player:update(dt)
	Entity.update(self, dt)
	if self.invincible then
		self.pSystem:update(dt)
	end
end
function Player:checkLeftCollisions(dt)
	local topLeft = self.map:pointToTile(self.x + 1, self.y + 1)
	local bottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height - 1)
	if (topLeft and bottomLeft) and (topLeft:collidable() or bottomLeft:collidable()) then
		self.x = (topLeft.x - 1) * TILE_SIZE + topLeft.width - 1
	else
		self.y = self.y - 1
		local collidedObjects = self:checkObjectCollisions()
		self.y = self.y + 1
		if #collidedObjects > 0 then
			self.x = self.x + PLAYER_WALK_SPEED * dt
		end
	end
end

function Player:checkRightCollisions(dt)
	local topRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
	local bottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)
	if (topRight and bottomRight) and (topRight:collidable() or bottomRight:collidable()) then
		self.x = (topRight.x - 1) * TILE_SIZE - self.width
	else
		self.y = self.y - 1
		local collidedObjects = self:checkObjectCollisions()
		self.y = self.y + 1
		if #collidedObjects > 0 then
			self.x = self.x - PLAYER_WALK_SPEED * dt
		end
	end
end

function Player:checkObjectCollisions()
	local collided = {}
	for i = #self.level.objects, 1, -1 do
		local object = self.level.objects[i]
		if object:collides(self) then
			if object.solid then
				table.insert(collided, object)
			elseif object.consumable then
				object.onConsume(self, object)
				table.remove(self.level.objects, i)
			end
		end
	end
	return collided
end

function Player:checkLadderOverlapping()
	local playerLeft, playerRight = self.x + 1, self.x + self.width - 1
	local playerDown = self.y + self.height
	for i, object in ipairs(self.level.objects) do
		if object.texture == "ladders" then
			if
				playerLeft >= object.x
				and playerRight <= object.x + object.width
				and playerDown >= object.y
				and playerDown <= object.y + object.height
			then
				return object
			end
		end
	end
	return nil
end

function Player:render()
	Entity.render(self)
	-- render particle system only if in invincible state
	if self.invincible then
		love.graphics.draw(self.pSystem, self.x + self.width2, self.y + self.height2)
	end
end
