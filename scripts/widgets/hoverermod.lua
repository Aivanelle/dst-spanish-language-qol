local HoverText = require "widgets/hoverer"
local OnUpdateOriginal = HoverText.OnUpdate or function() return "" end
local ConstructAdjectivedName = _G.ConstructAdjectivedName

function HoverText:OnUpdate()
  OnUpdateOriginal(self)

  local str = self.text:GetString()
  local lmb = self.owner.components.playercontroller:GetLeftMouseAction()

  if str ~= "" and lmb and lmb.target then
    local adjective = lmb.target:GetAdjective()

    if adjective then
      local name = lmb.target:GetDisplayName()

      str = str:gsub(adjective .. " " .. name, ConstructAdjectivedName(lmb.target, name, adjective))
      self.text:SetString(str)
    end
  end
end
