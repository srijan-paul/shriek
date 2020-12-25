local Menu = require "menu"
local InventoryMenu = require "inventory_menu"
local PMenu = Menu()

PMenu:add_option("INVENTORY", function ()
    PMenu:switch_to(InventoryMenu)
end)

PMenu:add_option("RESUME", function ()
    PMenu:deactivate()
end)

PMenu:add_option("QUIT", function ()
    print "no quit either lol"
end)

return PMenu