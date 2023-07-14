local ItemTile = require "widgets/itemtile"
local GetOriginalDescriptionString = ItemTile.GetDescriptionString or function() return "" end

function ItemTile:GetDescriptionString()
  local str = GetOriginalDescriptionString(self)
  local adjective = self.item:GetAdjective()

  if str ~= "" and adjective then
    local name = self.item:GetDisplayName()

    str = str:gsub(adjective .. " " .. name, ConstructAdjectivedName(self.item, name, adjective))
  end

  return str
end
