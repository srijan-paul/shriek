local Item = class "Item"

local next_item_id = 0
---@param name string name of the item.
---@param conf table contains fields `info` (string) and `sprite` (Image | Quad).
function Item:init(name, conf)
    self.name = name
    self.id = next_item_id
    next_item_id = next_item_id + 1
    self.info = assert(conf.info, "Item needs information.")
    self.sprite = assert(conf.sprite, "Item needs display sprite.")
end

function Item:draw(x, y, r, sx, sy)
    lg.draw(self.sprite, x, y, r, sx, sy)
end

return Item