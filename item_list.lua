local Item = require "prefabs.item"

lg.setDefaultFilter("nearest", "nearest")
return {
	FlashLight = Item("FLASHLIGHT", {
		info = "A flashlight. Can help see in the dark, but might attract unwanted attention.",
		sprite = lg.newImage("assets/images/item_fl.png")
	}),
	Pager = Item("PAGER", {
		info = "A one way pager. can recieve messages.",
		sprite = lg.newImage("assets/images/item_pager.png")
	})
}
