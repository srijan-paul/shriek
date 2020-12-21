local Collider = require "component/Collider"
local Grid = class("Grid")

local DEFAULT_ROWS, DEFAULT_COLS = 10, 10

function Grid:init(world, rows, cols)
	self.world = world
	self.rows = rows or DEFAULT_ROWS
	self.cols = cols or DEFAULT_COLS
	self.cell_width = world.width / self.cols
	self.cell_height = world.height / self.rows
	self.cells = {}
	for i = 1, self.rows do
		self.cells[i] = {}
		for j = 1, self.cols do
			self.cells[i][j] = {}
		end
	end
end

function Grid:insert(collider)
	local pos = collider:topleft()
	local row, col = self:toRowCol(pos.x, pos.y)
	local endRow, endCol = self:toRowCol(pos.x + collider.width,
			pos.y + collider.height)

	for i = row, endRow do
		for j = col, endCol do
			table.insert(self.cells[i][j], collider)
		end
	end
end

function Grid:clear()
	for i = 1, self.rows do
		self.cells[i] = {}
		for j = 1, self.cols do
			self.cells[i][j] = {}
		end
	end
end

function Grid:toRowCol(_x, _y)
	local col = math.floor(_x / self.cell_width) + 1
	local row = math.floor(_y / self.cell_height) + 1

	if row > self.rows then
		row = self.rows
	elseif row < 1 then
		row = 1
	end

	if col > self.cols then
		col = self.cols
	elseif col < 1 then
		col = 1
	end
	return row, col
end

function Grid:draw()
	for i = 1, self.rows do
		for j = 1, self.cols do
			love.graphics.setColor(1, 1, 1, 0.1)
			local x, y = (j - 1) * self.cell_height, (i - 1) * self.cell_height
			local w, h = self.cell_width, self.cell_height
			love.graphics.rectangle("line", x, y, w, h)
			if #self.cells[i][j] > 0 then
				love.graphics.setColor(1, 1, 1, 0.1 * #self.cells[i][j])
				love.graphics.rectangle("fill", x, y, w, h)
			end
			local centerX = x + self.cell_width / 2 - 10
			local centerY = y + self.cell_height / 2 - 10
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.print(#self.cells[i][j], centerX, centerY)
		end
	end
end

function Grid:process_collision(c1, c2)
	local a, b
	if c1:collides_with(c2.class) then
		a, b = c1, c2
	elseif c2:collides_with(c1.class) then
		a, b = c2, c1
	else
		return
	end

	if Collider.checkAABB(a, b) then
		a.owner:on_collide(b.owner, Collider.AABBdir(a, b), a, b)
	end
end

function Grid:process_cell(i, j)
	local cell = self.cells[i][j]
	for x = 1, #cell do
		local c1 = cell[x]
		for y = x + 1, #cell do
			local c2 = cell[y]
			Grid:process_collision(c1, c2)
		end
	end
end

function Grid:process_collisions()
	for i = 1, self.rows do
		for j = 1, self.cols do
			self:process_cell(i, j)
		end
	end
end


local function rect_intersect(x1, y1, w1, h1, x2, y2, w2, h2)
	return not ((x1 > x2 + w2) or (x1 + w1 < x2) or
	(y1 + h1 < y2) or (y1 > y2 + h2))
end

local grid_query = {
	["circle"] = function(grid, center, radius)
		local x = center.x
		local y = center.y
		local start_row, start_col = grid:toRowCol((x - radius), (y - radius))
		local end_row, end_col = grid:toRowCol((x + radius), y + radius)

		local game_objects = {}

		for i = start_row, end_row do
			for j = start_col, end_col do
				for k = 1, #grid.cells[i][j] do
					local pos = grid.cells[i][j][k]:get_pos()
					if (pos - center):mag() < radius then
						table.insert(game_objects, grid.cells[i][j][k].owner)
					end
				end
			end
		end

		return game_objects
	end,

	["rect"] = function (grid, topleft, w, h)
		local x, y = topleft.x, topleft.y
		local start_row, start_col = grid:toRowCol(x, y)
		local end_row, end_col = grid:toRowCol(x + w, y + h)

		local game_objects = {}

		for i = start_row, end_row do
			for j = start_col, end_col do
				local cell = grid.cells[i][j]
				for k = 1, #cell do
					local c =  cell[k]
					local tl = c:topleft()
					if rect_intersect(x, y, w, h, tl.x, tl.y, c.width, c.height) then
						table.insert(game_objects, c.owner)
					end
				end
			end
		end

		return game_objects
	end
}

function Grid:query(shape, point, w, h)
	return grid_query[shape](self, point, w, h)
end

return Grid
