Ice = {}
local spawnedPeds = {}

---@param coords vector4
---@param ped number
---@return number
function Ice.SpawnPed(coords, ped)
    local entity = nil
    local resource = GetInvokingResource()

    if spawnedPeds[resource] then
        for _, v in pairs(spawnedPeds[resource]) do
            if v.coords == coords and v.ped == ped then
                entity = v.entity
                break
            end
        end

        if entity ~= nil then
            return entity
        end
    end

    lib.requestModel(ped, 5000)
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    entity = CreatePed(26, ped, coords.x, coords.y, coords.z, coords.w or 0, false, true)

    SetEntityAsMissionEntity(entity, true, false)
    SetEntityInvincible(entity, true)
    SetBlockingOfNonTemporaryEvents(entity, true)
    FreezeEntityPosition(entity, true)
    SetEntityHeading(entity, coords.w or 0.0)

    if not spawnedPeds[resource] then
        spawnedPeds[resource] = {}
    end

    spawnedPeds[resource][#spawnedPeds[resource] + 1] = {
        ped = ped,
        entity = entity,
        coords = coords
    }

    return entity
end

RegisterNetEvent("onResourceStop", function(resourceName)
    if spawnedPeds[resourceName] ~= nil then
        for _, v in pairs(spawnedPeds[resourceName]) do
            DeleteEntity(v.entity)
        end

        spawnedPeds[resourceName] = nil
    end
end)

exports("getLib", function()
    return Ice
end)
