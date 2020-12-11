local Entt = require "prefabs.entity"
local UISprite = require "component.UISprite"
local DialogManager = require "dialog"

local Interactable = class("Interactable", Entt)

function Interactable:init(world, x, y, config)
	Entt.init(self, world, x, y)
	self.target = config.target
	self.radius = config.size

	self.btn = self:add_component(UISprite, Resource.Canvases.interact_btn)
	self.btn.is_visible = false
	self.callback = nil
	self.is_player_close = false
	-- if this is true then the callback isn't even
	-- when the player is close and presses the Interact button.
	self.is_callback_running = false
end

function Interactable:_physics_process(_)
	local dist = (self.target:get_pos() - self:get_pos()):mag()
	if dist < self.radius then
		if self.is_player_close then
			if lk.isDown("e") and not self.is_callback_running and self.callback then
				DialogManager:start(self.callback, self)
			end
			return
		end
		self.btn.is_visible = true
		self.is_player_close = true
	else
		self.is_player_close = false
		self.btn.is_visible = false
	end
end

function Interactable:on_trigger(fn)
	self.callback = fn
end

function Interactable:end_sequence()
	self.is_callback_running = false
	self.btn.is_visible = true
	Moan.clearMessages()
end

function Interactable:start_sequence()
	self.btn.is_visible = false
	self.is_callback_running = true
	self.callback()
end

return Interactable
