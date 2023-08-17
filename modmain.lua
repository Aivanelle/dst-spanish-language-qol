_G = GLOBAL
STRINGS = _G.STRINGS

modimport("scripts/strings.lua")

local USE_PREFIX = _G.USE_PREFIX
assert = _G.assert

--[[
  Traverse recursively the STRINGS.WET_SUFFIX suffixes table to set them as false in USE_PREFIX table.
]]
local function enableSuffixes(table)
  for k, v in pairs(table) do
    if type(v) == "table" then
      enableSuffixes(v)
    else
      assert(type(v) == "string", "Error, suffix string expected, got: " .. type(v))

      USE_PREFIX[v] = false
    end
  end
end

enableSuffixes(STRINGS.SUFFIX)

GENDER =
{
  MASCULINE = "MASCULINE",
  FEMININE = "FEMININE"
}

GRAMMATICAL_NUMBER =
{
  PLURAL = "PLURAL",
  SINGULAR = "SINGULAR"
}

local function setGrammarComponent(prefabs, gender, grammaticalNumber)
  for _, prefab in ipairs(prefabs) do
    AddPrefabPostInit(prefab, function(inst)
      inst:AddComponent("grammar")
      inst.components.grammar:SetGrammaticalNumber(grammaticalNumber)
      inst.components.grammar:SetGender(gender)

      if inst.displayadjectivefn and inst.displayadjectivefn() == STRINGS.UI.HUD.WAXED then
        inst.displayadjectivefn = function() return STRINGS.SUFFIX.WAXED[gender][grammaticalNumber] end
      end
    end)
  end
end

local MASCULINE_SINGULAR = require "sortedprefabs/masculinesingular"
setGrammarComponent(MASCULINE_SINGULAR, GENDER.MASCULINE, GRAMMATICAL_NUMBER.SINGULAR)

local MASCULINE_PLURAL = require "sortedprefabs/masculineplural"
setGrammarComponent(MASCULINE_PLURAL, GENDER.MASCULINE, GRAMMATICAL_NUMBER.PLURAL)

local FEMININE_SINGULAR = require "sortedprefabs/femininesingular"
setGrammarComponent(FEMININE_SINGULAR, GENDER.FEMININE, GRAMMATICAL_NUMBER.SINGULAR)

local FEMININE_PLURAL = require "sortedprefabs/feminineplural"
setGrammarComponent(FEMININE_PLURAL, GENDER.FEMININE, GRAMMATICAL_NUMBER.PLURAL)

local NO_WET_SUFFIX = require("sortedprefabs/nowetsuffix")
local function setNoWetPrefix(prefab)
  if not prefab.no_wet_prefix then prefab.no_wet_prefix = true end
end

for _, prefab in ipairs(NO_WET_SUFFIX) do AddPrefabPostInit(prefab, setNoWetPrefix) end

local subfmt = _G.subfmt

local function setSpiceDisplayName(inst)
  inst.displaynamefn = function()
    local spice = inst.components.edible and inst.components.edible.spice
    local upperNameOverride = inst.nameoverride:upper()

    return STRINGS.SPICESMOD[spice][upperNameOverride] or subfmt(STRINGS.SPICESMOD[spice].GENERIC, { food = STRINGS.NAMES[upperNameOverride] })
  end
end

AddPrefabPostInit("baconeggs_spice_chili", setSpiceDisplayName)
AddPrefabPostInit("baconeggs_spice_salt", setSpiceDisplayName)
AddPrefabPostInit("baconeggs_spice_garlic", setSpiceDisplayName)
AddPrefabPostInit("baconeggs_spice_sugar", setSpiceDisplayName)
AddPrefabPostInit("dragonchilisalad_spice_chili", setSpiceDisplayName)
AddPrefabPostInit("dragonchilisalad_spice_sugar", setSpiceDisplayName)
AddPrefabPostInit("hotchili_spice_chili", setSpiceDisplayName)
AddPrefabPostInit("hotchili_spice_sugar", setSpiceDisplayName)
AddPrefabPostInit("leafloaf_spice_salt", setSpiceDisplayName)
AddPrefabPostInit("leafloaf_spice_garlic", setSpiceDisplayName)

local function setBlueprintDisplayName(inst)
  inst.displaynamefn = function()
    return subfmt(STRINGS.NAMES.BLUEPRINTMOD, { item = STRINGS.NAMES[inst.recipetouse:upper()] or STRINGS.NAMES.UNKNOWN })
  end
end

AddPrefabPostInit("blueprint", setBlueprintDisplayName)

local function simPostInitFn()
  enableSuffixes(STRINGS.WET_PREFIX)

  USE_PREFIX[STRINGS.SMOLDERINGITEM] = false
  USE_PREFIX[STRINGS.BROKENITEM] = false

  USE_PREFIX[STRINGS.UI.HUD.STALE_FROZEN] = false
  USE_PREFIX[STRINGS.UI.HUD.SPOILED_FROZEN] = false

  USE_PREFIX[STRINGS.WET_PREFIX.WETGOOP] = function(inst, name, adjective)
    if inst.prefab:find("wetgoop") then
      local wetWetgoopName = STRINGS.NAMES.WETGOOP:gsub(" ", " " .. adjective:lower() .. " ")

      return name:gsub(STRINGS.NAMES.WETGOOP, wetWetgoopName)
    end
  end
end

AddSimPostInit(simPostInitFn)

ConstructAdjectivedName = _G.ConstructAdjectivedName
function egsub(str, pattern, replacement) return str:gsub(_G.escape_lua_pattern(pattern), replacement) end

modimport("scripts/entityscriptmod.lua")
modimport("scripts/widgets/hoverermod.lua")
modimport("scripts/widgets/inventorybarmod.lua")
modimport("scripts/widgets/itemtilemod.lua")
