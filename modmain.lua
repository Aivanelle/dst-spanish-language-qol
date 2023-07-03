_G = GLOBAL
STRINGS = _G.STRINGS
STRINGS.WET_SUFFIX =
{
  FOOD =
  {
    MALE    = { SINGULAR = "Remojado", PLURAL = "Remojados" },
    FEMALE  = { SINGULAR = "Remojada", PLURAL = "Remojadas" }
  },

  CLOTHING =
  {
    MALE    = { SINGULAR = "Empapado", PLURAL = "Empapados" },
    FEMALE  = { SINGULAR = "Empapada", PLURAL = "Empapadas" }
  },

  TOOL =
  {
    MALE    = { SINGULAR = "Resbaladizo", PLURAL = "Resbaladizos" },
    FEMALE  = { SINGULAR = "Resbaladiza", PLURAL = "Resbaladizas" }
  },

  FUEL =
  {
    MALE    = { SINGULAR = "Mojado", PLURAL = "Mojados" },
    FEMALE  = { SINGULAR = "Mojada", PLURAL = "Mojadas" }
  },

  GENERIC =
  {
    MALE    = { SINGULAR = "Húmedo", PLURAL = "Húmedos" },
    FEMALE  = { SINGULAR = "Húmeda", PLURAL = "Húmedas" }
  }
}

USE_PREFIX = _G.USE_PREFIX
assert = _G.assert

--[[
  Traverse recursively the STRINGS.WET_SUFFIX suffixes table to set them as false in USE_PREFIX table.
]]
local function traverseSuffixes(table)
  for k, v in pairs(table) do
    if (type(v) == "table") then
      traverseSuffixes(v)
    else
      assert(type(v) == "string", "Error, suffix string expected, got: " .. type(v))

      USE_PREFIX[v] = false
    end
  end
end

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
local function suffixPrefabs(sortedPrefabsTable)
  -- GRAMMATICAL_NUMBER = Singular or plural.
  for GRAMMATICAL_NUMBER, prefabs in pairs(sortedPrefabsTable) do
    for _, prefab in ipairs(prefabs) do
      local upperPrefab = prefab:upper()

      SUFFIXED_PREFABS[upperPrefab] = {}
      SUFFIXED_PREFABS[upperPrefab].SUFFIX = sortedPrefabsTable[GRAMMATICAL_NUMBER].SUFFIX
    end
  end
end

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

suffixPrefabs(MALE_GENERICS)
suffixPrefabs(FEMALE_GENERICS)
suffixPrefabs(MALE_TOOLS)
suffixPrefabs(FEMALE_TOOLS)
suffixPrefabs(MALE_CLOTHINGS)
suffixPrefabs(FEMALE_CLOTHINGS)
suffixPrefabs(MALE_FUELS)
suffixPrefabs(FEMALE_FUELS)
suffixPrefabs(MALE_FOODS)
suffixPrefabs(FEMALE_FOODS)

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

traverseSuffixes(STRINGS.WET_SUFFIX)
-- modimport("scripts/constructadjectivedname.lua")
modimport("scripts/getadjectivedname.lua")
