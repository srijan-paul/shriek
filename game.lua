local Scene = require "world.scene"
local Dialog = require "dialog"
local GameState = require "gamestate"
local Intro = require "world.intro"
local game = {
	shading = false
}

local vision_opts = require "torch"

_G.Say = function(dialog, props)
	Moan.speak({dialog[1], YELLOW}, {dialog[2]}, props)
end

_G.RSay = function (dialog, props)
	Moan.speak({dialog[1], L_RED}, {dialog[2]}, props)
end

_G.Speak = Moan.speak

function game.load()
	local house = require "world.house"
	house.load()
	game.shading = true
	game.current_scene = Scene()
	GameState.game = game
end

function game.start()
	game.shading = true
	game.current_scene = Scene()
end

function game.draw()
	game.current_scene:draw()
end

function game.ui_layer()
	game.current_scene:ui_layer()
end

function game.update(dt)
	Dialog:update()
	game.current_scene:update(dt)
	vision_opts.radius = vision_opts.radius + vision_opts.dr
	if vision_opts.radius > vision_opts.max or vision_opts.radius < vision_opts.min then
		vision_opts.dr = vision_opts.dr * -1
	end
end

function game.shade(shader)
	local player_pos = game.current_scene:player_screen_coords()
	shader:send("los_center", {player_pos.x, player_pos.y})
	shader:send("los_radius", vision_opts.radius)
	shader:send("los_on", vision_opts.on)
end

function love.keypressed(key)
	game.current_scene:keypressed(key)
	if key == "q" and GameState.events.torch_found then
		vision_opts:toggle()
	end
end

function game.set_scene(s)
	game.current_scene = s
end

return game
