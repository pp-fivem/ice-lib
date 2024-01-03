if GetResourceState('es_extended') ~= 'started' then return end
local ESX = exports["es_extended"]:getSharedObject()
local Player = {}
Ice.Framework = "esx"

function Ice.GetCitizenId()
    return ESX.GetPlayerData().identifier
end

RegisterNetEvent("esx:playerLoaded", function(playerData)
    Player = {
        job = playerData.job.name,
        jobGrade = playerData.job.grade,
        cId = playerData.identifier,
    }
    TriggerEvent('Ice-Lib:joined', Player)
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    Player = {}
    TriggerEvent('Ice-Lib:logOut')
end)