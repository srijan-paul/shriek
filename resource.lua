local janim = require "lib.janim"

local Resource = {Sprite = {}, Sfx = {}, Canvases = {}, Font = {}}

local la = love.audio

function Resource.load()
	local rs = Resource.Sprite
	rs.Box = lg.newImage("assets/images/temp.png")
	rs.LivingRoom = lg.newImage("assets/images/base_room.png")
	rs.BedRoom = lg.newImage("assets/images/bedroom.png")
	rs.Player = janim.newSpriteSheet("assets/images/player.png", 4, 1)

	local sfx = Resource.Sfx
	sfx.Steps = {}
	sfx.Steps.Wood = la.newSource("assets/sound/wood02.ogg", "static")
	sfx.Type = la.newSource("assets/sound/type.wav", "static")
	sfx.Type:setVolume(0.3)
	-- credit: https://freesound.org/people/InspectorJ/sounds/343130/
	sfx.TickTock = la.newSource(
			"assets/sound/343130__inspectorj__ticking-clock-a.ogg", "static")

	sfx.DoorOpen = la.newSource(
			"assets/sound/431117__inspectorj__door-front-opening-a.wav", "static")

	-- credits: https://opengameart.org/content/ambient-noise
	sfx.Ambient1 = la.newSource("assets/sound/ambient1.ogg", "static")
	sfx.Ambient1:setVolume(0.2)
	sfx.Ambient1:setLooping(true)
	sfx.Ambient1:play()

	-- credits: https://opengameart.org/content/light-switch-on-sfx-sound-effect
	sfx.SwitchOn = la.newSource("assets/sound/Light-Switch-Click-On-Sfx.ogg",
			"static")

	local rf = Resource.Font
	rf.dialog = lg.newFont("assets/font/VCR_OSD_MONO_1.001.ttf", 22)

	local rc = Resource.Canvases
	rc.interact_btn = lg.newText(rf.dialog, "Interact")
end

return Resource
