local Room = class "Room"
local World = require "world.world"
local camera = require "camera"
local Prop = require "prefabs.prop"
local Player = require "prefabs.player"

-- temporary imports
local Wall = require "prefabs.wall"
local Interactable = require "prefabs.interactable"

local ZOOM = 4.0
function Room:init()
	self.world = World(128, 128)
	camera:zoom(ZOOM)
	camera:setPos(-30, -10)
	--   temporary code
	self.player = Player(self.world, 100, 100, {sprite = Resource.Sprite.Box})
	Wall(self.world, 0, 0, 128, 23)
	local photo = Interactable(self.world, 95, 10,
			{target = self.player, size = 30})
	photo:on_trigger(function()
		Say {"You", "How did this painting get covered in blood?"}
	end)

	-- table
	Prop(self.world, 21, 47, {collision = {width = 29, height = 16}})
	-- box
	Prop(self.world, 24, 106, {collision = {width = 14, height = 11}})
	-- plant on round table
	Prop(self.world, 95, 65, {collision = {width = 10, height = 8}})

	-- / temporary code
end

function Room:draw()
	camera:set()
	lg.draw(Resource.Sprite.RoomBg, 0, 0)
	self.world:draw()
	camera:unset()
end

function Room:ui_layer()
	self.world:ui_layer()
end

function Room:update(dt)
	self.world:update(dt)
	local input_x = Input:keydown("d") - Input:keydown("a")
	local input_y = Input:keydown("s") - Input:keydown("w")
	self.player:handle_input(input_x, input_y)
end

---returns the screen coordinates of the player
function Room:player_screen_coords()
	return camera:toScreenPos(self.player:get_pos())
end

return Room
