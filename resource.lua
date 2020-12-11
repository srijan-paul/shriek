local janim = require "lib.janim"

local Resource = {Sprite = {}, Sfx = {}, Canvases = {}, Font = {}}

local la = love.audio

function Resource.load()
	local rs = Resource.Sprite
	rs.Box = lg.newImage("assets/images/temp.png")
	rs.RoomBg = lg.newImage("assets/images/base_room.png")

	local sfx = Resource.Sfx
	sfx.Steps = {}
	sfx.Steps.Wood = la.newSource("assets/sound/wood02.ogg", "static")
	sfx.Type = la.newSource("assets/sound/type.wav", "static")

	local rf = Resource.Font
	rf.dialog = lg.newFont("assets/font/prstartk.ttf", 14)

	local rc = Resource.Canvases
	rc.interact_btn = lg.newCanvas(200, 30)
	rc.interact_btn:renderTo(function()
		lg.setColor(1, 1, 1)
		lg.setFont(rf.dialog, 4)
		lg.print("Interact", 0, 0)
	end)

end

return Resource
