local Gamestate = require "gamestate"

local STATE_LORE = 1
local STATE_LETTER = 2
local STATE_KNOCK = 3

local Intro = {state = STATE_LORE, timer = 8}

local TWidth = DISPLAY_WIDTH / 1.5
local THeight = 0 -- changed below
local Tx = (DISPLAY_WIDTH - TWidth) / 2
local Ty = DISPLAY_HEIGHT / 4

local SkipText
function Intro:load()
	local text_obj = lg.newText(Resource.Font.Misc, "-")

	text_obj:setf(
			[[Folklore recites several tales of creatures looming in the cursed woods.
They come out of hiding past nightfall and knock furiously on doors and windows]] ..
					[[ of homes that house young and helpless human children.

Shall the unwary let them in, young children are dragged]] ..
					[[ away into the dread of the woods, their guts ripped apart and their flesh feasted upon.]],
			TWidth, "left")

	THeight = text_obj:getHeight()
	Intro.text = text_obj
	SkipText = lg.newText(Resource.Font.Misc, {
		WHITE, "Press [", YELLOW, "SPACE", WHITE, "] to continue."
	})
end

local Letter = [[
Timmy,
Your father and I have to leave the village for a while to tend to some important work.]] ..
[[I'm really sorry that you have to stay the night alone. We will be back by dawn.

Keep the doors locked, and don't forget to feed the cat! The village watchmen ]] ..
[[will be guarding the area so you can sleep well. In the event of an emergency,
call the village chief. Take care.

Love, 
Ma.
]]

function Intro:draw()
	lg.setColor(0, 0, 0)
	lg.rectangle("fill", 0, 0, SC_WIDTH, SC_HEIGHT)
	if self.state == STATE_LORE or self.state == STATE_LETTER then
		lg.setColor(1, 1, 1)
		lg.draw(self.text, Tx, Ty)
		if self.state == STATE_LORE then
			lg.draw(SkipText, Tx, Ty + THeight + 20)
		end
	end
end

function Intro:update(dt)
	if self.state == STATE_LETTER then
		self.timer = self.timer - dt
		if self.timer <= 0 then
			self.state = STATE_KNOCK
			Sfx.music.Lullaby:stop()
			Sfx.sounds.knock_x3:play()
			Sfx.sounds.glass_break:play()
			Timer.after(2, function()
				Sfx.music.rain:play()
				Gamestate.start_game()
			end)
		end
	end
end

function Intro:keypressed(k)
	if k == "space" then
		if self.state == STATE_LORE then
			self.state = STATE_LETTER
			Sfx.music.lullaby:play()
			self:set_text(Letter)
		end
	end
end

function Intro:set_text(s)
	self.text:setf(s, TWidth, "left")
end

Intro.ui_layer = function()
	-- empty but I still need this function cus bad c
end

return Intro
