local GameState = {
	events = {
		torch_found = false, -- if the player has found the torch in the beginning of the game
		phone_rang = false, -- whether the phone rang after the player picked up the torch.
		phone_conv_done = false -- phone conversation between Liam and Timmy
	},
	objective = nil,
	can_player_move = true,
	game = nil,
	is_paused = false,
	state_before_prev_pause = {can_player_move = true},
	inventory_items = {},
	active_item = nil
}

local inventory = GameState.inventory_items

function GameState.resume()
	GameState.can_player_move = true
end

function GameState.set_objective(s)
	GameState.objective = s
end

function GameState.clear_objective()
	GameState.objective = nil
end

function GameState.set_scene(s)
	GameState.game.set_scene(s)
end

function GameState.start_game()
	GameState.game.start()
end

function GameState.current_scene()
	return GameState.game.current_scene
end

function GameState.set_paused(paused)
	if paused == false then
		GameState.can_player_move = GameState.state_before_prev_pause.can_player_move
	else
		GameState.state_before_prev_pause.can_player_move = GameState.can_player_move
		GameState.can_player_move = false
	end
	GameState.is_paused = paused
	GameState.game.is_paused = paused
end

function GameState.add_item(item)
	table.insert(GameState.inventory_items, item)
end

return GameState
