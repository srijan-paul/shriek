local GameState = {
	events = {
		torch_found = false -- if the player has found the torch in the beginning of the game
	},
	objective = "Turn the lights on.",
	can_player_move = true
}

return GameState
