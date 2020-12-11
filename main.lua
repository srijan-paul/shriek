local shader = require("shader")
_G.lg = love.graphics
_G.lk = love.keyboard
_G.lm = love.mouse

-- configuration settings go here:

-- width and height of the window
_G.WIN_WIDTH = 800
_G.WIN_HEIGHT = 600

_G.Resource = require "resource"
local game = require("game")

-- width and height of the cursor in pixels
local CURSOR_SCALE_X = 3
local CURSOR_SCALE_Y = 3
-- if true then the default mouse pointer is visible over the cursor.
local IS_MOUSE_POINTER_VISIBLE = false

-- the variables here are modified by `love.load`
local CURSOR_OFFSET_X, CURSOR_OFFSET_Y = 0, 0
local crosshair = nil

-- mouse helper functions and custom cursor.
_G.mouseX = lm.getX
_G.mouseY = lm.getY

-- @return Vec2: current mouse position as a 2D vector.
function _G.mousePos()
	return Vec2(mouseX(), mouseY())
end

-- draws the custom cursor image at current mouse location.
local function draw_cursor()
	local x = love.mouse.getX() + CURSOR_OFFSET_X
	local y = love.mouse.getY() + CURSOR_OFFSET_Y
	lg.setColor(1, 1, 1, 1)
	lg.draw(crosshair, x, y, 0, CURSOR_SCALE_X, CURSOR_SCALE_Y)
end

math.randomseed(os.time())

local display_scale = 1
function love.load()

	-- record the screen width and screen height of the player's monitor
	if GameSettings.fullscreen then
		love.window.setMode(0, 0)
	end
	_G.SC_WIDTH = love.graphics.getWidth()
	_G.SC_HEIGHT = love.graphics.getHeight()

	display_scale = SC_HEIGHT / WIN_HEIGHT
	SCREEN_OFFSET_X = (SC_WIDTH - WIN_WIDTH) / 4
	love.window
			.setMode(SC_WIDTH, SC_HEIGHT, {fullscreen = GameSettings.fullscreen})

	DISPLAY_WIDTH = SC_WIDTH * display_scale
	DISPLAY_HEIGHT = SC_HEIGHT * display_scale

	lg.setLineStyle("rough")
	love.mouse.setVisible(IS_MOUSE_POINTER_VISIBLE)
	lg.setDefaultFilter("nearest", "nearest")

	crosshair = love.graphics.newImage("assets/cursor.png")
	local cursorWidth = crosshair:getWidth()
	local cursorHeight = crosshair:getHeight()
	CURSOR_OFFSET_X = -(cursorWidth / 2) * CURSOR_SCALE_X
	CURSOR_OFFSET_Y = -(cursorHeight / 2) * CURSOR_SCALE_Y

	_G.Input = require "lib.boipushy.input"()
	Resource.load()
	game.load()
end

local main_canvas = love.graphics.newCanvas()
function love.draw()
	main_canvas:renderTo(function()
		lg.clear()
		game.draw()
	end)

	-- send data to `shader` here.
	game.shade(shader)
	-- shader:send("screen_size", {SC_WIDTH, SC_HEIGHT})
	love.graphics.setShader(shader)
	lg.draw(main_canvas, SCREEN_OFFSET_X, 0, 0, display_scale, display_scale)
	love.graphics.setShader()
	draw_cursor()
end

function love.update(dt)
	game.update(dt)
end
