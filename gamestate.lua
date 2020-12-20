local GameState = {
	events = {
		torch_found = false -- if the player has found the torch in the beginning of the game
	},
	objective = nil,
	can_player_move = true
}

function GameState.resume()
	GameState.can_player_move = true
end

function GameState.set_objective(s)
	GameState.objective = s
end

function GameState.clear_objective()
	GameState.objective = nil
end

return GameState
