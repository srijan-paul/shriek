local Room = require "world.room"
local Prop = require "prefabs.prop"
local Wall = require "prefabs.wall"
local Area = require "prefabs.area"
local Interactable = require "prefabs.interactable"
local Dialog = require "dialog"
local GState = require "gamestate"
local HUD = require "world.hud"

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
					HUD:add_hint({
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
					GState.events.phone_rang = true
					GState.set_objective("Recieve the call.")
				end
			})
		end)
	end, 5)

	-- clock
	Interactable(world, 29, 12, {range = 20}):on_trigger(function()
		Say {"You", "It's past midnight..."}
	end)

	-- light switch
	Interactable(world, 55, 19, {
		range = 10,
		vision_triggered = false,
		text = {YELLOW, "use"}
	}):on_trigger(function()
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

	-- TODO fix direction by adding an intermediate room.
	local btm_door = Area(world, 42, 88, 18, 13)
	btm_door:on_body_enter(function (e)
		if e.id == "player" then
			if not GState.events.phone_rang then
				Dialog:start_seq()
				Say {"You", "I shouldn't leave my room at night."}
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
	Wall(world, 64, 12, 128, 10)

	local telephone = Interactable(world, 89, 20, {range = 10})

	telephone:on_trigger(function ()
		if not GState.events.phone_rang then return end
		Resource.Sfx.PhoneRing:stop()
		Say {"You", "Hello... ?"}
		RSay {"Phone", "Do your parents tell you bedtime stories?"}
		Say {"You", "Who is this?"}
		RSay {"Phone", "Those strange stories about dieties and demons,--ever heard of them?"}
		Say {"You", "Im sorry sir,--Mom isn't home."}
		RSay {"Phone", "Those stories are all true,Timmy."}
		Say {"You (shivering)", "Please tell me who you are"}
		RSay {"Phone", "I am a Shaman, the name is Liam.--Listen up kid, don't hang up.--"
		.. " You won't be able to make any phone calls after this."}
		Say {"You", "Does my dad know you?"}
		RSay {"Phone", "Chit chat later,--that hideous thing is gnawing on the telephone cables"
			.. " outside your house."}
		RSay ({"Phone", "Find your dad's pager in his study room,--And remember - (noise) - n-t dem.. in."}, {
			oncomplete = function ()
				GState.set_objective("Find a pager in dad's room.")
				Resource.Sfx.Beep:play()
			end
		})
		RSay {"Phone", "(beep)"}
		
		telephone:on_trigger(function ()
			Resource.Sfx.Beep:play()
			RSay {"Phone", "(beep)"}
			Say {"You", "The phone isn't working."}
		end)
	end)
end

function House.load()
	local LivingRoomImg = Resource.Sprite.LivingRoom
	House.LivingRoom = Room({
		width = LivingRoomImg:getWidth(),
		height = LivingRoomImg:getHeight(),
		image = LivingRoomImg
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

	House.BedRoom:initialize(bedroom_init)
	House.LivingRoom:initialize(livingroom_init)
	House.Entrance:initialize(entrance_init)
end

return House
