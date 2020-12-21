local Grid = require "world/grid"
local cmp = require "component"
local Particles = require "particles.init"

local World = class "World"

local tinsert = table.insert
local tremove = table.remove

local TIME_STEP = 0.016

function World:init(width, height)
	self.width = width or 160
	self.height = height or 160

	self.particle_manager = Particles.Manager()
	self.drawables = {}
	self.entities = {}
	self.ui_drawables = {}

	self.grid = Grid(self, 5, 5)

	self.time_elapsed = 0
end

function World:draw()
	for i = 1, #self.drawables do
		self.drawables[i]:draw()
	end
	self.particle_manager:draw()
	-- * DEBUG CODE
	-- self.grid:draw()

	-- lg.setColor(1, 0, 0, 1)

	-- for i = 1, #self.entities do
	-- 	local e = self.entities[i]
	-- 	lg.setColor(1, 0.1, 0.1)
	-- 	if e:has_component(cmp.Collider) then
	-- 		e:get_component(cmp.Collider):draw()
	-- 	end
	-- end

	-- lg.setColor(1, 1, 1, 1)
	-- love.graphics.rectangle("line", 0, 0, self.width, self.height)
	-- * / DEBUG CODE
end

function World:ui_layer()
	for _, ui_el in ipairs(self.ui_drawables) do
		ui_el:draw()
	end
end

-- remove all 'dead' gameobjects/entities
-- from the entities array. Does the same for all 
-- drawables.
function World:clear_garbage()
	for i = #self.drawables, 1, -1 do
		local d = self.drawables[i]
		if d._delete_flag then
			tremove(self.drawables, i)
			d._delete_flag = false
		end
	end

	for i = #self.entities, 1, -1 do
		local e = self.entities[i]
		if e._delete_flag then
			tremove(self.entities, i)
			for _, comp in ipairs(e._components) do
				if comp.remove_from_world then
					comp:remove_from_world(self)
				end
			end
			e._delete_flag = false
		end
	end

	for i = #self.ui_drawables, 1, -1 do
		local d = self.ui_drawables[i]
		if d._delete_flag then
			tremove(self.ui_drawables, i)
			d._delete_flag = false
		end
	end
end

function World:update(dt)
	self:clear_garbage()
	self.time_elapsed = self.time_elapsed + dt

	for i = #self.entities, 1, -1 do
		self.entities[i]:update(dt)
		self:bounds_check(self.entities[i])
	end

	while self.time_elapsed >= TIME_STEP do
		self:_physics_process(self.time_elapsed)
		self.time_elapsed = self.time_elapsed - TIME_STEP
	end

	self.particle_manager:update(dt)
end

-- check if an entity's collider is outside the level's rectangle bounds.
-- If so, then clamp the entity's position and call the 
-- 'on_world_exit' callback.
function World:bounds_check(e)
	if not e:has_component(cmp.Collider) then
		return
	end

	local collider = e:get_component(cmp.Collider)
	local pos = collider:get_pos()

	local check_left = pos.x < collider.width / 2
	local check_right = pos.x > self.width - collider.width / 2

	local check_top = pos.y > self.height - collider.height / 2
	local check_bottom = pos.y < collider.height / 2

	if check_left or check_right or check_top or check_bottom then
		local x = sugar.clamp(pos.x, collider.width / 2,
				self.width - collider.width / 2)

		local y = sugar.clamp(pos.y, collider.height / 2,
				self.height - collider.height / 2)
		local p = Vec2(x, y)
		collider:set_pos(p)

		if collider.owner.on_world_exit then
			collider.owner:on_world_exit()
		end
	end
end

function World:_physics_process(dt)
	self.grid:clear()

	for i = #self.entities, 1, -1 do
		local e = self.entities[i]
		-- ? refactor this out into a collider array ??
		if self.entities[i]:has_component(cmp.Collider) then
			self.grid:insert(self.entities[i]:get_component(cmp.Collider))
		end
	end

	for i = #self.entities, 1, -1 do
		self.entities[i]:_physics_process(dt)
	end

	self.grid:process_collisions()
end

function World:add_drawable(d)
	-- TODO: after depth sorting, change this logic
	--  to insert in sorted array
	d.__depth = #self.drawables
	tinsert(self.drawables, d)
end

function World:add_ui_element(el)
	tinsert(self.ui_drawables, el)
end

function World:remove_ui_element(el)
	el._delete_flag = true
end

function World:add_gameobject(e)
	-- TODO: register and handle collision classes as well
	e.world = self
	for _, comp in ipairs(e._components) do
		if comp.add_to_world then
			comp._delete_flag = false
			comp:add_to_world(self)
		end
	end
	tinsert(self.entities, e)
end

function World:remove_drawable(d)
	d._delete_flag = true
end

function World:remove_gameobject(g)
	g._delete_flag = true
	for _, comp in ipairs(g._components) do
		if comp.remove_from_world then
			comp._delete_flag = true
		end
	end
end

function World:query(shape, tl, w, h)
	return self.grid:query(shape, tl, w, h)
end

---Returns a table containing all entities having a 
---collider component in `radius` range of `center` coordinate.
---@param center table Vector representing the center of the query circle
---@param radius number search radius
---@return table
function World:cquery(center, radius)
	return self.grid:query("circle", center, radius)
end

function World:add_particle_system(sys)
	self.particle_manager:add_system(sys)
	return sys
end

function World:remove_particle_system(sys)
	self.particle_manager:remove_system(sys)
end

return World
