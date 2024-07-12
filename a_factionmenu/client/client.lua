ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('client:changeColor')
AddEventHandler('client:changeColor', function(colorName)
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)
    if vehicle and DoesEntityExist(vehicle) then
        local primaryColor, secondaryColor = 0, 0
        if colorName == "Black" then
            primaryColor, secondaryColor = 0, 0
        elseif colorName == "White" then
            primaryColor, secondaryColor = 111, 111
        -- Add more color options as needed
        else
            TriggerEvent('ox_lib:notify', {type = 'error', text = 'Invalid color name!'})
            return
        end
        SetVehicleColours(vehicle, primaryColor, secondaryColor)
        TriggerEvent('ox_lib:notify', {type = 'success', text = 'Vehicle color changed to ' .. colorName})
    else
        TriggerEvent('ox_lib:notify', {type = 'error', text = 'You are not in a vehicle!'})
    end
end)

RegisterNetEvent('client:upgradeEngine')
AddEventHandler('client:upgradeEngine', function(option)
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)
    if vehicle and DoesEntityExist(vehicle) then
        if option >= 1 and option <= 5 then
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, option, false) -- Engine upgrade option
            TriggerEvent('ox_lib:notify', {type = 'success', text = 'Engine upgraded to Option ' .. option})
        else
            TriggerEvent('ox_lib:notify', {type = 'error', text = 'Invalid engine upgrade option!'})
        end
    else
        TriggerEvent('ox_lib:notify', {type = 'error', text = 'You are not in a vehicle!'})
    end
end)

RegisterNetEvent('client:changeLivery')
AddEventHandler('client:changeLivery', function(liveryIndex)
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)
    if vehicle and DoesEntityExist(vehicle) then
        if liveryIndex >= 1 and liveryIndex <= 3 then
            SetVehicleLivery(vehicle, liveryIndex - 1)
            TriggerEvent('ox_lib:notify', {type = 'success', text = 'Vehicle livery changed to ' .. liveryIndex})
        else
            TriggerEvent('ox_lib:notify', {type = 'error', text = 'Invalid livery index!'})
        end
    else
        TriggerEvent('ox_lib:notify', {type = 'error', text = 'You are not in a vehicle!'})
    end
end)

RegisterNetEvent('client:repairVehicle')
AddEventHandler('client:repairVehicle', function()
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)
    if vehicle and DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0)
        TriggerEvent('ox_lib:notify', {type = 'success', text = 'Vehicle repaired!'})
    else
        TriggerEvent('ox_lib:notify', {type = 'error', text = 'You are not in a vehicle!'})
    end
end)

RegisterNetEvent('client:switchTint')
AddEventHandler('client:switchTint', function(tintLevel)
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)
    print('Client: Received tintLevel ' .. tintLevel)
    if vehicle and DoesEntityExist(vehicle) then
        print('Client: Player is in a vehicle')
        if tintLevel >= 0 and tintLevel <= 6 then
            SetVehicleWindowTint(vehicle, tintLevel)
            TriggerEvent('ox_lib:notify', {type = 'success', text = 'Vehicle tint level changed to ' .. tintLevel})
            print('Client: Tint level set to ' .. tintLevel)
        else
            TriggerEvent('ox_lib:notify', {type = 'error', text = 'Invalid tint level!'})
            print('Client: Invalid tint level: ' .. tintLevel)
        end
    else
        TriggerEvent('ox_lib:notify', {type = 'error', text = 'You are not in a vehicle!'})
        print('Client: Player not in a vehicle or vehicle does not exist')
    end
end)

RegisterCommand('fmenu', function()
    local player = GetPlayerPed(-1)
    local playerData = ESX.GetPlayerData()
    local allowedJobs = Config.AllowedJobs

    if playerData.job and isAllowedJob(playerData.job.name, allowedJobs) then
        TriggerEvent('showFMenu')
    else
        TriggerEvent('ox_lib:notify', {type = 'error', text = 'You do not have the required job to use this menu!'})
    end
end)

function isAllowedJob(jobName, allowedJobs)
    for _, job in ipairs(allowedJobs) do
        if job == jobName then
            return true
        end
    end
    return false
end

RegisterNetEvent('showFMenu')
AddEventHandler('showFMenu', function()
    lib.registerContext({
        id = 'fmenu_context',
        title = 'Faction Menu',
        options = {
            {
                title = 'Revive Player',
                icon = 'heartbeat',
                onSelect = function()
                    local input = lib.inputDialog('Revive Player', {
                        {type = 'number', label = 'Player ID', description = 'Enter the Player ID to revive', required = true, icon = 'user'}
                    })

                    if input then
                        local playerId = tonumber(input[1])
                        TriggerServerEvent('revivePlayer', playerId)
                    end
                end
            },
            {
                title = 'Change Color',
                icon = 'paint-brush',
                onSelect = function()
                    local input = lib.inputDialog('Change Color', {
                        {type = 'input', label = 'Color Name', description = 'Enter the color name (e.g., Black)', required = true, icon = 'palette'}
                    })

                    if input then
                        local colorName = input[1]
                        TriggerServerEvent('changeColor', colorName)
                    end
                end
            },
            {
                title = 'Upgrade Engine',
                icon = 'cogs',
                onSelect = function()
                    local input = lib.inputDialog('Select Engine Upgrade', {
                        {type = 'number', label = 'Engine Upgrade Level', description = 'Enter the upgrade level (1-5)', required = true, icon = 'cogs'}
                    })

                    if input then
                        local upgradeLevel = tonumber(input[1])
                        if upgradeLevel >= 1 and upgradeLevel <= 5 then
                            TriggerServerEvent('upgradeEngine', upgradeLevel)
                        else
                            TriggerEvent('ox_lib:notify', {type = 'error', text = 'Invalid engine upgrade level!'})
                        end
                    end
                end
            },
            {
                title = 'Switch Tint',
                icon = 'eye-slash',
                onSelect = function()
                    local input = lib.inputDialog('Switch Tint', {
                        {type = 'number', label = 'Tint Level', description = 'Enter the tint level (0-6)', required = true, icon = 'car'}
                    })

                    if input then
                        local tintLevel = tonumber(input[1])
                        TriggerServerEvent('switchTint', tintLevel)
                    end
                end
            },
            {
                title = 'Repair Vehicle',
                icon = 'wrench',
                onSelect = function()
                    TriggerServerEvent('repairVehicle')
                end
            },
            {
                title = 'Change Livery',
                icon = 'car',
                onSelect = function()
                    local input = lib.inputDialog('Change Livery', {
                        {type = 'number', label = 'Livery Index', description = 'Enter the livery index (1-3)', required = true, icon = 'car'}
                    })

                    if input then
                        local liveryIndex = tonumber(input[1])
                        TriggerServerEvent('changeLivery', liveryIndex)
                    end
                end
            }
        }
    })

    lib.showContext('fmenu_context')
end)
