local Room = require "world.room"
local Prop = require "prefabs.prop"
local Wall = require "prefabs.wall"
local Area = require "prefabs.area"
local Interactable = require "prefabs.interactable"
local Dialog = require "dialog"
local GState = require "gamestate"
local HUD = require "world.hud"
local Items = require "item_list"

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
		Sfx.sounds.pick_item:play()
		Timer.after(0.25, function()
			Dialog:start_seq()
			GState.add_item(Items.FlashLight)
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
		Sfx.sounds.phone_ring:setLooping(true)
		Moan.clearMessages()
		GState.can_player_move = false
		Sfx.sounds.phone_ring:play()
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
		Sfx.sounds.phone_ring:stop()
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
				Sfx.sounds.beep:play()
			end
		})
		RSay {"Phone", "(beep)"}

		telephone:on_trigger(function ()
			Sfx.sounds.beep:play()
			RSay {"Phone", "(beep)"}
			Say {"You", "The phone doesn't seem to be working."}
		end)
	end)
end


local function studyroom_init(world)
	Wall(world, 64, 12, 128, 18)
	local shelf = Interactable(world, 48, 17, {range = 10, collider = {width = 10, height = 22}})
	local books = Interactable(world, 75, 21, {range = 10, collider = {width = 32, height = 17}})
	local cupboard = Interactable(world, 112, 19, {range = 10, collider = {width = 22, height = 17}})

	local trashbin = Interactable(world, 8, 24, {range = 20, text = {YELLOW, "look"}})
	trashbin:on_trigger(function ()
		Say {"You", "This garbage can has garbage in it."}
	end)

	-- clock on the wall
	Interactable(world, 34, 17, {range = 10}):on_trigger(function ()
		Sfx.sounds.tick_tock:play()
		Say {"You", "The time hasn't changed since I left my bedroom.--Are the clocks not working?"}
	end):on_end(function ()
		Sfx.sounds.tick_tock:stop()
	end)

	-- round table at the center of the room
	Prop(world, 67, 57, {collision = {width = 12, height = 12}})
	local pager = Interactable(world, 67, 56, {
		sprite = Resource.Sprite.PagerItem,
		range = 14,
		text = {YELLOW, "Pager"}
	})
	pager:on_trigger(function()
		Sfx.sounds.pick_item:play()
		GState.add_item(Items.Pager)
		Say {"You", "This must be the pager he was talking about."}
		RSay {"Pager", "Good job if you've made it here."}
		RSay {"Pager", "The bleeper you're using is an old one way pager."}
		RSay {"Pager", "I know you have many questions,--and I wish I had the time to explain to you the entire situation,--but you'll most likely find out soon anyway."}
		GState.set_objective("Investigate the room.")
		pager:delete()
	end)

	pager:set_scale(0.7, 0.7)

	local table = Interactable(world, 25, 90, {range = 10, collider = {width = 25, height = 9}})
	local spill = Interactable(world, 110, 117, {range = 10})
	spill:on_trigger(function()
		Say {"You", "A broken inkpot and some spilled ink."}
		Say {"You", "It looks fresh, it broke not too long ago."}
	end)

	Prop(world, 7, 90, {collision = {width = 5, height = 5}})
	Prop(world, 22, 98, {collision = {width = 5, height = 4}})
end

--- Initializes all the rooms in the house by loading 
--- their respective entities, event listeners, items, props 
--- etc.
function House.load()
	local LivingRoomImg = Resource.Sprite.LivingRoom
	House.LivingRoom = Room {
		width = LivingRoomImg:getWidth(),
		height = LivingRoomImg:getHeight(),
		image = LivingRoomImg
	}

	local BedRoomImg = Resource.Sprite.BedRoom
	House.BedRoom = Room {
		width = BedRoomImg:getWidth(),
		height = BedRoomImg:getHeight(),
		image = BedRoomImg
	}

	local EntrangeImg = Resource.Sprite.FrontRoom
	House.Entrance = Room {
		width = EntrangeImg:getWidth(),
		height = EntrangeImg:getHeight(),
		image = EntrangeImg,
		entry_points = {[Direction.RIGHT] = Vec2(125, 43)}
	}


	local StudyRoomImg = Resource.Sprite.StudyRoom
	House.Study = Room {
		width = StudyRoomImg:getWidth(),
		height = StudyRoomImg:getHeight(),
		image = StudyRoomImg
	}

	-- experimental sandbox
	House.SandBox = Room({
		width = 100, height = 100,
		image = lg.newImage("assets/images/sb.png")
	})

	House.BedRoom:initialize(bedroom_init)
	House.LivingRoom:initialize(livingroom_init)
	House.Entrance:initialize(entrance_init)
	House.Study:initialize(studyroom_init)
end

return House
