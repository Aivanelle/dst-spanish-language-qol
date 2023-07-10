local Inv = require "widgets/inventorybar"

function Inv:GetDescriptionString(item)
  if item == nil then return "" end

  local adjective = item:GetAdjective()
  local name = item:GetDisplayName()

  return adjective ~= nil and (name .. " " .. adjective) or name
end
