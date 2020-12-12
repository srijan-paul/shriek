local Dialog = {object = nil, current_sequence = nil, active = false}

function Dialog:start(fn, object)
	assert(not self.active, "a dialog is already in progress.")
	self.current_sequence = fn
	self.object = object
	self.active = true
	object:start_sequence()
end

function Dialog:update()
	if self.active and #Moan.allMsgs == 0 then
		self.active = false
		self.object:end_sequence()
	end
end

return Dialog
