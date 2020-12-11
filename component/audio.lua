local Audio = class "AudioPlayer"

local STATE_PAUSED = 1
local STATE_PLAYING = 2

function Audio:init(_, source, looping)
	self.source = source
	self.time_accumulated = 0
	self.duration = 0
	self.looping = looping or false
	self.state = STATE_PAUSED
end

function Audio:update(dt)
	if not self.looping or self.state == STATE_PAUSED then
		return
	end

	self.time_accumulated = self.time_accumulated + dt
	if self.time_accumulated >= self.duration then
		self.time_accumulated = 0
		self.source:play()
	end
end

function Audio:play()
	if self.looping then
		self.state = STATE_PLAYING
	else
		self.source:play()
	end
end

function Audio:pause()
	if self.looping then
		self.state = STATE_PAUSED
	else
		self.source:pause()
	end
end

function Audio:stop()
	self.source:stop()
end

function Audio:set_duration(t)
	self.duration = t
end

function Audio:set_volume(v)
	self.source:setVolume(v)
end

return Audio
