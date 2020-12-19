local vision_opts = {
	min = 150.0,
	max = 170.0,
	radius = 150.0,
	dr = 0.25,
	on = true
}

function vision_opts:toggle()
	if Resource.Sfx.SwitchOn:isPlaying() then
		Resource.Sfx.SwitchOn:stop()
	end
	Resource.Sfx.SwitchOn:play()

	if self.on == true then
		self.on = false
		self.dr = 0
		self.radius = 45
		return
	end

	self.on = true
	self.dr = 0.25
	self.radius = self.min
end

return vision_opts
