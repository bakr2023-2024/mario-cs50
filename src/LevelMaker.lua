LevelMaker = Class()
local rand = math.random
function LevelMaker.generate(width, height)
	local timer = require("lib.knife.timer")
	local tiles = {}
	local objects = {}
	local entities = {}
	local tileSet, topperSet = rand(#frames["tileSets"]), rand(#frames["topperSets"])
	-- key spaws at random X location and lock spawns after it
	local keySpawnX = rand(30, width - 30)
	local lockSpawnX = keySpawnX + 10
	local keyColor = rand(4)
	local keyFound = false
	for y = 1, height do
		table.insert(tiles, {})
		for x = 1, width do
			table.insert(tiles[y], Tile(x, y, TILE_ID_EMPTY, false, tileSet, topperSet))
		end
	end
	for x = 1, width do
		if x == width - 1 then
			for y = 7, height do
				tiles[y][x] = Tile(x, y, TILE_ID_GROUND, y == 7, tileSet, topperSet)
			end
		elseif rand(20) == 1 and x > 2 and x < width - 2 then
			for nx = x - 1, x + 1 do
				for y = nx == x and 3 or 7, height do
					tiles[y][x] = Tile(x, y, TILE_ID_GROUND, y == 3, tileSet, topperSet)
				end
			end
			createLadders(objects, x, 3)
		elseif rand(7) ~= 1 then
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
			if x == keySpawnX then
				-- key is consumable and collidable, taking it sets keyFound flag to true
				objects[#objects + 1] = GameObject({
					texture = "keys_and_locks",
					x = (x - 1) * TILE_SIZE,
					y = (blockHeight - 1) * TILE_SIZE,
					width = 16,
					height = 16,
					frame = keyColor,
					collidable = true,
					consumable = true,
					onConsume = function(player, obj)
						keyFound = true
					end,
				})
			elseif x == lockSpawnX then
				-- lock is collidable but can only be unlocked when keyFound is true, when unlocked spawn the goal post at width - 1
				local lockX = (x - 1) * TILE_SIZE
				local lockY = (blockHeight - 1) * TILE_SIZE
				local lock
				lock = GameObject({
					texture = "keys_and_locks",
					x = lockX,
					y = lockY,
					width = 16,
					height = 16,
					frame = keyColor + 4,
					collidable = true,
					consumable = false,
					solid = true,
					onCollide = function(object)
						if keyFound then
							for i, obj in ipairs(objects) do
								if obj == lock then
									table.remove(objects, i)
									break
								end
							end
							spawnGoalPost(objects, width - 1)
						end
					end,
				})
				table.insert(objects, lock)
			elseif rand(15) == 1 then
				objects[#objects + 1] = GameObject({
					texture = "jump-blocks",
					x = (x - 1) * TILE_SIZE,
					y = (blockHeight - 1) * TILE_SIZE,
					width = 16,
					height = 16,
					frame = rand(#JUMP_BLOCKS),
					collidable = true,
					hit = false,
					solid = true,
					onCollide = function(obj)
						if not obj.hit then
							if rand(5) == 1 then
								local gem = GameObject({
									texture = "gems",
									x = (x - 1) * TILE_SIZE,
									y = (blockHeight - 1) * TILE_SIZE - 4,
									width = 16,
									height = 16,
									frame = rand(#GEMS),
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
function createLadders(objects, x, y)
	for ny = y, y + 3 do
		-- left of pillar
		objects[#objects + 1] = GameObject({
			texture = "ladders_and_signs",
			frame = ny == y and 1 or 8, -- upper or lower part of ladder
			x = ((x - 1) - 1) * TILE_SIZE,
			y = (ny - 1) * TILE_SIZE,
			width = 16,
			height = 16,
			collidable = false,
			consumable = false,
			solid = false,
		})
		-- right of pillar
		objects[#objects + 1] = GameObject({
			texture = "ladders_and_signs",
			frame = ny == y and 1 or 8, -- upper or lower part of ladder
			x = ((x - 1) + 1) * TILE_SIZE,
			y = (ny - 1) * TILE_SIZE,
			width = 16,
			height = 16,
			collidable = false,
			consumable = false,
			solid = false,
		})
	end
end
-- callback used by the flag consumables, touching the flag sends the player to next level
function touchFlag(player, obj)
	if player.x + player.width >= player.map.width then
		-- pass player score and 10% increased width from current level to next level
		gsm:change("play", { width = math.floor(player.map.width * 1.1), score = player.score })
	end
end
-- add segments  of flag together to form flag pole
function spawnGoalPost(objects, endX)
	local xPos = (endX - 1) * 16
	for yPos = 1, 3 do
		objects[#objects + 1] = GameObject({
			texture = "flags",
			x = xPos,
			y = (3 + yPos - 1) * 16,
			width = 16,
			height = 16,
			frame = (yPos - 1) * 9 + 1,
			collidable = true,
			consumable = true,
			onConsume = touchFlag,
		})
	end
	objects[#objects + 1] = GameObject({
		texture = "flags",
		x = xPos + 8,
		y = (4 - 1) * 16,
		width = 16,
		height = 16,
		frame = (rand(4) - 1) * 9 + 7,
		collidable = true,
		consumable = true,
		onConsume = touchFlag,
	})
end
