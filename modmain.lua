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

USE_PREFIX = _G.USE_PREFIX
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

enableSuffixes(STRINGS.WET_SUFFIX)
enableSuffixes(STRINGS.WITHERED_SUFFIX)

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
local function suffixPrefabs(sortedPrefabsTable, suffixKey)
  for k, v in pairs(sortedPrefabsTable) do
    if type(v) == "table" then
      suffixPrefabs(v, suffixKey)
    else
      if type(k) == "number" then
        local upperPrefab = v:upper()
  
        if type(SUFFIXED_PREFABS[upperPrefab]) ~= "table" then
          SUFFIXED_PREFABS[upperPrefab] = {}
        end

        SUFFIXED_PREFABS[upperPrefab][suffixKey] = sortedPrefabsTable[suffixKey]
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
suffixPrefabs(MALE_PERISHABLES, PERISHABLE_STALE_SUFFIX_KEY)
suffixPrefabs(MALE_PERISHABLES, PERISHABLE_SPOILED_SUFFIX_KEY)
suffixPrefabs(FEMALE_PERISHABLES, PERISHABLE_STALE_SUFFIX_KEY)
suffixPrefabs(FEMALE_PERISHABLES, PERISHABLE_SPOILED_SUFFIX_KEY)
suffixPrefabs(WAXED_VEGGIES, WAXED_SUFFIX_KEY)
suffixPrefabs(INVENTORY_CREATURES, CREATURE_HUNGRY_SUFFIX_KEY)
suffixPrefabs(INVENTORY_CREATURES, CREATURE_STARVING_SUFFIX_KEY)
suffixPrefabs(PETS, PET_TRAIT_SUFFIX_KEY.COMBAT)
suffixPrefabs(PETS, PET_TRAIT_SUFFIX_KEY.WELLFED)
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

local function setNoWetPrefix(prefab)
  if not prefab.no_wet_prefix then prefab.no_wet_prefix = true end
end

