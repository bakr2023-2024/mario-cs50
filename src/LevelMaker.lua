LevelMaker = Class()
local rand = math.random
function LevelMaker.generate(width, height)
	local timer = require("lib.knife.timer")
	local tiles = {}
	local objects = {}
	local entities = {}
	local tileSet, topperSet = rand(#frames["tileSets"]), rand(#frames["topperSets"])
	for y = 1, height do
		table.insert(tiles, {})
		for x = 1, width do
			table.insert(tiles[y], Tile(x, y, TILE_ID_EMPTY, false, tileSet, topperSet))
		end
	end
	for x = 1, width do
		if rand(7) ~= 1 then
			local blockHeight = 4
			for y = 7, height do
				tiles[y][x] = Tile(x, y, TILE_ID_GROUND, y == 7, tileSet, topperSet)
			end
			if rand(8) == 1 then
				blockHeight = 2
				if rand(8) == 1 then
					objects[#objects + 1] = GameObject({
						x = (x - 1) * TILE_SIZE,
						y = (4 - 1) * TILE_SIZE,
						width = 16,
						height = 16,
						texture = "bushes",
						frame = (rand(4) - 1) * 7 + BUSH_IDS[rand(#BUSH_IDS)],
						collidable = false,
					})
				end
				tiles[5][x].topper, tiles[5][x].id = true, TILE_ID_GROUND
				tiles[6][x].topper, tiles[6][x].id = false, TILE_ID_GROUND
				tiles[7][x].topper = false
			elseif rand(8) == 2 then
				objects[#objects + 1] = GameObject({
					x = (x - 1) * TILE_SIZE,
					y = (6 - 1) * TILE_SIZE,
					width = 16,
					height = 16,
					texture = "bushes",
					frame = (rand(4) - 1) * 7 + BUSH_IDS[rand(#BUSH_IDS)],
					collidable = false,
				})
			end
			if rand(10) == 1 then
				objects[#objects + 1] = GameObject({
					texture = "jump-blocks",
					x = (x - 1) * TILE_SIZE,
					y = (blockHeight - 1) * TILE_SIZE,
					width = 16,
					height = 16,
					frame = math.random(#JUMP_BLOCKS),
					collidable = true,
					hit = false,
					solid = true,
					onCollide = function(obj)
						if not obj.hit then
							if math.random(5) == 1 then
								local gem = GameObject({
									texture = "gems",
									x = (x - 1) * TILE_SIZE,
									y = (blockHeight - 1) * TILE_SIZE - 4,
									width = 16,
									height = 16,
									frame = math.random(#GEMS),
									collidable = true,
									consumable = true,
									solid = false,
									onConsume = function(player, object)
										player.score = player.score + GEM_SCORE
									end,
								})
								timer.tween(0.1, {
									[gem] = { y = (blockHeight - 2) * TILE_SIZE },
								})
								objects[#objects + 1] = gem
							end
							obj.hit = true
						end
					end,
				})
			end
		end
	end
	return GameLevel(entities, objects, TileMap(width, height, tiles))
end
