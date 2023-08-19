local HoverText = require "widgets/hoverer"
local OnUpdateOriginal = HoverText.OnUpdate or function() return "" end

function HoverText:OnUpdate()
  OnUpdateOriginal(self)

  local str = self.text:GetString()
  local lmb = self.owner.components.playercontroller:GetLeftMouseAction()

  if str ~= "" and lmb and lmb.target then
    local adjective = lmb.target:GetAdjective()

    if adjective then
      local name = lmb.target:GetDisplayName()
      local grammaticalAdjective = lmb.target:GetGrammaticalAdjective()

      if not grammaticalAdjective then
        str =  unknownAdjectivesConfig == "hide" and egsub(str, adjective .. " ", "") or
            egsub(str, adjective .. " " .. name, ConstructAdjectivedName(lmb.target, name, adjective))
      else
        str = egsub(str, adjective .. " " .. name, ConstructAdjectivedName(lmb.target, name, grammaticalAdjective))
      end

      self.text:SetString(str)
    end
  end
end
