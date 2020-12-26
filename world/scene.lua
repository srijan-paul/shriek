local Scene = class "Scene"
local camera = require "camera"
local Player = require "prefabs.player"
local House = require "world.house"
local GameState = require "gamestate"
local HUD = require "world.hud"
local pmenu = require "pause_menu"
local Inventory = require "inventory_menu"

local ZOOM = 4.0

local function set_cam(room)
	local xoff = (room.width - WIN_WIDTH / ZOOM) / 2
	local yoff = (room.height - WIN_HEIGHT / ZOOM) / 2
	camera:setPos(xoff, yoff)
end

function Scene.load()
	Inventory:load()
end

function Scene:init()
	GameState.add_item(require "item_list".FlashLight)
	self.current_room = House.Study
	self.current_room.scene = self
	camera:zoom(ZOOM)
	set_cam(self.current_room)
	self.player = Player(self.current_room.world, 85 / 2, 93 / 2)

	Sfx.music.ambient_1:setLooping(true)
	Sfx.music.ambient_1:play()
	-- temporary code
	GameState.events.torch_found = true
	-- TODO move this code to the room's script
	-- GameState.can_player_move = false
	-- Say {"You", "What was that noise just now?"}
	-- Say({"You", "I'm scared... I can't sleep with the lights off anymore."}, {
	-- 	oncomplete = function()
	-- 		GameState.can_player_move = true
	-- 		GameState.set_objective("Turn the lights on.")
	-- 		HUD:add_hint({
	-- 			"Press [", YELLOW, "E", WHITE, "] to interact with surroundings."
	-- 		})
	-- 	end
	-- })
end

function Scene:draw()
	self.current_room:draw()
end

function Scene:ui_layer()
	self.current_room:ui_layer()
	HUD:draw()
	pmenu:draw()
end

function Scene:update(dt)
	if not GameState.is_paused then
		self.current_room:update(dt)
		if GameState.can_player_move then
			local input_x = Input:keydown("d") - Input:keydown("a")
			local input_y = Input:keydown("s") - Input:keydown("w")
			self.player:handle_input(input_x, input_y)
		else
			self.player:handle_input(0, 0)
		end

		Moan.update(dt)
	end

	pmenu:update(dt)
	HUD:update(dt)
end

---returns the screen coordinates of the player
function Scene:player_screen_coords()
	return camera:toScreenPos(self.player:get_pos())
end

function Scene:keypressed(k)
	if pmenu.is_visible then
		pmenu:keypressed(k)
	else
		if k == "escape" then
			pmenu:activate()
		end
	end
end

function Scene:keyreleased(key)
	if not GameState.is_paused then
		Moan.keyreleased(key)
	end
end

function Scene:switch_room(room, dir)
	Scene.MoveEntity(self.player, self.current_room, room)
	self.current_room = room
	set_cam(self.current_room)
	local entry_loc = assert(room.entry_points[dir])
	self.player:set_pos(entry_loc)
end

function Scene.MoveEntity(ent, prev_room, next_room)
	prev_room.world:remove_gameobject(ent)
	prev_room.world:clear_garbage()
	next_room.world:add_gameobject(ent)
end

return Scene
