PlayerIdleState = Class({ __includes = BaseState })

function PlayerIdleState:init(player)
	self.player = player
	self.animation = Animation({
		frames = { 1 },
		interval = 1,
	})
	self.player.currentAnimation = self.animation
end

function PlayerIdleState:update(dt)
	-- check if a ladder exists and up key is pressed to transition to ladder climbing state
	local ladder = self.player:checkLadderOverlapping()
	if ladder and love.keyboard.active["up"] then
		self.player:changeState("climbing")
	end

	if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
		self.player:changeState("walking")
	end

	if love.keyboard.active["space"] then
		self.player:changeState("jump")
	end

	local entities = self.player.level.entities
	for i = #entities, 1, -1 do
		local entity = entities[i]
		if entity:collides(self.player) then
			-- if player is invincible, destroy enemy and increase player's score else go back to start
			if self.player.invincible then
				self.player.score = self.player.score + SNAIL_SCORE
				table.remove(self.player.level.entities, i)
			else
				gsm:change("start")
			end
		end
	end
end
