local World = require "world.world"
local camera = require "camera"

local Room = class "Room"

function Room:init(conf, initfn)
	self.width = conf.width
	self.height = conf.height
	self.world = World(conf.width, conf.height)
	self.bgImg = conf.image
	self.entry_points = conf.entry_points or {}
	if initfn then
		initfn(self.world, self)
	end
end

function Room:initialize(fn)
	fn(self.world)
end

function Room:draw()
	camera:set()
	lg.draw(self.bgImg, 0, 0)
	self.world:draw()
	camera:unset()
end

function Room:update(dt)
	self.world:update(dt)
end

function Room:ui_layer()
	self.world:ui_layer()
end

return Room
