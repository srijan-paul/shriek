local sfx = {sounds = {}, music = {}}

local dir = "assets/sound/"
local la = love.audio

local function static_src(name)
	return la.newSource(dir .. name, "static")
end

function sfx.load()
	local sounds = sfx.sounds
	sounds["wood_step"] = static_src("wood02.ogg");
    sounds["type"] = static_src("type2.wav")

    -- credit: https://freesound.org/people/InspectorJ/sounds/343130/
    sounds["tick_tock"] = static_src("343130__inspectorj__ticking-clock-a.ogg")

    sounds["door_open"] = static_src("431117__inspectorj__door-front-opening-a.wav")
    -- credit: https://opengameart.org/content/breaking-bottle
	-- spookymodem
    sounds["glass_break"] = static_src("Bottle-Break.ogg")
	-- credits: https://opengameart.org/content/light-switch-on-sfx-sound-effect
    sounds["switch_on"] = static_src("Light-Switch-Click-On-Sfx.ogg")

    -- credits: https://opengameart.org/content/pickupplastic-sound
	-- Vinrax on OpenGameArt
    sounds["pick_item"] = static_src("pickup.ogg")
    sounds["knock_x3"] = static_src("6501__rondomat__knocking-3.ogg")

	-- credits: https://opengameart.org/content/menu-selection-click
    sounds["hint"] = static_src("hint.ogg")
    sounds["phone_ring"] = static_src("phone-ring.ogg")
    
	-- credit: https://opengameart.org/content/bad-sound-1
    sounds["objective"] = static_src("lose-sound-1_0.ogg")
    sounds["beep"] = static_src("beep.ogg")

    --credits - littlerobot on freesound
    sounds["ui_select"] = static_src("270401__littlerobotsoundfactory__menu-select-00.ogg")
    sounds["ui_nav"] = static_src("253168__suntemple__sfx-ui-button-click.wav")

    local m = sfx.music

	-- credits: https://opengameart.org/content/ambient-noise
    m["ambient_1"] = static_src("ambient1.ogg")

    -- credits: https://freesound.org/people/klankbeeld
    m["lullaby"] = static_src("369542__klankbeeld__musicbox-brahms-lullaby-loop.ogg")
    
	-- credits for Rain and thunder sound effect: https://opengameart.org/content/rain-and-thunders
    m["rain"] = static_src("Dark_Rainy_Nightambience.ogg")
end


return sfx