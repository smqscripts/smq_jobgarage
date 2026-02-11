local ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('smq_jobgarage:get_cars', function(source, cb, job)
    local p = ESX.GetPlayerFromId(source)
    if not p then return cb(nil) end
    MySQL.query('SELECT * FROM job_garages WHERE job = ? AND owner = ?', {job, p.identifier}, function(res)
        cb(res)
    end)
end)

local function get_inv(id)
    local items = exports.ox_inventory:GetInventoryItems(id)
    local t = {}
    if items then
        for _, v in pairs(items) do
            if v.count and v.count > 0 then
                table.insert(t, {name = v.name, count = v.count, metadata = v.metadata})
            end
        end
    end
    return #t > 0 and json.encode(t) or nil
end

RegisterNetEvent('smq_jobgarage:save_car', function(plate, props)
    local src = source
    local p = ESX.GetPlayerFromId(src)
    if not p then return end

    MySQL.scalar('SELECT 1 FROM job_garages WHERE owner = ? AND plate = ?', {p.identifier, plate}, function(res)
        if not res then return end

        local clean = string.gsub(plate, "%s+", "")
        local trunk = get_inv('trunk' .. clean)
        local glove = get_inv('glove' .. clean)

        MySQL.update('UPDATE job_garages SET vehicle = ?, trunk = ?, glovebox = ?, state = 1 WHERE plate = ?', {
            json.encode(props), trunk, glove, plate
        })
        
        exports.ox_inventory:ClearInventory('trunk' .. clean)
        exports.ox_inventory:ClearInventory('glove' .. clean)
        
        if Config.GiveKeys then
            local inv = exports.ox_inventory:GetInventoryItems(src)
            for _, v in pairs(inv) do
                if v.name == Config.KeyItem and v.metadata and v.metadata.plate == plate then
                    exports.ox_inventory:RemoveItem(src, Config.KeyItem, 1, nil, v.slot)
                    break
                end
            end
        end
    end)
end)

RegisterNetEvent('smq_jobgarage:load_inv', function(plate)
    local src = source
    local p = ESX.GetPlayerFromId(src)
    if not p then return end

    MySQL.query('SELECT owner, trunk, glovebox FROM job_garages WHERE plate = ?', {plate}, function(res)
        if res and res[1] and res[1].owner == p.identifier then
            local clean = string.gsub(plate, "%s+", "")
            Wait(1000)
            local function restore(id, data)
                if not data then return end
                local items = json.decode(data)
                for _, v in ipairs(items) do
                    exports.ox_inventory:AddItem(id .. clean, v.name, v.count, v.metadata)
                end
            end
            restore('trunk', res[1].trunk)
            restore('glove', res[1].glovebox)
            MySQL.update('UPDATE job_garages SET trunk = NULL, glovebox = NULL WHERE plate = ?', {plate})
        end
    end)
end)

RegisterNetEvent('smq_jobgarage:give_key', function(plate)
    local src = source
    local p = ESX.GetPlayerFromId(src)
    if not p or not Config.GiveKeys then return end

    MySQL.scalar('SELECT 1 FROM job_garages WHERE owner = ? AND plate = ?', {p.identifier, plate}, function(res)
        if res then
            exports.ox_inventory:AddItem(src, Config.KeyItem, 1, { plate = plate })
        end
    end)
end)

lib.callback.register('smq_jobgarage:buy_car', function(source, model, garage)
    local p = ESX.GetPlayerFromId(source)
    if not p then return false end
    local plate = string.upper(lib.string.random('8AA11AA')) 
    local props = json.encode({model = GetHashKey(model), plate = plate})

    return MySQL.insert.await('INSERT INTO job_garages (plate, owner, job, vehicle, state) VALUES (?, ?, ?, ?, ?)', {
        plate, p.identifier, p.job.name, props, 1
    }) ~= nil
end)

RegisterNetEvent('smq_jobgarage:set_state', function(plate, state) 
    local p = ESX.GetPlayerFromId(source)
    if not p then return end
    MySQL.update('UPDATE job_garages SET state = ? WHERE plate = ? AND owner = ?', {state, plate, p.identifier}) 
end)
