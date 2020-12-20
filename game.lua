local Scene = require "world.scene"
local Dialog = require "dialog"
local State = require "gamestate"
local game = {}

local vision_opts = require "torch"

_G.Say = function(dialog, props)
	Moan.speak({dialog[1], {1, 0.8, 0.5}}, {dialog[2]}, props)
end

local current_scene
function game.load()
	local house = require "world.house"
	house.load()
	current_scene = Scene()
end

function game.draw()
	current_scene:draw()
end

function game.ui_layer()
	current_scene:ui_layer()
end

function game.update(dt)
	Dialog:update()
	current_scene:update(dt)
	vision_opts.radius = vision_opts.radius + vision_opts.dr
	if vision_opts.radius > vision_opts.max or vision_opts.radius < vision_opts.min then
		vision_opts.dr = vision_opts.dr * -1
	end
end

function game.shade(shader)
	local player_pos = current_scene:player_screen_coords()
	shader:send("los_center", {player_pos.x, player_pos.y})
	shader:send("los_radius", vision_opts.radius)
	shader:send("los_on", vision_opts.on)

end

function love.keypressed(key)
	if key == "q" then
		vision_opts:toggle()
	end
end

return game
