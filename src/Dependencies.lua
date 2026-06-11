require("src.constants")
require("src.Utils")

push = require("lib.push")
Class = require("lib.class")
require("src.StateMachine")

require("src.states.BaseState")

require("src.states.entity.PlayerFallingState")
require("src.states.entity.PlayerIdleState")
require("src.states.entity.PlayerWalkingState")
require("src.states.entity.PlayerJumpState")
require("src.states.entity.PlayerLadderClimbingState")

require("src.states.entity.snail.SnailChasingState")
require("src.states.entity.snail.SnailIdleState")
require("src.states.entity.snail.SnailMovingState")

require("src.states.game.StartState")
require("src.states.game.PlayState")

require("src.Animation")
require("src.Entity")
require("src.Player")
require("src.Snail")
require("src.GameObject")
require("src.Tile")
require("src.TileMap")
require("src.GameLevel")
require("src.LevelMaker")

sounds = {
	["jump"] = love.audio.newSource("sounds/jump.wav", "static"),
	["death"] = love.audio.newSource("sounds/death.wav", "static"),
	["music"] = love.audio.newSource("sounds/music.wav", "static"),
	["powerup-reveal"] = love.audio.newSource("sounds/powerup-reveal.wav", "static"),
	["pickup"] = love.audio.newSource("sounds/pickup.wav", "static"),
	["empty-block"] = love.audio.newSource("sounds/empty-block.wav", "static"),
	["kill"] = love.audio.newSource("sounds/kill.wav", "static"),
	["kill2"] = love.audio.newSource("sounds/kill2.wav", "static"),
}

textures = {
	["tiles"] = love.graphics.newImage("graphics/tiles.png"),
	["toppers"] = love.graphics.newImage("graphics/tile_tops.png"),
	["bushes"] = love.graphics.newImage("graphics/bushes_and_cacti.png"),
	["jump-blocks"] = love.graphics.newImage("graphics/jump_blocks.png"),
	["gems"] = love.graphics.newImage("graphics/gems.png"),
	["backgrounds"] = love.graphics.newImage("graphics/backgrounds.png"),
	["green-alien"] = love.graphics.newImage("graphics/green_alien.png"),
	["creatures"] = love.graphics.newImage("graphics/creatures.png"),
	['keys_and_locks'] = love.graphics.newImage("graphics/keys_and_locks.png"),
	['flags'] = love.graphics.newImage('graphics/flags.png'),
	['ladders_and_signs'] = love.graphics.newImage('graphics/ladders_and_signs.png')
}

frames = {
	["tiles"] = GenerateQuads(textures["tiles"], TILE_SIZE, TILE_SIZE),
	["toppers"] = GenerateQuads(textures["toppers"], TILE_SIZE, TILE_SIZE),
	["bushes"] = GenerateQuads(textures["bushes"], 16, 16),
	["jump-blocks"] = GenerateQuads(textures["jump-blocks"], 16, 16),
	["gems"] = GenerateQuads(textures["gems"], 16, 16),
	["backgrounds"] = GenerateQuads(textures["backgrounds"], 256, 128),
	["green-alien"] = GenerateQuads(textures["green-alien"], 16, 20),
	["creatures"] = GenerateQuads(textures["creatures"], 16, 16),
	['keys_and_locks'] = GenerateQuads(textures['keys_and_locks'],16,16),
	['flags'] = GenerateQuads(textures['flags'],16,16),
	['ladders_and_signs'] = GenerateQuads(textures['ladders_and_signs'],16,16)
}
frames["tileSets"] =
	GenerateTileSetsQuads(frames["tiles"], TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)
frames["topperSets"] =
	GenerateTileSetsQuads(frames["toppers"], TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

fonts = {
	["small"] = love.graphics.newFont("fonts/font.ttf", 8),
	["medium"] = love.graphics.newFont("fonts/font.ttf", 16),
	["large"] = love.graphics.newFont("fonts/font.ttf", 32),
	["title"] = love.graphics.newFont("fonts/ArcadeAlternate.ttf", 32),
}
