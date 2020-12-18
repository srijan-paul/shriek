local Room = require "world.room"
local Prop = require "prefabs.prop"
local Wall = require "prefabs.wall"
local Interactable = require "prefabs.interactable"

local House = {}

function House.load()
	House.LivingRoom = Room({
		width = 128,
		height = 128,
		image = Resource.Sprite.LivingRoom
	}, function(world)

		Wall(world, 0, 0, 128, 23)

		-- table
		Prop(world, 21, 47, {collision = {width = 29, height = 16}})
		-- box
		Prop(world, 24, 106, {collision = {width = 14, height = 11}})
		-- plant on round table
		Prop(world, 95, 65, {collision = {width = 10, height = 8}})

		local photo = Interactable(world, 95, 10, {range = 20})
		photo:on_trigger(function()
			Say {"You", "How did this painting get covered in blood?"}
		end)
	end)
end

return House

