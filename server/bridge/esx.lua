if GetResourceState('es_extended') ~= 'started' then return end
local ESX = exports["es_extended"]:getSharedObject()

Ice.Framework = "esx"

---@param source number
function Ice.GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

---@param source number
function Ice.GetCitizenId(source)
    return GetPlayer(source).identifier
end

-- ei tietoo toimiiko ihan 100%
function Ice.GetPlayerData(source)
    local player = Ice.GetPlayer(source)
    return {
        job = player.job.name,
        jobGrade = player.job.grade,
        firstname = player.firstname,
        lastname = player.lastname,
    }
end

---@param source number
---@param amount number
function Ice.AddMoney(source, amount)
    GetPlayer(source).addAccountMoney("bank", amount)
end

---@param source number
---@param amount number
---@return boolean?
function Ice.RemoveMoney(source, amount)
    local player = GetPlayer(source)
    local success = false
    if player.getAccount("bank").money >= amount then
        player.removeAccountMoney("bank", amount)
        success = true
    end
    return success
end