local PMenu = {
	is_visible = false,
	select_alpha = 1,
	d_alpha = 0.01,
	min_alpha = 0.6
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
	return {text = t_obj, w = t_obj:getWidth(), h = t_obj:getHeight()}
end

local buttons = {make_opt("INVENTORY"), make_opt("RESUME"), make_opt("QUIT")}

local selected_opt = 1

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
	for i, b in ipairs(buttons) do
		if selected_opt == i then
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
  if not self.is_visible then return end
	self.select_alpha = self.select_alpha - self.d_alpha
	if self.select_alpha <= self.min_alpha or self.select_alpha >= 1 then
		self.d_alpha = self.d_alpha * -1
	end
end

function PMenu:keypressed(k)
	if k == "up" or k == "w" then
		selected_opt = selected_opt - 1
		if selected_opt < 1 then
			selected_opt = #buttons
		end
	elseif k == "down" or k == "s" then
		selected_opt = selected_opt + 1
		if selected_opt > #buttons then
			selected_opt = 1
		end
  elseif k == "escape" then
    self.is_visible = false
  else
		return
	end

	if Resource.Sfx.ui_select:isPlaying() then
		Resource.Sfx.ui_select:stop()
	end

	Resource.Sfx.ui_select:play()
end

return PMenu
