local Entt = require "prefabs.entity"
local Sprite = require "component.sprite"
local Collider = require "component.collider"

local Interactable = class("Interactable", Entt)

local interactBtn = love.graphics.newCanvas(10, 10)
interactBtn:renderTo(function()
	lg.setColor(0, 0, 0)
	lg.rectangle("fill", 0, 0, 10, 10)
	lg.setColor(1, 1, 1)
	lg.print("E", 3, 3)
end)

function Interactable:init(world, x, y, config)
	Entt:init(self, world, x, y)
	self:add_component(Sprite, config.sprite)
	self:add_component(Collider, assert(config.height), assert(config.height),
			Vec2.ZERO())
	self.btn = self:add_component(Sprite, interactBtn)
	self.callback = nil
end

function Interactable:on_trigger(fn)
	self.callback = fn
end

