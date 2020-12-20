local Entt = require "prefabs.entity"
local Sprite = require "component.sprite"
local UISprite = require "component.UISprite"
local Collider = require "component.collider"
local DialogManager = require "dialog"

local torch = require "torch"

local Interactable = class("Interactable", Entt)

---TODO
---@param text string
local function make_ui_text(text)
	return lg.newText(Resource.Font.Ui, text)
end

function Interactable:init(world, x, y, config)
	Entt.init(self, world, x, y)
	self.radius = config.range

	local text = config.text and make_ui_text(config.text) or
             			Resource.Canvases.interact_btn
	self.btn = self:add_component(UISprite, text)
	self.btn.is_visible = false
	-- function called when the player presses the interact button
	-- while standing in range of this object.
	self.callback = nil

	-- function called when the interaction sequence
	-- is finished.
	self.on_end = nil
	self.is_player_close = false
	-- if this is true then the callback isn't even
	-- when the player is close and presses the Interact button.
	self.is_callback_running = false

	-- whether this object can only be interacted with when the 
	-- flashlight is on. Is `true` by default
	self.vision_triggered = type(config.vision_triggered) == "nil" and true or
                        			config.vision_triggered
	-- whether or not this event is unlocked yet
	self.active = type(config.active) == "nil" and true or config.active
	-- optional collider component.
	if config.collider then
		local offset = config.collider.offset or Vec2.ZERO()
		self:add_component(Collider, assert(config.collider.width),
				assert(config.collider.height), "object", offset):add_mask("player")
	end

	if config.sprite then
		self:add_component(Sprite, config.sprite)
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
	if self:is_player_in_range() and (torch.on or not self.vision_triggered) and
			self.active then
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
	return self
end

function Interactable:on_end(fn, delay)
	if delay then
		self.on_end = function()
			Timer.after(delay, fn)
		end
	else
		self.on_end = fn
	end
	return self
end

function Interactable:end_sequence()
	self.is_callback_running = false
	self.btn.is_visible = true
	if self.on_end then
		self:on_end()
	end
	Moan.clearMessages()
end

function Interactable:start_sequence()
	self.btn.is_visible = false
	self.is_callback_running = true
	self.callback()
end

return Interactable