AddPrefabPostInit("abigail", setNoWetPrefix)
AddPrefabPostInit("bernie_active", setNoWetPrefix)
AddPrefabPostInit("bernie_big", setNoWetPrefix)
AddPrefabPostInit("bernie_inactive", setNoWetPrefix)
AddPrefabPostInit("bunnyman", setNoWetPrefix)
AddPrefabPostInit("charlie_npc", setNoWetPrefix)
AddPrefabPostInit("chester", setNoWetPrefix)
AddPrefabPostInit("cozy_bunnyman", setNoWetPrefix)
AddPrefabPostInit("glommer", setNoWetPrefix)
AddPrefabPostInit("hutch", setNoWetPrefix)
AddPrefabPostInit("hutch_fishbowl", setNoWetPrefix)
AddPrefabPostInit("lavae", setNoWetPrefix)
AddPrefabPostInit("little_walrus", setNoWetPrefix)
AddPrefabPostInit("merm", setNoWetPrefix)
AddPrefabPostInit("mermguard", setNoWetPrefix)
AddPrefabPostInit("moonpig", setNoWetPrefix)
AddPrefabPostInit("pigelite1", setNoWetPrefix)
AddPrefabPostInit("pigelite2", setNoWetPrefix)
AddPrefabPostInit("pigelite3", setNoWetPrefix)
AddPrefabPostInit("pigelite4", setNoWetPrefix)
AddPrefabPostInit("pigelitefighter1", setNoWetPrefix)
AddPrefabPostInit("pigelitefighter2", setNoWetPrefix)
AddPrefabPostInit("pigelitefighter3", setNoWetPrefix)
AddPrefabPostInit("pigelitefighter4", setNoWetPrefix)
AddPrefabPostInit("pigguard", setNoWetPrefix)
AddPrefabPostInit("pigman", setNoWetPrefix)
AddPrefabPostInit("pirate_stash", setNoWetPrefix)
AddPrefabPostInit("polly_rogers", setNoWetPrefix)
AddPrefabPostInit("quagmire_goatkid", setNoWetPrefix)
AddPrefabPostInit("quagmire_goatmum", setNoWetPrefix)
AddPrefabPostInit("quagmire_trader_merm", setNoWetPrefix)
AddPrefabPostInit("quagmire_trader_merm2", setNoWetPrefix)
AddPrefabPostInit("walrus", setNoWetPrefix)
AddPrefabPostInit("wobybig", setNoWetPrefix)
AddPrefabPostInit("wobysmall", setNoWetPrefix)
AddPrefabPostInit("battlesong_durability", setNoWetPrefix)
AddPrefabPostInit("battlesong_fireresistance", setNoWetPrefix)
AddPrefabPostInit("battlesong_healthgain", setNoWetPrefix)
AddPrefabPostInit("battlesong_instant_panic", setNoWetPrefix)
AddPrefabPostInit("battlesong_instant_taunt", setNoWetPrefix)
AddPrefabPostInit("battlesong_sanityaura", setNoWetPrefix)
AddPrefabPostInit("battlesong_sanitygain", setNoWetPrefix)
AddPrefabPostInit("book_bees", setNoWetPrefix)
AddPrefabPostInit("book_birds", setNoWetPrefix)
AddPrefabPostInit("book_brimstone", setNoWetPrefix)
AddPrefabPostInit("book_fire", setNoWetPrefix)
AddPrefabPostInit("book_fish", setNoWetPrefix)
AddPrefabPostInit("book_gardening", setNoWetPrefix)
AddPrefabPostInit("book_horticulture", setNoWetPrefix)
AddPrefabPostInit("book_horticulture_upgraded", setNoWetPrefix)
AddPrefabPostInit("book_light", setNoWetPrefix)
AddPrefabPostInit("book_light_upgraded", setNoWetPrefix)
AddPrefabPostInit("book_moon", setNoWetPrefix)
AddPrefabPostInit("book_rain", setNoWetPrefix)
AddPrefabPostInit("book_research_station", setNoWetPrefix)
AddPrefabPostInit("book_silviculture", setNoWetPrefix)
AddPrefabPostInit("book_sleep", setNoWetPrefix)
AddPrefabPostInit("book_temperature", setNoWetPrefix)
AddPrefabPostInit("book_web", setNoWetPrefix)
AddPrefabPostInit("carnival_crowkid", setNoWetPrefix)
AddPrefabPostInit("waxwelljournal", setNoWetPrefix)

AddPrefabPostInit("carnival_host", setNoWetPrefix)
AddPrefabPostInit("carnivalgame_feedchicks_nest", setNoWetPrefix)
AddPrefabPostInit("carnivalgame_feedchicks_station", setNoWetPrefix)
AddPrefabPostInit("carnivalgame_memory_card", setNoWetPrefix)
AddPrefabPostInit("carnivalgame_memory_station", setNoWetPrefix)
AddPrefabPostInit("carnivalgame_puckdrop_station", setNoWetPrefix)
AddPrefabPostInit("carnivalgame_shooting_button", setNoWetPrefix)
AddPrefabPostInit("carnivalgame_shooting_station", setNoWetPrefix)
AddPrefabPostInit("carnivalgame_wheelspin_station", setNoWetPrefix)

local subfmt = _G.subfmt

local function setSpiceDisplayName(self)
  self.displaynamefn = function()
    local spice = nil

    if self.components.edible and self.components.edible.spice then
      spice = self.components.edible.spice
    end

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
end

AddSimPostInit(simPostInitFn)

modimport("scripts/constructadjectivedname.lua")
modimport("scripts/entityscriptmod.lua")
modimport("scripts/widgets/hoverermod.lua")
modimport("scripts/widgets/inventorybarmod.lua")
modimport("scripts/widgets/itemtilemod.lua")
