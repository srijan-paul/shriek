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

	local BedRoomImg = Resource.Sprite.BedRoom
	House.BedRoom = Room({
		width = BedRoomImg:getWidth(),
		height = BedRoomImg:getHeight(),
		image = BedRoomImg
	}, function(world)
		Wall(world, 0, 0, 85, 21)

		-- Bed
		Prop(world, 67, 36, {collision = {width = 20, height = 29}})
		-- Table
		Prop(world, 14, 31, {collision = {width = 12, height = 16}})
		-- Chair
		Prop(world, 24, 32, {collision = {width = 7, height = 8}})
		-- Square table thing
		Prop(world, 70, 70, {collision = {width = 12, height = 14}})

	end)
end

return House

