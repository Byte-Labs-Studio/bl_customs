if not lib then return end

local config = require 'config'

lib.callback.register('bl_customs:canAffordMod', function(source, amount)
    local frameworkData = config.framework
    if frameworkData.name == 'qbus' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local player = QBCore.Functions.GetPlayer(source)
        local money = player.PlayerData.money[frameworkData.type]

        if amount > money then return false end
        
        player.Functions.RemoveMoney(frameworkData.type, amount)
    elseif frameworkData.name == 'esx' then
        local ESX = exports["es_extended"]:getSharedObject()
        local xPlayer = ESX.GetPlayerFromId(source)
        local moneyType = frameworkData.type == 'cash' and 'money' or 'bank'
        local money = xPlayer.getAccount(moneyType).money

        if amount > money then return false end

        xPlayer.removeAccountMoney(moneyType, amount)
    else
        -- for standalon
    end

    return true
end)