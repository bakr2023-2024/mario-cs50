PlayerFallingState = Class({ __includes = BaseState })

function PlayerFallingState:init(player, gravity)
	self.player = player
	self.gravity = gravity
	self.animation = Animation({
		frames = { 3 },
		interval = 1,
	})
	self.player.currentAnimation = self.animation
end

function PlayerFallingState:update(dt)
	self.player.currentAnimation:update(dt)
	self.player.dy = self.player.dy + self.gravity * dt
	self.player.y = self.player.y + (self.player.dy * dt)

	local bottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
	local bottomRight =
		self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)
	if (bottomLeft and bottomRight) and (bottomLeft:collidable() or bottomRight:collidable()) then
		self.player.dy = 0
		if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
			self.player:changeState("walking")
		else
			self.player:changeState("idle")
		end
		self.player.y = (bottomLeft.y - 1) * TILE_SIZE - self.player.height
	elseif self.player.y > VH then
		sounds["death"]:play()
		gsm:change("start")
	elseif love.keyboard.isDown("left") then
		self.player.direction = "left"
		self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
		self.player:checkLeftCollisions(dt)
	elseif love.keyboard.isDown("right") then
		self.player.direction = "right"
		self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
		self.player:checkRightCollisions(dt)
	end
	local objects = self.player.level.objects
	for i = #objects, 1, -1 do
		local object = objects[i]
		if object:collides(self.player) then
			if object.solid then
				self.player.dy = 0
				self.player.y = object.y - self.player.height
				if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
					self.player:changeState("walking")
				else
					self.player:changeState("idle")
				end
			elseif object.consumable then
				object.onConsume(self.player)
				table.remove(objects, i)
			end
		end
	end
	local entities = self.player.level.entities
	for i = #entities, 1, -1 do
		local entity = entities[i]
		if entity:collides(self.player) then
			sounds["kill"]:play()
			sounds["kill2"]:play()
			self.player.score = self.player.score + SNAIL_SCORE
			table.remove(self.player.level.entities, i)
		end
	end
end
