local Inv = require "widgets/inventorybar"
local GetOriginalDescriptionString = Inv.GetDescriptionString

function Inv:GetDescriptionString(item)
  local str = GetOriginalDescriptionString(self, item)
  local adjective = item:GetAdjective()

  if str ~= "" and adjective then
    local name = item:GetDisplayName()

    str = str:gsub(adjective .. " " .. name, ConstructAdjectivedName(item, name, adjective))
  end

  return str
end
