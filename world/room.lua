local Room = class "Room"
local World = require "world.world"
local camera = require "camera"
local Prop = require "prefabs.prop"
local Player = require "prefabs.player"

-- temporary imports
local Wall = require "prefabs.wall"
local Object = require "prefabs.interactable"

local ZOOM = 4.0
function Room:init()
	self.world = World(128, 128)
	camera:zoom(ZOOM)
	camera:setPos(-30, -10)
	--   temporary code
	self.player = Player(self.world, 100, 100, {sprite = Resource.Sprite.Box})
	Wall(self.world, 0, 0, 128, 23)
	local photo = Object(self.world, 95, 10, {target = self.player, size = 30})
	photo:on_trigger(function()
		Say {"You", "wow that's a nice picture !"}
		Say {"Photo", "I agree!"}
		Say {"You", "Did the photo just talk !?"}
	end)
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
end

---returns the screen coordinates of the player
function Room:player_screen_coords()
	return camera:toScreenPos(self.player:get_pos())
end

return Room
