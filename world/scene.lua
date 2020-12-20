local Scene = class "Scene"
local camera = require "camera"
local Player = require "prefabs.player"
local House = require "world.house"
local GameState = require "gamestate"
local FloatingText = require "prefabs.floating_text"

local HINT_COLOR = {sugar.rgb("#0984e3")}

local ZOOM = 4.0
function Scene:init()
	self.current_room = House.BedRoom
	self.current_room.scene = self
	camera:zoom(ZOOM)
	local xoff = (self.current_room.width - WIN_WIDTH / ZOOM) / 2
	local yoff = (self.current_room.height - WIN_HEIGHT / ZOOM) / 2
	camera:setPos(xoff, yoff)
	self.player = Player(self.current_room.world, 85 / 2, 93 / 2)
	GameState.can_player_move = false

	Resource.Sfx.Rain:play()

	Say {"You", "What was that noise just now?"}
	Say({"You", "I'm scared... I can't sleep with the lights off anymore."}, {
		oncomplete = function()
			GameState.can_player_move = true
			GameState.objective = "Turn the lights on."
		end
	})

	-- contains all floating text items.
	self.message_area = {}
	self.msg_pos = 2 * SC_HEIGHT / 3
	self.msg_pad = 5
end

function Scene:draw()
	self.current_room:draw()
end

function Scene:ui_layer()
	if GameState.objective then
		lg.setFont(Resource.Font.Ui)
		lg.print({{1, 0.8, 0.5}, "Objective: ", {1, 1, 1}, GameState.objective}, 10,
				10)
	end
	for _, d in ipairs(self.message_area) do
		d:draw()
	end
	self.current_room:ui_layer()
end

function Scene:update(dt)
	self.current_room:update(dt)
	if GameState.can_player_move then
		local input_x = Input:keydown("d") - Input:keydown("a")
		local input_y = Input:keydown("s") - Input:keydown("w")
		self.player:handle_input(input_x, input_y)
	else
		self.player:handle_input(0, 0)
	end

	for i = #self.message_area, 1, -1 do
		local d = self.message_area[i]
		d:update(dt)
		if d.dead then
			table.remove(self.message_area, i)
			self.msg_pos = self.msg_pos - d.text:getHeight() - self.msg_pad
		end
	end
end

---returns the screen coordinates of the player
function Scene:player_screen_coords()
	return camera:toScreenPos(self.player:get_pos())
end

function Scene:add_message(text, duration, fade_out)
	local ftext = FloatingText(text, SC_WIDTH - 220, 10, 0, duration, fade_out)
	local twidth = ftext.text:getWidth()
	ftext.x = SC_WIDTH - twidth - 10
	ftext.y = self.msg_pos
	self.msg_pos = self.msg_pos + ftext.text:getHeight() + self.msg_pad
	table.insert(self.message_area, ftext)
end

function Scene:add_hint(msg)
	self:add_message({HINT_COLOR, "HINT: ", {1, 1, 1}, msg}, 5, true)
	Resource.Sfx.Hint:play()
end

function Scene.MoveEntity(ent, w1, w2)

end

return Scene
