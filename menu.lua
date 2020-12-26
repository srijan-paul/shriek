local GameState = require "gamestate"
local Menu = class "Menu"

local ALPHA = 0.7
local TEXT_COLOR = {1, 1, 1}
local HIGHLIGHT_COLOR = {sugar.rgb "#ff4d4d"}
local SELECTED_COLOR = {0, 0, 0}

local bounds = {
	w = DISPLAY_WIDTH / 2,
	h = DISPLAY_HEIGHT / 2,
}
bounds.x = (DISPLAY_WIDTH - bounds.w) / 2
bounds.y = (DISPLAY_HEIGHT - bounds.h) / 2


local font = lg.newFont("assets/font/Louis George Cafe.ttf", 22)
local ypad = font:getHeight() + 4

local function make_opt(text, callback)
	local t_obj = lg.newText(font, text)
	return {
		text = t_obj,
		w = t_obj:getWidth(),
		h = t_obj:getHeight(),
		rawtext = text,
		on_click = callback
	}
end

function Menu:init(options, parent)
	self.is_visible = false
	self.selected_opt_alpha = 1
	self.d_alpha = 0.01 -- rate of change of highlighted alpha.
	self.min_alpha = 0.6 -- minimum alpha value for the option's background.
	self.callbacks = {} -- callback for each menu option.
	self.selected_opt = 1 -- currently selected option.

	self.active_submenu = nil
	self.parent = parent

	if options then
		self.options = sugar.map(options, function(text)
			return make_opt(text)
		end)
	else
		self.options = {} -- array of options that the user can select.
	end
end

function Menu:add_option(name, callback)
	table.insert(self.options, make_opt(name, callback))
end

---switch to a sub menu.
---@param m table menu object to switch to
function Menu:switch_to(m)
	self.active_submenu = m
	m.parent = self
	m:set_visible(true)
end


function Menu:draw()
	if self.active_submenu then
		self.active_submenu:draw()
		return
	end

	if not self.is_visible then
		return
	end

	local x, y = bounds.x, bounds.y
	lg.setColor(0, 0, 0, ALPHA)
	lg.rectangle("fill", 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT)
	lg.setColor(1, 1, 1)

	lg.setFont(font)
	for i, b in ipairs(self.options) do
		if self.selected_opt == i then
			lg.setColor(HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3],
					self.selected_opt_alpha)
			lg.rectangle("fill", x - 2, y - 2, b.w + 4, b.h + 2)
			lg.setColor(SELECTED_COLOR[1], SELECTED_COLOR[2], SELECTED_COLOR[3], 1)
		else
			lg.setColor(TEXT_COLOR[1], TEXT_COLOR[2], TEXT_COLOR[3])
		end
		lg.draw(b.text, x, y)
		y = y + ypad
	end
end

function Menu:update(dt)
	if not self.is_visible then
		return
	end

	if self.active_submenu then
		self.active_submenu:update(dt)
		return
	end

	self.selected_opt_alpha = self.selected_opt_alpha - self.d_alpha
	if self.selected_opt_alpha <= self.min_alpha or self.selected_opt_alpha >= 1 then
		self.d_alpha = self.d_alpha * -1
	end
end

function Menu:keypressed(k)
	if self.active_submenu then
		self.active_submenu:keypressed(k)
		return
	end

	local play_sel_sound = false
	if k == "up" or k == "w" then
		self.selected_opt = self.selected_opt - 1
		if self.selected_opt < 1 then
			self.selected_opt = #self.options
		end
		play_sel_sound = true
	elseif k == "down" or k == "s" then
		self.selected_opt = self.selected_opt + 1
		if self.selected_opt > #self.options then
			self.selected_opt = 1
		end
		play_sel_sound = true
	elseif k == "escape" then
		if self.parent == nil then
			self:deactivate()
		else
			self.parent.active_submenu = false
			self.is_visible = false
		end
	elseif k == "return" then
		local cb = self.options[self.selected_opt].on_click
		if cb then
			cb()
		end
		return
	end

	if play_sel_sound then
		if Sfx.sounds.ui_nav:isPlaying() then
			Sfx.sounds.ui_nav:stop()
		end
		Sfx.sounds.ui_nav:play()
	end
end

function Menu:activate()
	self.is_visible = true
	self.selected_opt = 1
	GameState.set_paused(true)
end


function Menu:deactivate()
	self.is_visible = false
	GameState.set_paused(false)
end

function Menu:set_visible(bool)
	self.is_visible = bool
end

return Menu
