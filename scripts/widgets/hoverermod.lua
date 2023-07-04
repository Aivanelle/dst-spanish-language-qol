local SHOW_DELAY = 0
local ACTIONS = _G.ACTIONS
local CONTROL_PRIMARY = _G.CONTROL_PRIMARY
local CONTROL_SECONDARY = _G.CONTROL_SECONDARY
local WET_TEXT_COLOUR = _G.WET_TEXT_COLOUR
local NORMAL_TEXT_COLOUR = _G.NORMAL_TEXT_COLOUR
local TheInput = _G.TheInput
local unpack = _G.unpack
local ProfileStatsSet = _G.ProfileStatsSet
local HoverText = require "widgets/hoverer"

function HoverText:OnUpdate()
  if self.owner.components.playercontroller == nil or not self.owner.components.playercontroller:UsingMouse() then
    if self.shown then self:Hide() end
    return
  elseif not self.shown then
    if not self.forcehide then self:Show() else return end
  end

  local str = nil
  local colour = nil

  if not self.isFE then
    str = self.owner.HUD.controls:GetTooltip() or self.owner.components.playercontroller:GetHoverTextOverride()
    self.text:SetPosition(self.owner.HUD.controls:GetTooltipPos() or self.default_text_pos)

    if self.owner.HUD.controls:GetTooltip() ~= nil then
        colour = self.owner.HUD.controls:GetTooltipColour()
    end
  else
    str = self.owner:GetTooltip()
    self.text:SetPosition(self.owner:GetTooltipPos() or self.default_text_pos)
  end

  local secondarystr = nil
  local lmb = nil

  if str == nil and not self.isFE and self.owner:IsActionsVisible() then
    lmb = self.owner.components.playercontroller:GetLeftMouseAction()

    if lmb ~= nil then
      local overriden
      str, overriden = lmb:GetActionString()

      if lmb.action.show_primary_input_left then
        str = TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_PRIMARY) .. " " .. str
      end

      if colour == nil then
        if lmb.target ~= nil then
          if lmb.invobject ~= nil and not (lmb.invobject:HasTag("weapon") or lmb.invobject:HasTag("tool")) then
            colour = lmb.invobject:GetIsWet() and WET_TEXT_COLOUR or NORMAL_TEXT_COLOUR
          else
            colour = lmb.target:GetIsWet() and WET_TEXT_COLOUR or NORMAL_TEXT_COLOUR
          end
        elseif lmb.invobject ~= nil then
          colour = lmb.invobject:GetIsWet() and WET_TEXT_COLOUR or NORMAL_TEXT_COLOUR
        end
      end

      if not overriden and lmb.target ~= nil and lmb.invobject == nil and lmb.target ~= lmb.doer then
        local name = lmb.target:GetDisplayName()
        if name ~= nil then
          local adjective = lmb.target:GetAdjective()
          str = str .. " " .. (adjective ~= nil and (name .. " " .. adjective) or name)

          if lmb.target.replica.stackable ~= nil and lmb.target.replica.stackable:IsStack() then
            str = str .. " x" .. tostring(lmb.target.replica.stackable:StackSize())
          end

          -- NOTE: This won't work on clients. Leaving it here anyway. Klei Comment.
          if lmb.target.components.inspectable ~= nil and lmb.target.components.inspectable.recordview and lmb.target.prefab ~= nil then
            ProfileStatsSet(lmb.target.prefab .. "_seen", true)
          end
        end
      end
    end

    local aoetargeting = self.owner.components.playercontroller:IsAOETargeting()
    local rmb = self.owner.components.playercontroller:GetRightMouseAction()

    if rmb ~= nil then
      if rmb.action.show_secondary_input_right then
        secondarystr = rmb:GetActionString() .. " " .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_SECONDARY)
      elseif rmb.action ~= ACTIONS.CASTAOE then
        secondarystr = TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_SECONDARY) .. ": " .. rmb:GetActionString()
      elseif aoetargeting and str == nil then
        str = rmb:GetActionString()
      end
    end

    if aoetargeting and secondarystr == nil then
        secondarystr = TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_SECONDARY) .. ": " .. STRINGS.UI.HUD.CANCEL
    end
  end

  if str == nil then
    self.text:Hide()
  elseif self.str ~= self.lastStr then
    self.lastStr = self.str
    self.strFrames = SHOW_DELAY
  else
    self.strFrames = self.strFrames - 1

    if self.strFrames <= 0 then
      if lmb ~= nil and lmb.target ~= nil and lmb.target:HasTag("player") then
        self.text:SetColour(unpack(lmb.target.playercolour))
      else
        self.text:SetColour(unpack(colour or NORMAL_TEXT_COLOUR))
      end

      self.text:SetString(str)
      self.text:Show()
    end
  end

  if secondarystr ~= nil then
    self.secondarytext:SetString(secondarystr)
    self.secondarytext:Show()
  else
    self.secondarytext:Hide()
  end

  local changed = self.str ~= str or self.secondarystr ~= secondarystr
  self.str = str
  self.secondarystr = secondarystr

  if changed then
    local pos = TheInput:GetScreenPosition()
    self:UpdatePosition(pos.x, pos.y)
  end
end
