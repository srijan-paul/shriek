local Entity = require "prefabs.entity"
local cmp = require "component"

local Prop = class("Prop", Entity)

function Prop:init(world, x, y, config)
	Entity.init(self, world, x, y)
	self:add_component(cmp.Sprite, assert(config.sprite, "sprite missing!"))
	if config.collision then
		self:add_component(cmp.Collider, config.collision.width,
				config.collision.height, "prop", config.collision.offset or Vec2.ZERO())
	end
end

return Prop
