local Room = require "world.room"
local game = {}

local VISION_MIN = 150.0
local VISION_MAX = 170.0
local vision_radius = VISION_MIN
local vision_dr = 0.25

local room
function game.load()
	room = Room()
end

function game.draw()
	room:draw()
end

function game.update(dt)
	room:update(dt)
	vision_radius = vision_radius + vision_dr
	if vision_radius > VISION_MAX or vision_radius < VISION_MIN then
		vision_dr = vision_dr * -1
	end
end

function game.shade(shader)
	local player_pos = room:player_screen_coords()
	local vec2 = {player_pos.x, player_pos.y}
	shader:send("LoS_center", vec2)
	shader:send("LoS_radius", vision_radius)
end

return game
