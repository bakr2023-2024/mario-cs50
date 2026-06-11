PlayerLadderClimbingState = Class({ __includes = BaseState })

function PlayerLadderClimbingState:init(player)
	self.player = player
	self.animation = Animation({
		frames = { 6, 7 },
		interval = 0.1,
	})
	self.player.currentAnimation = self.animation
end

function PlayerLadderClimbingState:enter()
	self.player.dy = 0
end

function PlayerLadderClimbingState:update(dt)
	local ladder = self.player:checkLadderOverlapping()
	if ladder then
        -- if up key is held and there is a ladder block, the player moves up
        if love.keyboard.isDown("up") then
			self.player.currentAnimation:update(dt)
			self.player.y = self.player.y - PLAYER_CLIMB_SPEED * dt
        -- player can jump instead while half-way climbing
		elseif love.keyboard.active["space"] then
			self.player:changeState("jump")
		end
	else
        -- when the player is at top of ladder they can jump or walk to transition to jump or walk states respectively
		if love.keyboard.active["space"] then
			self.player:changeState("jump")
		elseif love.keyboard.active["left"] or love.keyboard.active["right"] then
			self.player:changeState("walking")
		end
	end
end
