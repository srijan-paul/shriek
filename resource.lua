local janim = require "lib.janim"
_G.Sfx = require "audio.sfx"

local Resource = {Sprite = {}, Canvases = {}, Font = {}}

function Resource.load()
	local rs = Resource.Sprite
	rs.Box = lg.newImage("assets/images/temp.png")
	rs.LivingRoom = lg.newImage("assets/images/base_room.png")
	rs.BedRoom = lg.newImage("assets/images/bedroom.png")
	rs.FrontRoom = lg.newImage("assets/images/entrance.png")
	rs.StudyRoom = lg.newImage("assets/images/study.png")
	rs.Player = janim.newSpriteSheet("assets/images/player.png", 4, 1)
	rs.TorchItem = lg.newImage("assets/images/torch.png")
	rs.PagerItem = lg.newImage("assets/images/pager.png")

	Sfx.load()

	local rf = Resource.Font
	rf.dialog = lg.newFont("assets/font/VCR_OSD_MONO_1.001.ttf", 22)
	rf.Ui = lg.newFont("assets/font/rainyhearts.ttf", 25)
	rf.Misc = lg.newFont("assets/font/Louis George Cafe.ttf", 20)

	local rc = Resource.Canvases
	rc.interact_btn = lg.newText(rf.Ui, "Interact")
end

return Resource
