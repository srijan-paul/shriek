local Dialog = {
	object = nil,
	current_sequence = nil,
	active = false,
	seq_running = false
}

local GameState = require "gamestate"

function Dialog:start(fn, object)
	assert(not self.active, "a dialog is already in progress.")
	self.current_sequence = fn
	self.object = object
	self.active = true
	GameState.can_player_move = false
	object:start_sequence()
end

function Dialog:start_seq()
	GameState.can_player_move = false
	self.seq_running = true
end

function Dialog:update()
	if self.active and #Moan.allMsgs == 0 then
		self.active = false
		GameState.can_player_move = true
		self.object:end_sequence()
	end

	if self.seq_running and #Moan.allMsgs == 0 then
		self.seq_running = false
		GameState.can_player_move = true
	end
end

return Dialog
