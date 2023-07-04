-- local function lowercaseString(str)
--   return str:sub(1, 1) .. string.lower(str:sub(2))
-- end

local function UsesPrefix(item)
  if type(item) == "string" then return USE_PREFIX[item] end
end

if _G.ConstructAdjectivedName then
  _G.ConstructAdjectivedName = function(inst, name, adjective)
    if name == nil and inst ~= nil and inst.prefab ~= nil then
      name = STRINGS.NAMES[inst.prefab:upper()]
    end

    local usePrefix = UsesPrefix(adjective)
    if usePrefix == nil then
      usePrefix = UsesPrefix(name)
    end

    if type(usePrefix) == "function" then
      local tryfunction = usePrefix(inst, name, adjective)
      if type(tryfunction) == "string" then
        return tryfunction
      end
    end

    if inst.prefab:find("wetgoop") then
      return name:gsub(" ", " " .. adjective:lower() .. " ", 1)
    end

    return usePrefix ~= false
      and (adjective .. " " .. name)
      or (name .. " " .. adjective)
  end
end
