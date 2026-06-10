SnailChasingState = Class({ __includes = BaseState })

function SnailChasingState:init(tileMap, player, snail)
	self.tileMap = tileMap
	self.player = player
	self.snail = snail
	self.animation = Animation({
		frames = { 49, 50 },
		interval = 0.5,
	})
	self.snail.currentAnimation = self.animation
end

function SnailChasingState:update(dt)
	self.snail.currentAnimation:update(dt)
	local diffX = math.abs(self.player.x - self.snail.x)
	if diffX > 5 * TILE_SIZE then
		self.snail:changeState("moving")
	elseif self.player.x < self.snail.x then
		self.snail.direction = "left"
		self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt

		local left = self.tileMap:pointToTile(self.snail.x, self.snail.y)
		local bottomLeft = self.tileMap:pointToTile(self.snail.x, self.snail.y + self.snail.height)

		if (left and bottomLeft) and (left:collidable() or not bottomLeft:collidable()) then
			self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt
		end
	else
		self.snail.direction = "right"
		self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt

		local right = self.tileMap:pointToTile(self.snail.x + self.snail.width, self.snail.y)
		local bottomRight = self.tileMap:pointToTile(self.snail.x + self.snail.width, self.snail.y + self.snail.height)

		if (right and bottomRight) and (right:collidable() or not bottomRight:collidable()) then
			self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt
		end
	end
end
