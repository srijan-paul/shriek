local janim = require "lib.janim"

local Resource = {Sprite = {}, Sfx = {}}

local la = love.audio

function Resource.load()
	local rs = Resource.Sprite
	rs.Box = lg.newImage("assets/images/temp.png")
	rs.RoomBg = lg.newImage("assets/images/base_room.png")

	local sfx = Resource.Sfx
	sfx.Steps = {}
	sfx.Steps.Wood = la.newSource("assets/sound/wood02.ogg", "static")

end

return Resource
