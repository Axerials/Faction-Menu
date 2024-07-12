RegisterServerEvent('changeColor')
AddEventHandler('changeColor', function(colorName)
    local _source = source
    TriggerClientEvent('client:changeColor', _source, colorName)
end)

RegisterServerEvent('upgradeEngine')
AddEventHandler('upgradeEngine', function(option)
    local _source = source
    TriggerClientEvent('client:upgradeEngine', _source, option)
end)

RegisterServerEvent('changeLivery')
AddEventHandler('changeLivery', function(liveryIndex)
    local _source = source
    TriggerClientEvent('client:changeLivery', _source, liveryIndex)
end)

RegisterServerEvent('repairVehicle')
AddEventHandler('repairVehicle', function()
    local _source = source
    TriggerClientEvent('client:repairVehicle', _source)
end)

RegisterServerEvent('switchTint')
AddEventHandler('switchTint', function(tintLevel)
    local _source = source
    TriggerClientEvent('client:switchTint', _source, tintLevel)
end)

RegisterServerEvent('revivePlayer')
AddEventHandler('revivePlayer', function(playerId)
    -- Add your revive logic here, e.g., using ESX framework
    -- Example:
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        xPlayer.triggerEvent('esx_ambulancejob:revive')
    end
end)
