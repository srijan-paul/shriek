local Transform = require("component/transform")

local Entity = class "Entity"

function Entity:init(world, x, y, r, sx, sy)
	self.world = world
	self._components = {}
	-- (component_class -> number) map.
	-- Maps a component type to an index into the
	-- _components array.
	self._cmp_map = {}
	self.transform = self:add_component(Transform, x, y, r, sx, sy)
	world:add_gameobject(self)
end

function Entity:add_component(comp, ...)
	-- TODO assert component doesn't already exist
	local c = comp(self, ...)
	self._components[#self._components + 1] = c
	self._cmp_map[comp] = #self._components
	return c
end

function Entity:get_component(cmp)
	return self._components[self._cmp_map[cmp]]
end

function Entity:has_component(cmp)
	return self._cmp_map[cmp] ~= nil
end

function Entity:update(dt)
	for i = 1, #self._components do
		local c = self._components[i]
		if c.update then
			c:update(dt)
		end
	end
end

function Entity:remove_component(...)
	local args = {...}
	for i = 1, #args do
		local component_type = args[i]
		local index = self._cmp_map[component_type]
		if index then
			local component = self._components[index]
			if component.delete then
				component:delete()
			end
			table.remove(self._components, index)
			self._cmp_map[component_type] = nil
		end
	end
end

-- This method is overriden by the deriving
-- class that implements an entity.
function Entity:_physics_process(dt)
	-- body
end

function Entity:delete()
	self.world:remove_gameobject(self)
	for _, comp in pairs(self._components) do
		if comp.delete then
			comp:delete()
		end
	end
end

function Entity:get_pos()
	return self.transform.pos:clone()
end

function Entity:getx()
	return self.transform.pos.x
end

function Entity:gety()
	return self.transform.pos.y
end

function Entity:set_pos(p)
	self.transform.pos = p:clone()
end

function Entity:setx(x)
	self.transform.pos.x = x
end

function Entity:sety(y)
	self.transform.pos.y = y
end

function Entity:get_scale()
	return self.transform.scale:clone()
end

function Entity:set_scale(sx, sy)
	self.transform.scale = Vec2(sx, sy)
end

function Entity:set_xscale(x)
	self.transform.scale.x = x
end

function Entity:rotation()
	return self.transform.rotation
end

function Entity:set_rotation(r)
	self.transform.rotation = r
end

function Entity:rotate(angle)
	local t = self.transform
	t.rotation = t.rotation + angle
end

function Entity:move(velocity)
	local t = self.transform
	t.pos = t.pos + velocity
end

function Entity:on_collide(other, dir)
	-- override
end

function Entity:on_tile_collide(tile_pos)
	-- override
end

---Resolves collision by placing the entity that owns collider `b`
---outside the body of the entity that owns collider `a`. Direction
---`dir` is the direction of collision from `b`'s perspective.
function Entity.resolve_collision(a_collider, b_collider, dir)
	if dir == "up" then
		local y = a_collider:gety() + a_collider.height / 2 + b_collider.height / 2
		b_collider:sety(y)
	elseif dir == "down" then
		local y = a_collider:gety() - a_collider.height / 2 - b_collider.height / 2
		b_collider:sety(y)
	elseif dir == "left" then
		local x = a_collider:getx() + a_collider.width / 2 + b_collider.width / 2
		b_collider:setx(x)
	else
		local x = a_collider:getx() - a_collider.width / 2 - b_collider.width / 2
		b_collider:setx(x)
	end
end

return Entity
