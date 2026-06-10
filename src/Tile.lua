Tile = Class()

function Tile:init(x, y, id, topper, tileSet, topperSet)
	self.x, self.y = x, y
	self.width, self.height = TILE_SIZE, TILE_SIZE
	self.id = id
	self.tileSet = tileSet
	self.topper = topper
	self.topperSet = topperSet
end

function Tile:collidable()
	for i, id in ipairs(COLLIDABLE_TILES) do
		if id == self.id then
			return true
		end
	end
	return false
end

function Tile:render()
	love.graphics.draw(
		textures["tiles"],
		frames["tileSets"][self.tileSet][self.id],
		(self.x - 1) * TILE_SIZE,
		(self.y - 1) * TILE_SIZE
	)

	if self.topper then
		love.graphics.draw(
			textures["toppers"],
			frames["topperSets"][self.topperSet][self.id],
			(self.x - 1) * TILE_SIZE,
			(self.y - 1) * TILE_SIZE
		)
	end
end
