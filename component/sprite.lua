local Sprite = class("Sprite")

function Sprite:init(owner, drawable)
	self.owner = owner
	self.world = self.owner.world
	self.image = drawable
	self.width = drawable:getWidth()
	self.height = drawable:getHeight()
	self.owner.world:add_drawable(self)
	self.is_visible = true
end

function Sprite:draw()
	if not self.is_visible then
		return
	end

	local t = assert(self.owner.transform,
			"no transform component on sprite component owner")

	local dp = Vec2(self.width / 2, self.height / 2):rotated(t.rotation)
	local x = t.pos.x - dp.x
	local y = t.pos.y - dp.y

	if t.scale.x < 0 then
		x = x + self.width * -1 * t.scale.x
	end
	love.graphics.draw(self.image, x, y, t.rotation, t.scale.x, t.scale.y)
end

function Sprite:delete()
	self.world:remove_drawable(self)
end

return Sprite
