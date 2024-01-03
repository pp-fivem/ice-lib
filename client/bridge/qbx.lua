if GetResourceState('qbx_core') ~= 'started' then  return end
    print("ye")
local Player = {}
Ice.Framework = "qbx"

function Ice.GetCitizenId()
    return exports.qbx_core:GetPlayerData().citizenid
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local PlayerData = exports.qbx_core:GetPlayerData()
    Player = {
        job = PlayerData.job.name,
        jobGrade = PlayerData.job.grade.level,
        cId = PlayerData.citizenid,
    }
    TriggerEvent('Ice-Lib:joined', Player)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    Player = {}
    TriggerEvent('Ice-Lib:logOut')
end)