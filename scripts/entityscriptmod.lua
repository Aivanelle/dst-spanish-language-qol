local FOODTYPE = _G.FOODTYPE
local FUELTYPE = _G.FUELTYPE
local EQUIPSLOTS = _G.EQUIPSLOTS
local EntityScript = _G.EntityScript
local oldGetAdjectivedName = EntityScript.GetAdjectivedName
local ConstructAdjectivedName = _G.ConstructAdjectivedName

if oldGetAdjectivedName then
  function EntityScript:GetAdjectivedName(...)
    local name = self:GetBasicDisplayName()
    local prefab = self.prefab
    local upperPrefab = prefab:upper()
    local isKitcoonNamed = self:HasTag("kitcoon") and (self.components.named and self.components.named.name)

    if self:HasTag("player") then
      return name
    elseif self:HasTag("smolder") then
      return ConstructAdjectivedName(self, name, STRINGS.SMOLDERINGITEM)
    --[[
      Deprecated feature.

      elseif self:HasTag("diseased") then
        return ConstructAdjectivedName(self, name, STRINGS.DISEASEDITEM)
    ]]
    elseif self:HasTag("rotten") then
      return ConstructAdjectivedName(self, name, STRINGS.UI.HUD.SPOILED)
    elseif self:HasTag("withered") then
      local witheredSuffix = SUFFIXED_PREFABS[upperPrefab][ WITHERED_SUFFIX_KEY] or STRINGS.WITHEREDITEM

      return ConstructAdjectivedName(self, name, witheredSuffix)
    elseif not self.no_wet_prefix and (self.always_wet_prefix or self:GetIsWet()) and not isKitcoonNamed then
      if self.wet_prefix ~= nil then
        --[[
            Rabbitholes changes its own wet suffix based in his collapsed state, since its not collapsed
            suffix is declared in a local function, this has to be here.
        ]]
        if prefab == "rabbithole" and not self.iscollapsed:value() then
          self.wet_prefix = SUFFIXED_PREFABS[upperPrefab][WET_SUFFIX_KEY]
        end

        return ConstructAdjectivedName(self, name, self.wet_prefix)
      end

      local suffix = nil
      local equippable = self.replica.equippable

      --[[
          Since every prefab has already his suffix "attached" to it, the if and for statements
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
        assert(SUFFIXED_PREFABS[upperPrefab][WET_SUFFIX_KEY], "Suffixed prefab table found but not suffix key for prefab '" .. self.prefab .. "'. Make sure you have a 'SUFFIX' key added to the proper table of grammatical number in scripts/sortedprefabs")
        suffix = SUFFIXED_PREFABS[upperPrefab][WET_SUFFIX_KEY]
      end

      return ConstructAdjectivedName(self, name, suffix)
    end
    return name
  end
end

local TUNING = _G.TUNING
local oldGetAdjective = EntityScript.GetAdjective

if oldGetAdjective then
  function EntityScript:GetAdjective(...)
    local upperPrefab = self.prefab:upper()

    if self.displayadjectivefn ~= nil then
      return self:displayadjectivefn(self)
    elseif self:HasTag("critter") then

      for k, _ in pairs(TUNING.CRITTER_TRAITS) do
        if self:HasTag("trait_" .. k) then
          return SUFFIXED_PREFABS[upperPrefab][PET_TRAIT_SUFFIX_KEY[k:upper()]] or STRINGS.UI.HUD.CRITTER_TRAITS[k]
        end
      end

    elseif self:HasTag("small_livestock") then
      local hungryAdjective = SUFFIXED_PREFABS[upperPrefab][CREATURE_HUNGRY_SUFFIX_KEY] or STRINGS.UI.HUD.HUNGRY
      local starvingAdjective = SUFFIXED_PREFABS[upperPrefab][CREATURE_STARVING_SUFFIX_KEY] or STRINGS.UI.HUD.STARVING

      return not self:HasTag("sickness") and
        ((self:HasTag("stale") and hungryAdjective) or (self:HasTag("spoiled") and starvingAdjective)) or nil
    elseif self:HasTag("stale") then
      local staleAdjective = SUFFIXED_PREFABS[upperPrefab][PERISHABLE_STALE_SUFFIX_KEY] or STRINGS.UI.HUD.STALE

      return self:HasTag("frozen") and STRINGS.UI.HUD.STALE_FROZEN or staleAdjective
    elseif self:HasTag("spoiled") then
      local spoiledAdjective = SUFFIXED_PREFABS[upperPrefab][PERISHABLE_SPOILED_SUFFIX_KEY] or STRINGS.UI.HUD.SPOILED

      return self:HasTag("frozen") and STRINGS.UI.HUD.STALE_FROZEN or spoiledAdjective
    end
  end
end
