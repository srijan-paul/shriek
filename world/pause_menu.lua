local GameState = require "gamestate"
local PMenu = {
	is_visible = false,
	select_alpha = 1,
	d_alpha = 0.01,
	min_alpha = 0.6,
	callbacks = {},
	selected_opt = 1
}

local ALPHA = 0.8
local TEXT_COLOR = {1, 1, 1}
local HIGHLIGHT_COLOR = {sugar.rgb "#ff4d4d"}
local SELECTED_COLOR = {0, 0, 0}

local bounds = {
	x = DISPLAY_WIDTH / 4,
	y = DISPLAY_HEIGHT / 4,
	w = DISPLAY_WIDTH / 4,
	h = DISPLAY_HEIGHT / 4
}

local font = lg.newFont("assets/font/Louis George Cafe.ttf", 22)
local ypad = font:getHeight() + 4

local function make_opt(text)
	local t_obj = lg.newText(font, text)
	return {
		text = t_obj,
		w = t_obj:getWidth(),
		h = t_obj:getHeight(),
		rawtext = text
	}
end

PMenu.buttons = {make_opt("INVENTORY"), make_opt("RESUME"), make_opt("QUIT")}

PMenu.callbacks["RESUME"] = function()
	PMenu:deactivate()
end

function PMenu:load()

end

function PMenu:draw()
	if not self.is_visible then
		return
	end
	local x, y = bounds.x, bounds.y
	lg.setColor(0, 0, 0, ALPHA)
	lg.rectangle("fill", 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT)
	lg.setColor(1, 1, 1)

	lg.setFont(font)
	for i, b in ipairs(self.buttons) do
		if self.selected_opt == i then
			lg.setColor(HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3],
					self.select_alpha)
			lg.rectangle("fill", x - 2, y - 2, b.w + 4, b.h + 2)
			lg.setColor(SELECTED_COLOR[1], SELECTED_COLOR[2], SELECTED_COLOR[3])
		else
			lg.setColor(TEXT_COLOR[1], TEXT_COLOR[2], TEXT_COLOR[3])
		end
		lg.draw(b.text, x, y)
		y = y + ypad
	end
end

function PMenu:update(_)
	if not self.is_visible then
		return
	end
	self.select_alpha = self.select_alpha - self.d_alpha
	if self.select_alpha <= self.min_alpha or self.select_alpha >= 1 then
		self.d_alpha = self.d_alpha * -1
	end
end

function PMenu:keypressed(k)
	local play_sel_sound = false
	if k == "up" or k == "w" then
		self.selected_opt = self.selected_opt - 1
		if self.selected_opt < 1 then
			self.selected_opt = #self.buttons
		end
		play_sel_sound = true
	elseif k == "down" or k == "s" then
		self.selected_opt = self.selected_opt + 1
		if self.selected_opt > #self.buttons then
			self.selected_opt = 1
		end
		play_sel_sound = true
	elseif k == "escape" then
		self:deactivate()
	elseif k == "return" then
		local cb = self.callbacks[self.buttons[self.selected_opt].rawtext]
		if cb then
			cb()
		end
		return
	end

	if play_sel_sound then
		if Resource.Sfx.ui_select:isPlaying() then
			Resource.Sfx.ui_select:stop()
		end

		Resource.Sfx.ui_select:play()
	end
end

function PMenu:activate()
	self.is_visible = true
	self.selected_opt = 1
	GameState.set_paused(true)
end

function PMenu:deactivate()
	self.is_visible = false
	GameState.set_paused(false)
end

return PMenu
