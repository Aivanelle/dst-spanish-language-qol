local ItemTile = require "widgets/itemtile"
local GetOriginalDescriptionString = ItemTile.GetDescriptionString or function() return "" end

function ItemTile:GetDescriptionString()
  local str = GetOriginalDescriptionString(self)
  local adjective = self.item:GetAdjective()

  if str ~= "" and adjective then
    local name = self.item:GetDisplayName()
    local grammaticalAdjective = self.item:GetGrammaticalAdjective()

    if not grammaticalAdjective then
      str = egsub(str, adjective .. " " .. name, ConstructAdjectivedName(self.item, name, adjective))
    else
      str = egsub(str, adjective .. " " .. name, ConstructAdjectivedName(self.item, name, grammaticalAdjective))
    end
  end

  return str
end
