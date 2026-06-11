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

	for k, entity in pairs(self.player.level.entities) do
		if entity:collides(self.player) then
			gsm:change("start")
		end
	end
end
