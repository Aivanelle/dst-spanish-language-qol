local Inv = require "widgets/inventorybar"

function Inv:GetDescriptionString(item)
  if item == nil then
    return ""
  end

  local adjective = item:GetAdjective()
  return adjective ~= nil and (item:GetDisplayName() .. " " .. adjective) or item:GetDisplayName()
end
