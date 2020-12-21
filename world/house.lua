local Room = require "world.room"
local Prop = require "prefabs.prop"
local Wall = require "prefabs.wall"
local Entt = require "prefabs.entity"
local Area = require "prefabs.area"
local Interactable = require "prefabs.interactable"
local Dialog = require "dialog"


local GState = require "gamestate"

local House = {}

local function bedroom_init(world)
	Wall(world, 44, 13, 77, 17)
	-- Bed
	Prop(world, 67, 36, {collision = {width = 20, height = 29}})
	-- Table
	Prop(world, 14, 31, {collision = {width = 12, height = 16}})

	local torch = Interactable(world, 13, 35, {
		vision_triggered = false,
		range = 10,
		active = false,
		sprite = Resource.Sprite.TorchItem,
		text = {YELLOW, "Flashlight"}
	})

	torch:on_trigger(function()
		Resource.Sfx.ItemPickup:play()
		Timer.after(0.25, function()
			Dialog:start_seq()
			GState.events.torch_found = true
			Say({"You", "Much better."}, {
				oncomplete = function()
					House.BedRoom.scene:add_hint({
						"Press [", YELLOW, "Q", WHITE, "] to switch flashlight on and off."
					})
					GState.clear_objective()
				end
			})
		end)
		torch:delete()
	end)

	-- Chair
	Prop(world, 24, 32, {collision = {width = 7, height = 8}})
	-- Square table thing
	Prop(world, 70, 70, {collision = {width = 12, height = 14}})

	local mess = Interactable(world, 19, 66, {range = 15})
	--- TODO clean up this code here.
	local phone_event_finished = false
	mess:on_trigger(function()
		Say {"You", "Mom will be mad if she sees this mess."}
	end)
	mess:on_end(function()
		if phone_event_finished then
			mess:on_end(nil)
			return
		end
		phone_event_finished = true
		Resource.Sfx.PhoneRing:setLooping(true)
		Moan.clearMessages()
		GState.can_player_move = false
		Resource.Sfx.PhoneRing:play()
		Say {" ", "(Phone rings)"}
		Timer.after(2, function()
			Dialog:start_seq()
			Say {"You", "Who could be calling at this hour?"}
			Say({"You", "I hope it's mom and dad. I want them to come back."}, {
				oncomplete = function()
					GState.set_objective("Recieve the call.")
				end
			})
		end)
	end, 5)

	local clock = Interactable(world, 29, 12, {range = 20})
	clock:on_trigger(function()
		Say {"You", "It's past midnight..."}
	end)

	local light_switch = Interactable(world, 55, 19, {
		range = 10,
		vision_triggered = false,
		text = {YELLOW, "use"}
	})
	light_switch:on_trigger(function()
		Say {"You", "The lights are out. A powercut?"}

		if not GState.events.torch_found then
			Say({"You", "I better grab my torch from the drawer."}, {
				oncomplete = function()
					GState.set_objective("Find a flashlight.")
					torch.active = true
				end
			})
		end
	end)

	-- TODO fix direction
	local btm_door = Area(world, 42, 88, 18, 13)
	btm_door:on_body_enter(function (e)
		if e.id == "player" then
			if not GState.events.torch_found then
				Dialog:start_seq()
				Say {"You", "I shouldn't leave my room when it's dark."}
			else 
				GState.current_scene():switch_room(House.Entrance, Direction.RIGHT)
			end
		end
	end)
		
end

local function livingroom_init(world)
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
end

local function entrance_init(world)
	Wall(world, 64, 12, 128, 15)
end

function House.load()
	House.LivingRoom = Room({
		width = 128,
		height = 128,
		image = Resource.Sprite.LivingRoom
	})

	local BedRoomImg = Resource.Sprite.BedRoom
	House.BedRoom = Room({
		width = BedRoomImg:getWidth(),
		height = BedRoomImg:getHeight(),
		image = BedRoomImg
	})

	local EntrangeImg = Resource.Sprite.FrontRoom
	House.Entrance = Room({
		width = EntrangeImg:getWidth(),
		height = EntrangeImg:getHeight(),
		image = EntrangeImg,
		entry_points = {[Direction.RIGHT] = Vec2(125, 43)}
	})

	-- connect the rooms via the doors.
	-- TODO fix the direction by adding 2 additional intermediate rooms.

	House.Entrance.exits = {
		[Direction.RIGHT] = {
			to = House.BedRoom,
			door = {x = 127, y = 39, w = 3, h = 69}
		}
	}

	House.BedRoom:initialize(bedroom_init)
	House.LivingRoom:initialize(livingroom_init)
	House.Entrance:initialize(entrance_init)
end

return House
