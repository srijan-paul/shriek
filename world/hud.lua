local GameState = require "gamestate"
local FloatingText = require "prefabs.floating_text"
local Pager = require "prefabs.pager"

local HINT_COLOR = {sugar.rgb("#0984e3")}
local HINT_PREFIX = {HINT_COLOR, "HINT: ", WHITE}

local hud = {messages = {}, msg_pos = 2 * DISPLAY_HEIGHT / 3, msg_pad = 5}
local OBJECTIVE_X, OBJECTIVE_Y = 10, 10

function hud:draw()
	if GameState.objective then
		lg.setFont(Resource.Font.Ui)
		lg.print({YELLOW, "Objective: ", WHITE, GameState.objective},
				OBJECTIVE_X, OBJECTIVE_Y)
	end
	for _, d in ipairs(self.messages) do
		d:draw()
	end

	Pager:draw()
end

function hud:update(dt)
	for i = #self.messages, 1, -1 do
		local d = self.messages[i]
		d:update(dt)
		if d.dead then
			table.remove(self.messages, i)
			self.msg_pos = self.msg_pos - d.text:getHeight() - self.msg_pad
		end
	end

	Pager:update(dt)
end

function hud:add_message(text, duration, is_fade_out)
	local ftext = FloatingText(text, SC_WIDTH - 220, 10, 0, duration, is_fade_out)
	local twidth = ftext.text:getWidth()
	ftext.x = SC_WIDTH - twidth - 10
	ftext.y = self.msg_pos
	self.msg_pos = self.msg_pos + ftext.text:getHeight() + self.msg_pad
	table.insert(self.messages, ftext)
end

function hud:add_hint(text)
	if (type(text) == "table") then
		self:add_message(sugar.t_join(HINT_PREFIX, text), 5, true)
	else
		local t = {unpack(HINT_PREFIX)}
		table.insert(t, text)
		self:add_message(t, 5, true)
	end
	Sfx.sounds.hint:play()
end

return hud
