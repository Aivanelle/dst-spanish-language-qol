local Inv = require "widgets/inventorybar"
local GetOriginalDescriptionString = Inv.GetDescriptionString

function Inv:GetDescriptionString(item)
  local str = GetOriginalDescriptionString(self, item)
  local adjective = item:GetAdjective()

  if str ~= "" and adjective then
    local name = item:GetDisplayName()
    local grammaticalAdjective = item:GetGrammaticalAdjective()

    if not grammaticalAdjective then
      str =  unknownAdjectivesConfig == "default" and egsub(str, adjective .. " " .. name, ConstructAdjectivedName(item, name, adjective))
          or egsub(str, adjective .. " ", "")
    else
      str = egsub(str, adjective .. " " .. name, ConstructAdjectivedName(item, name, grammaticalAdjective))
    end
  end

  return str
end
