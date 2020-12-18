local UISprite = class "UISprite"
local camera = require "camera"

function UISprite:init(owner, drawable)
	self.owner = owner
	self.img = drawable
	self.width = drawable:getWidth()
	self.height = drawable:getHeight()
	self.is_visible = true
	owner.world:add_ui_element(self)
end

function UISprite:draw()
	if not self.is_visible then
		return
	end
	local t = assert(self.owner.transform, "no transform on owner")
	local dp = Vec2(0, 0)
	local x = t.pos.x - dp.x
	local y = t.pos.y - dp.y
	local pos = camera:toScreenPos(Vec2(x, y))
	lg.draw(self.img, pos.x, pos.y, t.r)
end

function UISprite:delete()
	self.owner.world:remove_ui_element(self)
end

function UISprite:remove_from_world(world)
	world:remove_ui_element(self)
end

function UISprite:add_to_world(world)
	world:add_ui_element(self)
end

return UISprite
