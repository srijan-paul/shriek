local Transform = require "component/transform"
-- *AABB rect collider

local Collider = class "Collider"

function Collider:init(entity, width, height, class, offset)
	self.owner = entity
	self.width = width
	self.height = height
	-- the offset of this collider from the
	-- parent entitiy's center. Not
	-- all colliders necessarily need to be
	-- centered on the parent entity's transform

	-- For example, bullets only have a small square collider
	-- near the top.
	self.offset = offset or Vec2.ZERO()
	-- the collision class this component
	-- belongs to.
	self.class = class or ""
	-- the set of collision classes
	-- that this collider collides with.
	self.mask = {}
end

function Collider:collides_with(class)
	return self.mask[class]
end

function Collider:add_mask(class)
	self.mask[class] = true
end

function Collider:add_masks(...)
	local args = {...}
	for i = 1, #args do
		self.mask[args[i]] = true
	end
end

function Collider:get_pos()
	-- transform is the center coordinate
	local t = assert(self.owner.transform,
			"no transform component on collider parent")
	return t.pos + self.offset:rotated(t.rotation)
end

function Collider:set_pos(p)
	self.owner:set_pos(p - self:get_offset())
end

function Collider:get_offset()
	return self.offset:rotated(assert(self.owner.transform).rotation)
end

function Collider:getx()
	return self:get_pos().x
end

function Collider:gety()
	return self:get_pos().y
end

function Collider:setx(x)
	local xoff = self:get_offset().x
	self.owner:setx(x - xoff)
end

function Collider:sety(y)
	local yoff = self:get_offset().y
	self.owner:sety(y - yoff)
end

function Collider:topleft()
	return self:get_pos() - Vec2(self.width / 2, self.height / 2)
end

function Collider:set_topleft(x, y)
	self.owner:set_pos(Vec2(x, y) + Vec2(self.width / 2, self.height / 2))
end

function Collider.checkAABB(r1, r2)
	-- get the top-right corner coordinates
	-- from the transform's center coordinates.
	local p1 = r1:topleft()
	local p2 = r2:topleft()
	return not ((p1.x > p2.x + r2.width) or (p1.x + r1.width < p2.x) or
       			(p1.y + r1.height < p2.y) or (p1.y > p2.y + r2.height))
end

function Collider.AABBdir(a, b)
	local apos = a:topleft()
	local bpos = b:topleft()

	local a_bottom = apos.y + a.height
	local a_right = apos.x + a.width
	local b_bottom = bpos.y + b.height
	local b_right = bpos.x + b.width

	local top = a_bottom - bpos.y
	local down = b_bottom - apos.y
	local left = a_right - bpos.x
	local right = b_right - apos.x

	local min = math.min(down, right, top, left)

	if top == min then
		return "up"
	end

	if down == min then
		return "down"
	end

	if left == min then
		return "left"
	end

	return "right"
end

function Collider:draw()
	local pos = self:get_pos()
	love.graphics.rectangle("line", pos.x - self.width / 2,
			pos.y - self.height / 2, self.width, self.height)
end

function Collider:update(dt)
	-- body
end

return Collider
