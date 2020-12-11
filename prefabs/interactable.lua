local Entt = require "prefabs.entity"
local Sprite = require "component.sprite"

local Interactable = class("Interactable", Entt)

function Interactable:init(world, x, y, config)
	Entt.init(self, world, x, y)
	self.target = config.target
	self.radius = config.size

	self.btn = self:add_component(Sprite, Resource.Canvases.interact_btn)
	self.btn.is_visible = false
	self.callback = nil
	self.active = false
end

function Interactable:_physics_process(_)
	local dist = (self.target:get_pos() - self:get_pos()):mag()
	if dist < self.radius then
		self.btn.is_visible = true
		self.active = true
	elseif self.active then
		self.active = false
		self.btn.is_visible = false
	end
end

function Interactable:on_trigger(fn)
	self.callback = fn
end

return Interactable
