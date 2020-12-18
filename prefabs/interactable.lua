local Entt = require "prefabs.entity"
local UISprite = require "component.UISprite"
local Collider = require "component.collider"
local DialogManager = require "dialog"

local Interactable = class("Interactable", Entt)

function Interactable:init(world, x, y, config)
	Entt.init(self, world, x, y)
	self.radius = config.range

	self.btn = self:add_component(UISprite, Resource.Canvases.interact_btn)
	self.btn.is_visible = false
	-- function called when the player presses the interact button
	-- while standing in range of this object.
	self.callback = nil
	self.is_player_close = false
	-- if this is true then the callback isn't even
	-- when the player is close and presses the Interact button.
	self.is_callback_running = false

	-- optional collider component.
	if config.collider then
		local offset = config.collider.offset or Vec2.ZERO()
		self:add_component(Collider, assert(config.collider.width),
				assert(config.collider.height), "object", offset):add_mask("player")
	end
end

function Interactable:is_player_in_range()
	local ents = self.world:cquery(self:get_pos(), self.radius)
	for _, ent in ipairs(ents) do
		if ent.id == "player" then
			return true
		end
	end
	return false
end

function Interactable:_physics_process(_)
	if self:is_player_in_range() then
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

---@param fn function callback function.
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
