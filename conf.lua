local GameInfo = {name = "--Title of game--", VERSION_STRING = "0.0.1"}

_G.Timer = require("lib/vrld/timer")
_G.Vec2 = require("lib/vector2")
_G.class = require("lib/middleclass/middleclass")
_G.random = math.random
_G.sugar = require("lib/sugar")
-- _G.ECS = require("lib/concord")

-- Direction enum, very common in games.
_G.Direction = {LEFT = 1, RIGHT = 2, UP = 3, DOWN = 4}

function Direction.random()
	return Direction[random(1, 4)]
end

function Direction.opposite(dir)
	if dir == Direction.LEFT then
		return Direction.RIGHT
	end
	if dir == Direction.RIGHT then
		return Direction.LEFT
	end
	if dir == Direction.UP then
		return Direction.DOWN
	end
	if dir == Direction.DOWN then
		return Direction.UP
	end
end

function Direction.string(dir)
	local dir_strs = {"left", "right", "up", "down"}
	return dir_strs[dir]
end

_G.GameSettings = {fullscreen = false}
_G.DISPLAY_WIDTH = 800
_G.DISPLAY_HEIGHT = 600

function love.conf(t)
	t.window.fullscreen = GameSettings.fullscreen
	t.window.title = GameInfo.name
	t.console = true

	return t
end
