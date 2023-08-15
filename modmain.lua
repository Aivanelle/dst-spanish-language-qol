_G = GLOBAL
_G.WET_SUFFIX_KEY = "WET_SUFFIX"
_G.WAXED_SUFFIX_KEY = "WAXED_SUFFIX"
_G.CREATURE_HUNGRY_SUFFIX_KEY = "CREATURE_HUNGRY_SUFFIX"
_G.CREATURE_STARVING_SUFFIX_KEY = "CREATURE_STARVING_SUFFIX"
_G.PERISHABLE_STALE_SUFFIX_KEY = "PERISHABLE_STALE_SUFFIX"
_G.PERISHABLE_SPOILED_SUFFIX_KEY = "PERISHABLE_SPOILED_SUFFIX"
_G.WITHERED_SUFFIX_KEY = "WITHERED_SUFFIX"
_G.PET_TRAIT_SUFFIX_KEY =
{
  COMBAT = "PET_TRAIT_COMBAT_SUFFIX",
  WELLFED = "PET_TRAIT_WELLFED_SUFFIX"
}

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

GRAMMATICAL_NUMBER =
{
  PLURAL = "PLURAL",
  SINGULAR = "SINGULAR"
}

GENDER =
{
  MASCULINE = "MASCULINE",
  FEMININE = "FEMININE"
}

