local Pager = {
	is_visible = true,
	history = {{time = "12:10 AM", message = "Hello world"}}
}

local sender_name = "Liam"
local alpha = 0.7
local color = {0, 0, 0, alpha}

local box_bounds = {
	x = 50,
	y = 50,
	width = DISPLAY_WIDTH - 100,
	height = DISPLAY_HEIGHT - 100
}

local text_padding = 20

local function draw_messages()
	local x, y = box_bounds.x + text_padding, box_bounds.y + text_padding
	local fh = Resource.Font.Ui:getHeight()
	lg.setFont(Resource.Font.Ui)
	sugar.foreach(Pager.history, function(e)
		lg.print(sender_name .. string.rep(" ", 10) .. e.time, x, y)
		lg.print(e.message, x, y + fh + 2)
	end)
end

function Pager:draw()
	if not self.is_visible then
		return
	end
	lg.setColor(color)
	lg.rectangle("fill", 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT)
	lg.setColor(1, 1, 1, 1)
	draw_messages()
	lg.rectangle("line", box_bounds.x, box_bounds.y, box_bounds.width,
			box_bounds.height)
end

function Pager:update(dt)
	if lk.isDown("tab") then
		self.is_visible = true
	else
		self.is_visible = false
	end
end

---@param time string eg- "11:59 PM"
---@param message string eg- "Helloooo"
function Pager:add(time, message)
	table.insert(self.history, {time = time, message = message})
end

return Pager
