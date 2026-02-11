local ESX = exports["es_extended"]:getSharedObject()

local function spawn_car(data, garage)
    local props = json.decode(data.vehicle)
    local hash = props.model

    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end
    
    local coords = Config.Garages[garage].spawnPoint
    local v = CreateVehicle(hash, coords.xyz, coords.w, true, false)
    
    SetVehicleNumberPlateText(v, data.plate)
    ESX.Game.SetVehicleProperties(v, props)
    
    Entity(v).state:set('initVehicle', true, true)
    
    TriggerServerEvent('smq_jobgarage:load_inv', data.plate)
    TriggerServerEvent('smq_jobgarage:give_key', data.plate)
    TriggerServerEvent('smq_jobgarage:set_state', data.plate, 0)
    
    TaskWarpPedIntoVehicle(PlayerPedId(), v, -1)
    lib.notify({description = 'Vehicle out!', type = 'success'})
end

local function park_car()
    local veh = lib.getClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0, true)

    if veh then
        local plate = GetVehicleNumberPlateText(veh)
        local props = ESX.Game.GetVehicleProperties(veh)
        
        TriggerServerEvent('smq_jobgarage:save_car', plate, props)
        
        Wait(500)
        if DoesEntityExist(veh) then DeleteEntity(veh) end

        lib.notify({description = 'Stored.', type = 'inform'})
    else
        lib.notify({description = 'No car near you', type = 'error'})
    end
end

function open_menu(id)
    local g = Config.Garages[id]

    ESX.TriggerServerCallback('smq_jobgarage:get_cars', function(res)
        local m = {}

        if res then
            for k, v in pairs(res) do
                table.insert(m, {
                    title = "Vehicle",
                    description = "Plate: " .. v.plate,
                    icon = 'car',
                    onSelect = function() spawn_car(v, id) end
                })
            end
        end
        
        table.insert(m, {
            title = "Buy Vehicle",
            icon = 'plus',
            onSelect = function()
                local s = {}
                for _, veh in pairs(g.shopVehicles) do
                    table.insert(s, {
                        title = veh.label,
                        onSelect = function()
                            if lib.callback.await('smq_jobgarage:buy_car', false, veh.model, id) then 
                                open_menu(id) 
                            end
                        end
                    })
                end
                lib.registerContext({id = 'garage_shop', title = 'Shop', options = s})
                lib.showContext('garage_shop')
            end
        })

        lib.registerContext({id = 'job_garage_main', title = g.label, options = m})
        lib.showContext('job_garage_main')
    end, g.job)
end

CreateThread(function()
    for k, v in pairs(Config.Garages) do
        RequestModel(v.ped.model)
        while not HasModelLoaded(v.ped.model) do Wait(0) end

        local p = CreatePed(4, v.ped.model, v.ped.coords.x, v.ped.coords.y, v.ped.coords.z - 1.0, v.ped.coords.w, false, true)
        FreezeEntityPosition(p, true)
        SetEntityInvincible(p, true)
        SetBlockingOfNonTemporaryEvents(p, true)

        exports.ox_target:addLocalEntity(p, {
            { label = "Garage", icon = "fas fa-warehouse", groups = v.job, onSelect = function() open_menu(k) end },
            { label = "Park", icon = "fas fa-parking", groups = v.job, onSelect = function() park_car() end }
        })
    end
end)
