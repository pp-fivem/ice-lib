if GetResourceState('qbx_core') ~= 'started' then return end

Ice.Framework = "qbx"

---@param source number
function Ice.GetPlayer(source)
    return exports.qbx_core:GetPlayer(source)
end

---@param source number
function Ice.GetCitizenId(source)
    return Ice.GetPlayer(source).PlayerData.citizenid
end

function Ice.GetPlayerData(source)
    local player = Ice.GetPlayer(source)
    return {
        job = player.PlayerData.job.name,
        jobGrade = player.PlayerData.job.grade,
        firstname = player.PlayerData.charinfo.firstname,
        lastname = player.PlayerData.charinfo.lastname,
    }
end

---@param source number
---@param amount number
function Ice.AddMoney(source, amount)
    print(Ice.GetPlayer(source))
    Ice.GetPlayer(source).Functions.AddMoney("bank", amount)
end

---@param source number
---@param amount number
---@return boolean?
function Ice.RemoveMoney(source, amount)
    return Ice.GetPlayer(source).Functions.RemoveMoney("bank", amount)
end