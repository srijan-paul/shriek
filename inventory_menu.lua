local Gamestate = require "gamestate"
local item = require "prefabs.item"
local Inventory = {is_visible = false, parent = nil, selected_index = 1}

local bg_alpha = 0.8
local alpha = 1
local d_alpha = 0.01
local min_alpha = 0.6
local max_alpha = 1

local selected_color = {sugar.rgb("#d2dae2")}

function Inventory:load()
	self.w = SC_WIDTH / 2
	self.h = SC_HEIGHT / 2
	self.xpad, self.ypad = 4, 4
	self.x = (SC_WIDTH - self.w) / 2
	self.y = (SC_HEIGHT - self.h) / 2
	self.font = Resource.Font.Misc
	self.fheight = self.font:getHeight()
end

function Inventory:draw()
	if not self.is_visible then
		return
	end

	lg.setColor(0, 0, 0, bg_alpha)
	lg.rectangle("fill", 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT)

	lg.setColor(1, 1, 1, 1)
	local x, y = self.x, self.y
	lg.setFont(self.font)
	local selection = nil
	for i, item in ipairs(Gamestate.inventory_items) do
		if i == self.selected_index then
			lg.setColor(selected_color[1], selected_color[2], selected_color[3], alpha)
			lg.rectangle("fill", x - 2, y - 2, self.font:getWidth(item.name) + 4,
					self.fheight + 2)
			lg.setColor(0, 0, 0)
			selection = Gamestate.inventory_items[i]
		else
			lg.setColor(1, 1, 1)
		end
		lg.print(item.name, x, y)
		y = y + self.fheight + self.ypad
	end

	y = y + 50
	lg.setColor(1, 1, 1, 1)
	lg.line(x, y, x + self.w, y)
	y = y + 10
	love.graphics.printf(selection.info, x, y, self.w)
end

function Inventory:update(dt)
	if not self.is_visible then
		return
	end

	alpha = alpha - d_alpha
	if alpha <= min_alpha or alpha >= max_alpha then
		d_alpha = d_alpha * -1
	end
end

function Inventory:keypressed(k)
	if k == "escape" then
		assert(self.parent).active_submenu = nil
		self.is_visible = false
	elseif k == "down" or k == "s" then
		self.selected_index = sugar.wrap(self.selected_index + 1, 1,
				#Gamestate.inventory_items)
		Sfx.sounds.ui_nav:play()
	elseif k == "up" or k == "w" then
		self.selected_index = sugar.wrap(self.selected_index - 1, 1,
				#Gamestate.inventory_items)
		Sfx.sounds.ui_nav:play()
	end
end

function Inventory:set_visible(v)
	self.is_visible = v
end

return Inventory
