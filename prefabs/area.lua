local Entt = require "prefabs.entity"
local cmp = require "component"

local Area = class("Area", Entt)

function Area:init(world, x, y, w, h)
	Entt.init(self, world, x, y)
	self.w = w
	self.h = h
	self.colliding_bodies = {}
	self.enter_cb = nil
	self.exit_cb = nil
end

function Area:_physics_process(_)
	local nearby = self.world:query("rect", self:get_pos(), self.w, self.h)

	-- set of entities that are currently inside this area
	local current_set = {}

	-- table of entities that are newly added 
	-- to this area.
	local temp = {}

	for _, body in ipairs(nearby) do
		if body.id then
			if not self.colliding_bodies[body.id] then
				table.insert(temp, body)
			end
			current_set[body.id] = body
		end
	end

	for id, e in pairs(self.colliding_bodies) do
        if not current_set[id] then
			self.colliding_bodies[id] = nil
			if self.exit_cb then
				self.exit_cb(e)
			end
		end
	end

	for _, entt in ipairs(temp) do
        self.colliding_bodies[entt.id] = entt
		if self.enter_cb then
			self.enter_cb(entt)
		end
	end

end

function Area:on_body_enter(fn)
	self.enter_cb = fn
end

function Area:on_body_exit(fn)
	self.exit_cb = fn
end

return Area