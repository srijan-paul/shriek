local Room = require "world.room"
local Prop = require "prefabs.prop"
local Wall = require "prefabs.wall"
local Interactable = require "prefabs.interactable"
local Dialog = require "dialog"

local GState = require "gamestate"

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

		local torch = Interactable(world, 13, 35, {
			vision_triggered = false,
			range = 10,
			active = false,
			sprite = Resource.Sprite.TorchItem,
			text = {ITEM_COLOR, "Flashlight"}
		})

		torch:on_trigger(function()
			Resource.Sfx.ItemPickup:play()
			Timer.after(1, function()
				Dialog:start_seq()
				GState.events.torch_found = true
				Say({"You", "That's better."})
			end)
			House.BedRoom.scene:add_hint("Press 'Q' to switch flashlight on and off.")
			torch:delete()
		end)

		-- Chair
		Prop(world, 24, 32, {collision = {width = 7, height = 8}})
		-- Square table thing
		Prop(world, 70, 70, {collision = {width = 12, height = 14}})

		local mess = Interactable(world, 19, 66, {range = 15})
		mess:on_trigger(function()
			Say {"You", "Mom will be mad if she sees this mess."}
		end)

		local clock = Interactable(world, 29, 12, {range = 20})
		clock:on_trigger(function()
			Say {"You", "It's past midnight..."}
		end)

		local light_switch = Interactable(world, 55, 19, {
			range = 10,
			vision_triggered = false,
			text = "use"
		})
		light_switch:on_trigger(function()
			Say {"You", "The lights are out. A powercut?"}

			if not GState.events.torch_found then
				Say({"You", "I better grab my torch from the drawer."}, {
					oncomplete = function()
						GState.objective = "Find a flashlight."
						torch.active = true
					end
				})
			end
		end)
	end)
end

return House
