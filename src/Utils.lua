function GenerateQuads(atlas, tw, th)
	local sw, sh = atlas:getWidth() / tw, atlas:getHeight() / th
	local quads = {}
	for y = 0, sh - 1 do
		for x = 0, sw - 1 do
			table.insert(quads, love.graphics.newQuad(x * tw, y * th, tw, th, atlas))
		end
	end
	return quads
end

function GenerateTileSetsQuads(quads, setsWide, setsTall, setWidth, setHeight)
	local sheetW = setsWide * setWidth
	local tiles = {}
	local tileSetCounter = 1
	for tileSetY = 1, setsTall do
		for tileSetX = 1, setsWide do
			table.insert(tiles, {})
			for tileY = setHeight * (tileSetY - 1) + 1, setHeight * (tileSetY - 1) + 1 + setHeight do
				for tileX = setWidth * (tileSetX - 1) + 1, setWidth * (tileSetX - 1) + 1 + setWidth do
					table.insert(tiles[tileSetCounter], quads[sheetW * (tileY - 1) + tileX])
				end
			end
			tileSetCounter = tileSetCounter + 1
		end
	end
	return tiles
end
