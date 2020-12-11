local Dialog = {target = nil, current_sequence = nil, active = false}

function Dialog:start(fn, target)
	assert(not self.active, "a dialog is already in progress.")
	self.current_sequence = fn
	self.target = target
	self.active = true
	target:start_sequence()
end

function Dialog:update()
	if self.active and #Moan.allMsgs == 0 then
		self.active = false
		self.target:end_sequence()
	end
end

return Dialog
