local Entt = require "prefabs.entity"
local cmp = require "component"

local AABB_WIDTH, AABB_HEIGHT = 16, 16
local MOVE_SPEED = 0.6
local Player = class("Player", Entt)

local State = {MOVE = 1, IDLE = 2}

function Player:init(world, x, y)
	Entt.init(self, world, x, y)
	self:add_component(cmp.Collider, AABB_WIDTH, AABB_HEIGHT, "player")
	self:add_component(cmp.Sprite, Resource.Sprite.Box)
	self.state = State.IDLE
	self.footstep_audio = self:add_component(cmp.AudioPlayer,
			Resource.Sfx.Steps.Wood, true)
	self.footstep_audio:set_duration(0.4)
	self.footstep_audio:set_volume(0.5)
end

function Player:update(dt)
	Entt.update(self, dt)
	local xvel = Input:keydown("d") - Input:keydown("a")
	local yvel = Input:keydown("s") - Input:keydown("w")
	local vel = Vec2(xvel, yvel) * MOVE_SPEED

	if vel.x ~= 0 or vel.y ~= 0 then
		self.state = State.MOVE
		-- self.footstep_audio:play()
	else
		self.state = State.IDLE
		-- self.footstep_audio:pause()
	end

	self:move(vel)
end

function Player:_physics_process(dt)

end

return Player
