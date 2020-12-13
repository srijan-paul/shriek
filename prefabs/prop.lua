local Entity = require "prefabs.entity"
local cmp = require "component"

local Prop = class("Prop", Entity)

function Prop:init(world, x, y, config)
	Entity.init(self, world, x, y)
	if config.sprite then
		self:add_component(cmp.Sprite, config.sprite)
	end

	if config.collision then
		self:add_component(cmp.Collider, assert(config.collision.width),
				assert(config.collision.height), "prop",
				config.collision.offset or Vec2.ZERO()):add_mask("player")
	end
end

function Prop:on_collide(_, dir, this_collider, entt_collider)
	if entt_collider.class == "player" then
		Entity.resolve_collision(this_collider, entt_collider, dir)
	end
end

return Prop
