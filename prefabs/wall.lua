local Entt = require "prefabs.entity"
local Collider = require "component.collider"
local Wall = class("Wall", Entt)

function Wall:init(world, x, y, w, h)
	Entt.init(self, world, x, y)
	self.w = w
	self.h = h
	self:add_component(Collider, w, h, "wall"):add_mask("player")
end

function Wall:on_collide(entt, dir, _, other_collider)
	if other_collider.class == "player" then
		if dir == "up" then
			entt:sety(self:gety() + self.h / 2 + other_collider.height / 2)
		end
	end
end

return Wall

