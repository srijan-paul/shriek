local Entt = require "prefabs.entity"
local cmp = require "component"

local AABB_WIDTH, AABB_HEIGHT = 7, 10
local AABB_OFFSET = Vec2(-2, -1)
local MOVE_SPEED = 0.6
local Player = class("Player", Entt)

local State = {MOVE = 1, IDLE = 2}

function Player:init(world, x, y)
	Entt.init(self, world, x, y)
	self:set_scale(0.8, 0.8)
	self:add_component(cmp.Collider, AABB_WIDTH, AABB_HEIGHT, "player", AABB_OFFSET)
	self.anim = self:add_component(cmp.AnimSprite, Resource.Sprite.Player, {
		{"walk_down", 1, 4, 0.15, true}, {"walk_left", 1, 4, 0.15, true}, --
		{"idle_down", 2, 2, 0, false}, {"idle_right", 2, 2, 0, false}, --
		{"idle_left", 2, 2, 0, false}
	})
	self.id = "player"
	self.anim:play("idle_down")
	self.state = State.IDLE
	self.footstep_audio = self:add_component(cmp.AudioPlayer,
			Resource.Sfx.Steps.Wood, true)

	self.face_dir = Direction.DOWN
	self.footstep_audio:set_duration(0.4)
end

function Player:handle_input(x_dir, y_dir)
	local vel = Vec2(x_dir, y_dir):with_mag(MOVE_SPEED)

	if vel.x ~= 0 or vel.y ~= 0 then
		self.state = State.MOVE
		self.footstep_audio:play()
	else
		self.state = State.IDLE
		self.anim:play("idle_" .. Direction.string(self.face_dir))
		self.footstep_audio:pause()
		return
	end

	self:move(vel)

	if x_dir == -1 then
		self.anim:play("walk_left")
		self:set_xscale(-0.8)
		self.face_dir = Direction.LEFT
	elseif x_dir == 1 then
		self.anim:play("walk_left")
		self:set_xscale(0.8)
		self.face_dir = Direction.RIGHT
	end

	if y_dir == 1 then
		self.anim:play("walk_down")
		self.face_dir = Direction.DOWN
	end

end

function Player:_physics_process(dt)

end

return Player
