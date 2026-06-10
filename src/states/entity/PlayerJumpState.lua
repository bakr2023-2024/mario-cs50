PlayerJumpState = Class({ __includes = BaseState })

function PlayerJumpState:init(player, gravity)
	self.player = player
	self.gravity = gravity
	self.animation = Animation({
		frames = { 3 },
		interval = 1,
	})
	self.player.currentAnimation = self.animation
end

function PlayerJumpState:enter()
	self.player.dy = PLAYER_JUMP_VELOCITY
end

function PlayerJumpState:update(dt)
	self.player.currentAnimation:update(dt)
	self.player.dy = self.player.dy + self.gravity * dt
	self.player.y = self.player.y + (self.player.dy * dt)

	if self.player.dy >= 0 then
		self.player:changeState("falling")
	end

	local tileLeft = self.player.map:pointToTile(self.player.x + 3, self.player.y)
	local tileRight = self.player.map:pointToTile(self.player.x + self.player.width - 3, self.player.y)

	if (tileLeft and tileRight) and (tileLeft:collidable() or tileRight:collidable()) then
		self.player.dy = 0
		self.player:changeState("falling")
	elseif love.keyboard.isDown("left") then
		self.player.direction = "left"
		self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
		self.player:checkLeftCollisions(dt)
	elseif love.keyboard.isDown("right") then
		self.player.direction = "right"
		self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
		self.player:checkRightCollisions(dt)
	end

	local prevY = self.player.y - (self.player.dy * dt)

	local objects = self.player.level.objects
	for i = #objects, 1, -1 do
		local object = objects[i]
		if object.solid then
			local prevHead = prevY
			local currHead = self.player.y
			local blockBottom = object.y + object.height
			local blockLeft = object.x
			local blockRight = object.x + object.width
			local playerLeft = self.player.x
			local playerRight = self.player.x + self.player.width
			if
				self.player.dy < 0
				and prevHead >= blockBottom
				and currHead <= blockBottom
				and playerRight > blockLeft
				and playerLeft < blockRight
			then
				object.onCollide(object)
				self.player.y = object.y + object.height
				self.player.dy = 0
				self.player:changeState("falling")
			end
		elseif object.consumable and object:collides(self.player) then
			object.onConsume(self.player)
			table.remove(self.player.level.objects, i)
		end
	end

	for i, entity in ipairs(self.player.level.entities) do
		if entity:collides(self.player) then
			gsm:change("start")
		end
	end
end
