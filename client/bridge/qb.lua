if GetResourceState('qb-core') ~= 'started' then return end
local QBCore = exports["qb-core"]:GetCoreObject()
local Player = {}
Ice.Framework = "qb"

function Ice.GetCitizenId()
    return QBCore.Functions.GetPlayerData().citizenid
end


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
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