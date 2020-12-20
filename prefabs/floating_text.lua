local FloatingText = class "FloatingText"

---@param coloredtext table {color1, string1, color2, string2}
---@param x number
---@param y number
---@param dy number
function FloatingText:init(coloredtext, x, y, dy, duration, fade_out)
	self.text = lg.newText(Resource.Font.Ui, coloredtext)
	self.x = x
	self.y = y
	self.dy = dy or 0
	self.dead = false
	self.duration = duration or nil
	self.alpha = 1
	self.fade_out = fade_out
end

function FloatingText:draw()
	lg.setColor(1, 1, 1, self.alpha)
	lg.draw(self.text, self.x, self.y)
	lg.setColor(1, 1, 1, 1)
end

function FloatingText:update(dt)
	if self.duration then
		self.duration = self.duration - dt
		if self.duration <= 0 then
			self.dead = true
		end
	end

	if self.fade_out then
		self.alpha = self.alpha - 0.002
	end
	self.y = self.y + self.dy
end

return FloatingText

