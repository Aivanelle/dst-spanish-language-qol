local FOODTYPE = _G.FOODTYPE
local FUELTYPE = _G.FUELTYPE
local EQUIPSLOTS = _G.EQUIPSLOTS
local EntityScript = _G.EntityScript
local oldGetAdjectivedName = EntityScript.GetAdjectivedName
local ConstructAdjectivedName = _G.ConstructAdjectivedName

if oldGetAdjectivedName then
  function EntityScript:GetAdjectivedName(...)
    if self.components.named and self.components.named.name then
      print("NPC con nombre propio.")
    end
    local name = self:GetBasicDisplayName() -- .. " (" .. self.prefab:upper() .. ")"

    if self:HasTag("player") then
      return name
    elseif self:HasTag("smolder") then
      return ConstructAdjectivedName(self, name, STRINGS.SMOLDERINGITEM)
    elseif self:HasTag("diseased") then
      return ConstructAdjectivedName(self, name, STRINGS.DISEASEDITEM)
    elseif self:HasTag("rotten") then
      return ConstructAdjectivedName(self, name, STRINGS.UI.HUD.SPOILED)
    elseif self:HasTag("withered") then
      return ConstructAdjectivedName(self, name, STRINGS.WITHEREDITEM)
    elseif not self.no_wet_prefix and (self.always_wet_prefix or self:GetIsWet()) and not (self.components.named and self.components.named.name) then
      if self.wet_prefix ~= nil then
        return ConstructAdjectivedName(self, name, self.wet_prefix)
      end

      local upperPrefab = self.prefab:upper()
      local suffix = nil
      local equippable = self.replica.equippable

      --[[
          Since every prefab has already his suffix "attached" to it, the ifs and for statements
        of the original function now are useless, nonetheless I'm keeping them as some sort of
        debugging option ingame to be aware of any prefab that was not sorted.
          If some prefab was not sorted in any table, it will display ingame as something like
        "(AXE TOOL?) Hacha."
      ]]
      if equippable ~= nil then
        local eslot = equippable:EquipSlot()
        if eslot == EQUIPSLOTS.HANDS then
          suffix = "(" .. upperPrefab .. " TOOL?)"
        elseif eslot == EQUIPSLOTS.HEAD or eslot == EQUIPSLOTS.BODY then
          suffix = "(" .. upperPrefab .. " CLOTHING?)"
        end
      end
      
      for k, v in pairs(FOODTYPE) do
        if self:HasTag("edible_" .. v) and not suffix then
          suffix = "(" .. upperPrefab .. " FOOD?)"
        end
      end

      for k, v in pairs(FUELTYPE) do
        if self:HasTag(v .. "_fuel") and not suffix then
          suffix = "(" .. upperPrefab .. " FUEL?)"
        end
      end

      if not suffix then suffix = "(" .. upperPrefab .. " GENERIC?)" end

      -- This is actually the important stuff.
      if type(SUFFIXED_PREFABS[upperPrefab]) == "table" then
        assert(SUFFIXED_PREFABS[upperPrefab].SUFFIX, "Suffixed prefab table found but not suffix key for prefab '" .. self.prefab .. "'. Make sure you have a 'SUFFIX' key added to the proper table of grammatical number in scripts/sortedprefabs")
        suffix = SUFFIXED_PREFABS[upperPrefab].SUFFIX
      end

      return ConstructAdjectivedName(self, name, suffix)
    end
    return name
  end
end
