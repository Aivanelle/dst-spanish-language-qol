--[[
    This is the exact same blueprint prefab as the original, but just implementing the makeBlueprintName function,
  it might be kind of overkill overriding the hole prefab instead of using AddPrefabPostInit, but I wasn't
  able to achieve certain things with a post init function, so here we are.
]]

require "recipes"

local assets =
{
  Asset("ANIM", "anim/blueprint.zip"),
  Asset("ANIM", "anim/blueprint_rare.zip"),
  Asset("INV_IMAGE", "blueprint"),
  Asset("INV_IMAGE", "blueprint_rare"),
}

local function makeBlueprintName(inst)
  return subfmt(STRINGS.NAMES.BLUEPRINTMOD, { item = STRINGS.NAMES[inst.recipetouse:upper()] or STRINGS.NAMES.UNKNOWN })
end

local function onload(inst, data)
  if data ~= nil and data.recipetouse ~= nil then
    inst.recipetouse = data.recipetouse
    inst.components.teacher:SetRecipe(inst.recipetouse)
    inst.components.named:SetName(makeBlueprintName(inst))

    if data.is_rare then
      inst.is_rare = data.is_rare
      inst.AnimState:SetBank("blueprint_rare")
      inst.AnimState:SetBuild("blueprint_rare")
      inst.components.inventoryitem:ChangeImageName("blueprint_rare")
      inst:RemoveComponent("burnable")
      inst:RemoveComponent("propagator")
    end
  end
end

local function onsave(inst, data)
  data.recipetouse = inst.recipetouse
  data.is_rare = inst.is_rare or nil
end

local function getstatus(inst)
  return (inst.is_rare and "RARE") or "COMMON"
end

local function OnTeach(inst, learner)
  learner:PushEvent("learnrecipe", { teacher = inst, recipe = inst.components.teacher.recipe })
end

local function CanBlueprintRandomRecipe(recipe)
  if recipe.nounlock or recipe.builder_tag ~= nil then return false end

  local hastech = false

  for k, v in pairs(recipe.level) do
    if v >= 10 then
      return false
    elseif v > 0 then
      hastech = true
    end
  end

  return hastech
end

local function CanBlueprintSpecificRecipe(recipe)
  if recipe.nounlock or recipe.builder_tag ~= nil then return false end

  for k, v in pairs(recipe.level) do
    if v > 0 then return true end
  end

  return false
end

local function OnHaunt(inst, haunter)
  if not inst.is_rare and math.random() <= TUNING.HAUNT_CHANCE_HALF then
    local recipes = {}
    local old = inst.recipetouse ~= nil and GetValidRecipe(inst.recipetouse) or nil

    for k, v in pairs(AllRecipes) do
      if IsRecipeValid(v.name) and old ~= v and (old == nil or old.tab == v.tab) and
          CanBlueprintRandomRecipe(v) and not haunter.components.builder:KnowsRecipe(v) and
          haunter.components.builder:CanLearn(v.name) then
        table.insert(recipes, v)
      end
    end

    if #recipes > 0 then
      inst.recipetouse = recipes[math.random(#recipes)].name or "unknown"
      inst.components.teacher:SetRecipe(inst.recipetouse)
      inst.components.named:SetName(makeBlueprintName(inst))
      inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL

      return true
    end
  end

  return false
end

local function fn(is_rare)
  local inst = CreateEntity()

  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("blueprint")
  inst.AnimState:SetBuild("blueprint")
  inst.AnimState:PlayAnimation("idle")

  inst:AddTag("_named")

  inst:SetPrefabName("blueprint")

  MakeInventoryFloatable(inst, "med", nil, 0.75)

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
      return inst
  end

  inst.is_rare = is_rare

  inst:RemoveTag("_named")

  inst:AddComponent("inspectable")
  inst.components.inspectable.getstatus = getstatus

  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem:ChangeImageName("blueprint")

	inst:AddComponent("erasablepaper")

  inst:AddComponent("named")
  inst:AddComponent("teacher")
  inst.components.teacher.onteach = OnTeach

  inst:AddComponent("fuel")
  inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

  if not is_rare then
    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
  else
    inst.AnimState:SetBank("blueprint_rare")
    inst.AnimState:SetBuild("blueprint_rare")
    inst.components.inventoryitem:ChangeImageName("blueprint_rare")
  end

  MakeHauntableLaunch(inst)
  AddHauntableCustomReaction(inst, OnHaunt, true, false, true)

  inst.OnLoad = onload
  inst.OnSave = onsave

  return inst
end

local function MakeAnyBlueprint()
  local inst = fn()

  if not TheWorld.ismastersim then return inst end

  local unknownrecipes = {}
  local knownrecipes = {}
  local allplayers = AllPlayers

  for k, v in pairs(AllRecipes) do
    if IsRecipeValid(v.name) and CanBlueprintRandomRecipe(v) then
      local known = false

      for i, player in ipairs(allplayers) do
        if player.components.builder:KnowsRecipe(v) or
          not player.components.builder:CanLearn(v.name) then
          known = true
          break
        end
      end

      table.insert(known and knownrecipes or unknownrecipes, v)
    end
  end

  inst.recipetouse =
    (#unknownrecipes > 0 and unknownrecipes[math.random(#unknownrecipes)].name) or
    (#knownrecipes > 0 and knownrecipes[math.random(#knownrecipes)].name) or
    "unknown"

  inst.components.teacher:SetRecipe(inst.recipetouse)
  inst.components.named:SetName(makeBlueprintName(inst))

  return inst
end

local function MakeSpecificBlueprint(specific_item)
  return function()
    local is_rare = false
    local r = GetValidRecipe(specific_item)

    if r ~= nil then
      for k, v in pairs(r.level) do
        if v >= 10 then
          is_rare = true
          break
        end
      end
    end

    local inst = fn(is_rare)

    if not TheWorld.ismastersim then return inst end

    local r = GetValidRecipe(specific_item)

    inst.recipetouse = r ~= nil and not r.nounlock and r.name or "unknown"
    inst.components.teacher:SetRecipe(inst.recipetouse)
    inst.components.named:SetName(makeBlueprintName(inst))

    return inst
  end
end

local prefabs = {}
table.insert(prefabs, Prefab("blueprint", MakeAnyBlueprint, assets))

for k, v in pairs(AllRecipes) do
  if CanBlueprintSpecificRecipe(v) then
    table.insert(prefabs, Prefab(string.lower(k or "NONAME") .. "_blueprint", MakeSpecificBlueprint(k), assets))
  end
end

for k, v in pairs(RECIPETABS) do
  if not v.crafting_station then
    table.insert(prefabs, Prefab(string.lower(v.str == "WAR" and "WARTAB" or v.str or "NONAME") .. "_blueprint", MakeAnyBlueprint, assets))
  end
end

CanBlueprintSpecificRecipe = nil

return unpack(prefabs)
