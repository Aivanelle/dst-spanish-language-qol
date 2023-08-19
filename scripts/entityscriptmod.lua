local function getNewAdjectivedName(adjectivedName, suffix, replacement)
  if not replacement then
    return  unknownAdjectivesConfig == "default" and adjectivedName or
        egsub(adjectivedName, " " .. suffix, "")
  else
    return egsub(adjectivedName, suffix, replacement)
  end
end

local EntityScript = _G.EntityScript

function EntityScript:GetGrammaticalSuffix(suffixes)
  local grammar = self.components.grammar
  if grammar then
    return suffixes[grammar.gender] and suffixes[grammar.gender][grammar.grammaticalnumber] or
        suffixes.NEUTRAL and suffixes.NEUTRAL[grammar.grammaticalnumber]
  end
end

local FOODTYPE = {}
for _, v in pairs(_G.FOODTYPE) do table.insert(FOODTYPE, "edible_" .. v) end

local FUELTYPE = {}
for _, v in pairs(_G.FUELTYPE) do table.insert(FUELTYPE, v .. "_fuel") end

local EQUIPSLOTS = _G.EQUIPSLOTS
local GetOriginalAdjectivedName = EntityScript.GetAdjectivedName

function EntityScript:GetAdjectivedName()
  local grammaticalSuffix = nil
  local adjectivedName = GetOriginalAdjectivedName(self)

  if self:HasTag("player") or (self.prefab == "rabbithole" and self.iscollapsed:value()) then
    return adjectivedName
  elseif self:HasTag("smolder") then
    grammaticalSuffix = self:GetGrammaticalSuffix(STRINGS.SUFFIX.SMOLDERING)
    return getNewAdjectivedName(adjectivedName, STRINGS.SMOLDERINGITEM, grammaticalSuffix)
  elseif self:HasTag("withered") then
    grammaticalSuffix = self:GetGrammaticalSuffix(STRINGS.SUFFIX.WITHERED)
    return getNewAdjectivedName(adjectivedName, STRINGS.WITHEREDITEM, grammaticalSuffix)
  elseif not self.no_wet_prefix and (self.always_wet_prefix or self:GetIsWet()) then
    if self.prefab ~= "rabbithole" and self.wet_prefix then return adjectivedName end

    local prefabType = nil

    if self.replica.equippable and self.replica.equippable:EquipSlot() then
      prefabType = self.replica.equippable:EquipSlot() == EQUIPSLOTS.HANDS and "TOOL" or "CLOTHING"
    elseif self:HasOneOfTags(FOODTYPE) then
      prefabType = "FOOD"
    elseif self:HasOneOfTags(FUELTYPE) then
      prefabType = "FUEL"
    else
      prefabType = "GENERIC"
    end

    grammaticalSuffix = self:GetGrammaticalSuffix(STRINGS.SUFFIX.WET[prefabType])
    adjectivedName = getNewAdjectivedName(adjectivedName, STRINGS.WET_PREFIX[prefabType], grammaticalSuffix)
  end

  if self:HasTag("broken") then
    grammaticalSuffix = self:GetGrammaticalSuffix(STRINGS.SUFFIX.BROKEN)
    adjectivedName = getNewAdjectivedName(adjectivedName, STRINGS.BROKENITEM, grammaticalSuffix)
  end

  return adjectivedName
end

local GetOriginalAdjective = EntityScript.GetAdjective

function EntityScript:GetAdjective()
  local adjective = GetOriginalAdjective(self)

  if self:HasTag("frozen") and self:HasTag("spoiled") then
    return STRINGS.UI.HUD.SPOILED_FROZEN
  end

  return adjective
end

local TUNING = _G.TUNING

function EntityScript:GetGrammaticalAdjective()
  if self.displayadjectivefn then
    return self.components.grammar and self:GetAdjective() or nil
  elseif self:HasTag("critter") then
    for trait, _ in pairs(TUNING.CRITTER_TRAITS) do
      if self:HasTag("trait_" .. trait) then
        return STRINGS.SUFFIX.PET_TRAIT[trait] and self:GetGrammaticalSuffix(STRINGS.SUFFIX.PET_TRAIT[trait]) or
            self.components.grammar and self:GetAdjective()
      end
    end
  elseif self:HasOneOfTags({ "stale", "spoiled" }) then
    if self:HasTag("small_livestock") then
      return not self:HasTag("sickness") and
          self:GetGrammaticalSuffix(STRINGS.SUFFIX.CREATURE[self:HasTag("stale") and "HUNGRY" or "STARVING"])
    else
      if self:HasTag("frozen") then return self:GetAdjective() end

      return self:GetGrammaticalSuffix(STRINGS.SUFFIX.PERISHABLE[self:HasTag("stale") and "STALE" or "SPOILED"])
    end
  end
end
