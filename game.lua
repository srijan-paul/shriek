local Room = require "world.room"
local Dialog = require "dialog"
local game = {}

local VISION_MIN = 150.0
local VISION_MAX = 170.0
local vision_radius = VISION_MIN
local vision_dr = 0.25

_G.Say = function(dialog)
	Moan.speak({dialog[1], {1, 0.8, 0.5}}, {dialog[2]})
end

local room
function game.load()
	room = Room()
end

function game.draw()
	room:draw()
end

function game.ui_layer()
	room:ui_layer()
end

function game.update(dt)
	Dialog:update()
	room:update(dt)
	vision_radius = vision_radius + vision_dr
	if vision_radius > VISION_MAX or vision_radius < VISION_MIN then
		vision_dr = vision_dr * -1
	end
end

function game.shade(shader)
	local player_pos = room:player_screen_coords()
	shader:send("los_center", {player_pos.x, player_pos.y})
	shader:send("los_radius", vision_radius)
end

return game
