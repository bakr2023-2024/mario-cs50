Player = Class({ __includes = Entity })

function Player:init(def)
	Entity.init(self, def)
	self.score = 0
end

function Player:checkLeftCollisions(dt)
	local topLeft = self.map:pointToTile(self.x + 1, self.y + 1)
	local bottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height - 1)
	if (topLeft and bottomLeft) and (topLeft:collidable() and bottomLeft:collidable()) then
		self.x = (topLeft.x - 1) * TILE_SIZE + topLeft.width - 1
	end
	self.y = self.y - 1
	local collidedObjects = self:checkObjectCollisions()
	self.y = self.y + 1
	if #collidedObjects > 0 then
		self.x = self.x + PLAYER_WALK_SPEED * dt
	end
end

function Player:checkRightCollisions(dt)
	local topRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
	local bottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)
	if (topRight and bottomRight) and (topRight:collidable() and bottomRight:collidable()) then
		self.x = (topRight.x - 1) * TILE_SIZE - self.width
	end
	self.y = self.y - 1
	local collidedObjects = self:checkObjectCollisions()
	self.y = self.y + 1
	if #collidedObjects > 0 then
		self.x = self.x - PLAYER_WALK_SPEED * dt
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
