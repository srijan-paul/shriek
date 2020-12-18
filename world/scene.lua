local Scene = class "Scene"
local camera = require "camera"
local Player = require "prefabs.player"
local House = require "world.house"

House.load()

-- temporary imports
local Wall = require "prefabs.wall"
local Interactable = require "prefabs.interactable"

local ZOOM = 4.0
function Scene:init()
	self.current_room = House.LivingRoom
	camera:zoom(ZOOM)
	camera:setPos(-30, -10)
	--   temporary code
	self.player = Player(self.current_room.world, 100, 100)
	Wall(self.current_room.world, 0, 0, 128, 23)
	local photo = Interactable(self.current_room.world, 95, 10,
			{target = self.player, size = 30})
	photo:on_trigger(function()
		Say {"You", "How did this painting get covered in blood?"}
	end)
end

function Scene:draw()
	self.current_room:draw()
end

function Scene:ui_layer()
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
