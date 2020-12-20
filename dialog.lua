local Dialog = {object = nil, current_sequence = nil, active = false}
local GameState = require "gamestate"

function Dialog:start(fn, object)
	assert(not self.active, "a dialog is already in progress.")
	self.current_sequence = fn
	self.object = object
	self.active = true
	GameState.can_player_move = false
	object:start_sequence()
end

function Dialog:update()
	if self.active and #Moan.allMsgs == 0 then
		self.active = false
		GameState.can_player_move = true
		self.object:end_sequence()
	end
end

return Dialog
