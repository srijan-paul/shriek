local Scene = class "Scene"
local camera = require "camera"
local Player = require "prefabs.player"
local House = require "world.house"

local ZOOM = 4.0
function Scene:init()
	self.current_room = House.BedRoom
	camera:zoom(ZOOM)
	local xoff = (self.current_room.width - WIN_WIDTH / ZOOM) / 2
	local yoff = (self.current_room.height - WIN_HEIGHT / ZOOM) / 2
	camera:setPos(xoff, yoff)
	self.player = Player(self.current_room.world, 85 / 2, 93 / 2)

	Say {"You", "What was that noise just now?"}
	Say {"You", "I'm scared... I can't sleep with the lights off anymore."}

end

function Scene:draw()
	self.current_room:draw()
end

function Scene:ui_layer()
	lg.print("Objective: Find a torchlight", 10, 10)
	self.current_room:ui_layer()
end

function Scene:update(dt)
	self.current_room:update(dt)
	local input_x = Input:keydown("d") - Input:keydown("a")
	local input_y = Input:keydown("s") - Input:keydown("w")
	self.player:handle_input(input_x, input_y)
end

---returns the screen coordinates of the player
function Scene:player_screen_coords()
	return camera:toScreenPos(self.player:get_pos())
end

function Scene.MoveEntity(ent, w1, w2)

end

return Scene
