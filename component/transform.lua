local Transform = class "Transform"

function Transform:init(owner, x, y, r, sx, sy)
	self.owner = owner
	self.pos = Vec2(x, y)
	self.rotation = r or 0
	self.scale = Vec2(sx or 1, sy or 1)
end

return Transform
