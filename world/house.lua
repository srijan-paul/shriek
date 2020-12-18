local Room = require "world.room"
local Prop = require "prefabs.prop"

local House = {}

function House.load()
	House.LivingRoom = Room({
		width = 128,
		height = 128,
		image = Resource.Sprite.RoomBg
	}, function(world)
		-- table
		Prop(world, 21, 47, {collision = {width = 29, height = 16}})
		-- box
		Prop(world, 24, 106, {collision = {width = 14, height = 11}})
		-- plant on round table
		Prop(world, 95, 65, {collision = {width = 10, height = 8}})
	end)
end

return House

