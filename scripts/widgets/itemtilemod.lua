local CONTROL_FORCE_INSPECT = _G.CONTROL_FORCE_INSPECT
local CONTROL_FORCE_TRADE = _G.CONTROL_FORCE_TRADE
local CONTROL_FORCE_STACK = _G.CONTROL_FORCE_STACK
local CONTROL_PRIMARY = _G.CONTROL_PRIMARY
local CONTROL_SECONDARY = _G.CONTROL_SECONDARY
local next = _G.next
local TheInput = _G.TheInput
local ItemTile = require "widgets/itemtile"

function ItemTile:GetDescriptionString()
  local str = ""

  if self.item ~= nil and self.item:IsValid() and self.item.replica.inventoryitem ~= nil then
    local adjective = self.item:GetAdjective()
    if adjective ~= nil then str = " " .. adjective end

    str = self.item:GetDisplayName() .. str

    local ThePlayer = _G.ThePlayer
    local player = ThePlayer
    local actionpicker = player.components.playeractionpicker
    local active_item = player.replica.inventory:GetActiveItem()

    if active_item == nil then
      if not (self.item.replica.equippable ~= nil and self.item.replica.equippable:IsEquipped()) then
        if TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) then
          str = str .. "\n" .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_PRIMARY) .. ": " .. STRINGS.INSPECTMOD
        elseif TheInput:IsControlPressed(CONTROL_FORCE_TRADE) and not self.item.replica.inventoryitem:CanOnlyGoInPocket() then
          if next(player.replica.inventory:GetOpenContainers()) ~= nil then
            str = str .. "\n" .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_PRIMARY) .. ": " .. ((TheInput:IsControlPressed(CONTROL_FORCE_STACK) and self.item.replica.stackable ~= nil) and (STRINGS.STACKMOD .. " " .. STRINGS.TRADEMOD) or STRINGS.TRADEMOD)
          end
        elseif TheInput:IsControlPressed(CONTROL_FORCE_STACK) and self.item.replica.stackable ~= nil then
          str = str .. "\n" .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_PRIMARY) .. ": " .. STRINGS.STACKMOD
        end
      end

      local actions = actionpicker:GetInventoryActions(self.item)
      if #actions > 0 then
          str = str .. "\n" .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_SECONDARY) .. ": " .. actions[1]:GetActionString()
      end
    elseif active_item:IsValid() then
      if not (self.item.replica.equippable ~= nil and self.item.replica.equippable:IsEquipped()) then
        if active_item.replica.stackable ~= nil and active_item.prefab == self.item.prefab and active_item.AnimState:GetSkinBuild() == self.item.AnimState:GetSkinBuild() then --active_item.skinname == self.item.skinname (this does not work on clients, so we're going to use the AnimState hack instead)
          str = str .. "\n" .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_PRIMARY) .. ": " .. STRINGS.UI.HUD.PUT
        else
          str = str .. "\n" .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_PRIMARY) .. ": " .. STRINGS.UI.HUD.SWAP
        end
      end

      local actions = actionpicker:GetUseItemActions(self.item, active_item, true)
      if #actions > 0 then
        str = str .. "\n" .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_SECONDARY) .. ": " .. actions[1]:GetActionString()
      end
    end
  end

  return str
end
