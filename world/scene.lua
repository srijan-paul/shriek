local Scene = class "Scene"
local camera = require "camera"
local Player = require "prefabs.player"
local House = require "world.house"
local GameState = require "gamestate"

local ZOOM = 4.0
function Scene:init()
	self.current_room = House.BedRoom
	camera:zoom(ZOOM)
	local xoff = (self.current_room.width - WIN_WIDTH / ZOOM) / 2
	local yoff = (self.current_room.height - WIN_HEIGHT / ZOOM) / 2
	camera:setPos(xoff, yoff)
	self.player = Player(self.current_room.world, 85 / 2, 93 / 2)
	GameState.can_player_move = false
	Say {"You", "What was that noise just now?"}
	Say({"You", "I'm scared... I can't sleep with the lights off anymore."}, {
		oncomplete = function()
			GameState.can_player_move = true
		end
	})

end

function Scene:draw()
	self.current_room:draw()
end

function Scene:ui_layer()
	lg.setFont(Resource.Font.Ui)
	lg.print({{1, 0.8, 0.5}, "Objective: ", {1, 1, 1}, GameState.objective}, 10, 10)
	self.current_room:ui_layer()
end

function Scene:update(dt)
	self.current_room:update(dt)
	if GameState.can_player_move then
		local input_x = Input:keydown("d") - Input:keydown("a")
		local input_y = Input:keydown("s") - Input:keydown("w")
		self.player:handle_input(input_x, input_y)
	end
end

---returns the screen coordinates of the player
function Scene:player_screen_coords()
	return camera:toScreenPos(self.player:get_pos())
end

function Scene.MoveEntity(ent, w1, w2)

end

return Scene