local function setGrammarComponent(prefabs, gender, grammaticalNumber)
  for _, prefab in ipairs(prefabs) do
    AddPrefabPostInit(prefab, function(inst)
      inst:AddComponent("grammar")
      inst.components.grammar:SetGrammaticalNumber(grammaticalNumber)
      inst.components.grammar:SetGender(gender)
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

local unpack = _G.unpack

--[[
    SUFFIXED_PREFABS table is filled with every prefab as a key and their corresponding table containing
  their corresponding suffixes. For example:
  SUFFIXED_PREFABS =
  {
    AXE =
    {
      SUFFIX = "Resbaladiza"
    },

    PEROGIES =
    {
      SUFFIX = "Remojado"
    },

    EVERGREEN =
    {
      SUFFIX = "Húmedo"
    }

    ...
  }
]]
SUFFIXED_PREFABS = {}
local function suffixPrefabs(sortedPrefabsTable, ...)
  for k, v in pairs(sortedPrefabsTable) do
    if type(v) == "table" then
      suffixPrefabs(v, unpack(arg))
    else
      if type(k) == "number" then
        local upperPrefab = v:upper()
  
        if type(SUFFIXED_PREFABS[upperPrefab]) ~= "table" then
          SUFFIXED_PREFABS[upperPrefab] = {}
        end

        for _, suffixKey in ipairs(arg) do
          SUFFIXED_PREFABS[upperPrefab][suffixKey] = sortedPrefabsTable[suffixKey]
        end
      end
    end
  end
end

WET_SUFFIX_KEY = _G.WET_SUFFIX_KEY
WAXED_SUFFIX_KEY = _G.WAXED_SUFFIX_KEY
CREATURE_HUNGRY_SUFFIX_KEY = _G.CREATURE_HUNGRY_SUFFIX_KEY
CREATURE_STARVING_SUFFIX_KEY = _G.CREATURE_STARVING_SUFFIX_KEY
PERISHABLE_STALE_SUFFIX_KEY = _G.PERISHABLE_STALE_SUFFIX_KEY
PERISHABLE_SPOILED_SUFFIX_KEY = _G.PERISHABLE_SPOILED_SUFFIX_KEY
PET_TRAIT_SUFFIX_KEY = _G.PET_TRAIT_SUFFIX_KEY
WITHERED_SUFFIX_KEY = _G.WITHERED_SUFFIX_KEY

local MALE_GENERICS = require("sortedprefabs/malegenerics")
local FEMALE_GENERICS = require("sortedprefabs/femalegenerics")
local MALE_TOOLS = require("sortedprefabs/maletools")
local FEMALE_TOOLS = require("sortedprefabs/femaletools")
local MALE_CLOTHINGS = require("sortedprefabs/maleclothings")
local FEMALE_CLOTHINGS = require("sortedprefabs/femaleclothings")
local MALE_FUELS = require("sortedprefabs/malefuels")
local FEMALE_FUELS = require("sortedprefabs/femalefuels")
local MALE_FOODS = require("sortedprefabs/malefoods")
local FEMALE_FOODS = require("sortedprefabs/femalefoods")
local MALE_PERISHABLES = require("sortedprefabs/maleperishables")
local FEMALE_PERISHABLES = require("sortedprefabs/femaleperishables")
local WAXED_VEGGIES = require("sortedprefabs/waxedveggies")
local INVENTORY_CREATURES = require("sortedprefabs/inventorycreatures")
local PETS = require("sortedprefabs/pets")
local WITHERABLES = require("sortedprefabs/witherables")

suffixPrefabs(MALE_GENERICS, WET_SUFFIX_KEY)
suffixPrefabs(FEMALE_GENERICS, WET_SUFFIX_KEY)
suffixPrefabs(MALE_TOOLS, WET_SUFFIX_KEY)
suffixPrefabs(FEMALE_TOOLS, WET_SUFFIX_KEY)
suffixPrefabs(MALE_CLOTHINGS, WET_SUFFIX_KEY)
suffixPrefabs(FEMALE_CLOTHINGS, WET_SUFFIX_KEY)
suffixPrefabs(MALE_FUELS, WET_SUFFIX_KEY)
suffixPrefabs(FEMALE_FUELS, WET_SUFFIX_KEY)
suffixPrefabs(MALE_FOODS, WET_SUFFIX_KEY)
suffixPrefabs(FEMALE_FOODS, WET_SUFFIX_KEY)
suffixPrefabs(MALE_PERISHABLES, PERISHABLE_STALE_SUFFIX_KEY, PERISHABLE_SPOILED_SUFFIX_KEY)
suffixPrefabs(FEMALE_PERISHABLES, PERISHABLE_STALE_SUFFIX_KEY, PERISHABLE_SPOILED_SUFFIX_KEY)
suffixPrefabs(WAXED_VEGGIES, WAXED_SUFFIX_KEY)
suffixPrefabs(INVENTORY_CREATURES, CREATURE_HUNGRY_SUFFIX_KEY, CREATURE_STARVING_SUFFIX_KEY)
suffixPrefabs(PETS, PET_TRAIT_SUFFIX_KEY.COMBAT, PET_TRAIT_SUFFIX_KEY.WELLFED)
suffixPrefabs(WITHERABLES, WITHERED_SUFFIX_KEY)

local function setDisplayAdjectiveFn(self)
  self.displayadjectivefn = function()
    return SUFFIXED_PREFABS[self.prefab:upper()][WAXED_SUFFIX_KEY]
  end
end

local function modWaxedVeggies(veggiesTable)
  for k, v in pairs(veggiesTable) do
    if type(v) == "table" then
      modWaxedVeggies(v)
    else
      if type(k) == "number" then
        AddPrefabPostInit(v:lower(), setDisplayAdjectiveFn)
      end
    end
  end
end

modWaxedVeggies(WAXED_VEGGIES)

local NO_WET_SUFFIX_PREFABS = require("sortedprefabs/nowetsuffixprefabs")
local function setNoWetPrefix(prefab)
  if not prefab.no_wet_prefix then prefab.no_wet_prefix = true end
end

for _, prefab in ipairs(NO_WET_SUFFIX_PREFABS) do AddPrefabPostInit(prefab, setNoWetPrefix) end

local subfmt = _G.subfmt

local function setSpiceDisplayName(self)
  self.displaynamefn = function()
    local spice = self.components.edible and self.components.edible.spice
    local upperNameOverride = self.nameoverride:upper()

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

local function setBlueprintDisplayName(self)
  self.displaynamefn = function()
    return subfmt(STRINGS.NAMES.BLUEPRINTMOD, { item = STRINGS.NAMES[self.recipetouse:upper()] or STRINGS.NAMES.UNKNOWN })
  end
end

AddPrefabPostInit("blueprint", setBlueprintDisplayName)

local function simPostInitFn()
  USE_PREFIX[STRINGS.WET_PREFIX.RABBITHOLE] = false
  USE_PREFIX[STRINGS.SMOLDERINGITEM] = false

  USE_PREFIX[STRINGS.WET_PREFIX.WETGOOP] = function(inst, name, adjective)
    if inst.prefab:find("wetgoop") then
      local wetWetgoopName = STRINGS.NAMES.WETGOOP:gsub(" ", " " .. adjective:lower() .. " ")

      return name:gsub(STRINGS.NAMES.WETGOOP, wetWetgoopName)
    end
  end
end

AddSimPostInit(simPostInitFn)

ConstructAdjectivedName = _G.ConstructAdjectivedName

modimport("scripts/entityscriptmod.lua")
modimport("scripts/widgets/hoverermod.lua")
modimport("scripts/widgets/inventorybarmod.lua")
modimport("scripts/widgets/itemtilemod.lua")

-- modimport "getprefabs_dst.lua"
