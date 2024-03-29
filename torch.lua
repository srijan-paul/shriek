local off_radius = 70
local on_radius_min = 120
local on_radius_max = 140
local dr = 0.25

local torch = {
	min = on_radius_min,
	max = on_radius_max,
	radius = off_radius,
	dr = dr,
	on = false
}

function torch:toggle()
	if Sfx.sounds.switch_on:isPlaying() then
		Sfx.sounds.switch_on:stop()
	end
	Sfx.sounds.switch_on:play()

	if self.on == true then
		self.on = false
		self.dr = 0
		self.radius = off_radius
		return
	end

	self.on = true
	self.dr = dr
	self.radius = self.min
end

return torch
