local janim = require "lib.janim"

local Resource = {Sprite = {}, Sfx = {}, Canvases = {}, Font = {}}

local la = love.audio

function Resource.load()
	local rs = Resource.Sprite
	rs.Box = lg.newImage("assets/images/temp.png")
	rs.LivingRoom = lg.newImage("assets/images/base_room.png")
	rs.BedRoom = lg.newImage("assets/images/bedroom.png")
	rs.FrontRoom = lg.newImage("assets/images/entrance.png")
	rs.StudyRoom = lg.newImage("assets/images/study.png")
	rs.Player = janim.newSpriteSheet("assets/images/player.png", 4, 1)
	rs.TorchItem = lg.newImage("assets/images/torch.png")
	rs.PagerItem = lg.newImage("assets/images/pager.png")

	local sfx = Resource.Sfx
	sfx.Steps = {}
	sfx.Steps.Wood = la.newSource("assets/sound/wood02.ogg", "static")
	sfx.Steps.Wood:setVolume(0.2)
	sfx.Type = la.newSource("assets/sound/type2.wav", "static")
	sfx.Type:setVolume(0.2)
	-- credit: https://freesound.org/people/InspectorJ/sounds/343130/
	sfx.TickTock = la.newSource(
			"assets/sound/343130__inspectorj__ticking-clock-a.ogg", "static")

	sfx.DoorOpen = la.newSource(
			"assets/sound/431117__inspectorj__door-front-opening-a.wav", "static")

	-- credits: https://opengameart.org/content/ambient-noise
	sfx.Ambient1 = la.newSource("assets/sound/ambient1.ogg", "static")
	sfx.Ambient1:setVolume(0.6)
	sfx.Ambient1:setLooping(true)
	sfx.Ambient1:play()

	-- credits: https://freesound.org/people/klankbeeld
	sfx.Lullaby = la.newSource(
			"assets/sound/369542__klankbeeld__musicbox-brahms-lullaby-loop.ogg", "stream")
	sfx.Lullaby:setVolume(0.8)

	-- credit: https://opengameart.org/content/breaking-bottle
	-- spookymodem
	sfx.GlassBreak = la.newSource("assets/sound/Bottle-Break.ogg", "static")
	-- credits: https://opengameart.org/content/light-switch-on-sfx-sound-effect
	sfx.SwitchOn = la.newSource("assets/sound/Light-Switch-Click-On-Sfx.ogg",
			"static")
	-- credits: https://opengameart.org/content/pickupplastic-sound
	-- Vinrax on OpenGameArt
	sfx.ItemPickup = la.newSource("assets/sound/pickup.ogg", "static")

	-- credits for Rain and thunder sound effect: https://opengameart.org/content/rain-and-thunders
	sfx.Rain = la.newSource("assets/sound/Dark_Rainy_Nightambience.ogg", "stream")
	sfx.Rain:setVolume(0.02)

	sfx.Knock3 = la.newSource("assets/sound/6501__rondomat__knocking-3.ogg", "static")

	-- credits: https://opengameart.org/content/menu-selection-click
	sfx.Hint = la.newSource("assets/sound/hint.ogg", "static")
	sfx.PhoneRing = la.newSource("assets/sound/phone-ring.ogg", "static")
	sfx.PhoneRing:setVolume(0.05)

	-- credit: https://opengameart.org/content/bad-sound-1
	sfx.Objective = la.newSource("assets/sound/lose-sound-1_0.ogg", "static")
	sfx.Beep = la.newSource("assets/sound/beep.ogg", "static")


	-- UI sfx
	sfx.ui_select = la.newSource("assets/sound/270401__littlerobotsoundfactory__menu-select-00.ogg", "static")
	sfx.ui_nav = la.newSource("assets/sound/253168__suntemple__sfx-ui-button-click.wav", "static")


	local rf = Resource.Font
	rf.dialog = lg.newFont("assets/font/VCR_OSD_MONO_1.001.ttf", 22)
	rf.Ui = lg.newFont("assets/font/rainyhearts.ttf", 25)
	rf.Misc = lg.newFont("assets/font/Louis George Cafe.ttf", 20)

	local rc = Resource.Canvases
	rc.interact_btn = lg.newText(rf.Ui, "Interact")
end

return Resource
