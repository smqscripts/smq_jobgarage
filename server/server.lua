local ESX = exports["es_extended"]:getSharedObject()
local key_item = "vehicle_key"

ESX.RegisterServerCallback('smq_jobgarage:get_cars', function(source, cb, job)
    local p = ESX.GetPlayerFromId(source)
    MySQL.query('SELECT * FROM job_garages WHERE job = ? AND owner = ?', {job, p.identifier}, function(res)
        cb(res)
    end)
end)

local function get_inv(id)
    local items = exports.ox_inventory:GetInventoryItems(id)
    local t = {}
    if items then
        for _, v in pairs(items) do
            if v.count > 0 then
                table.insert(t, {name = v.name, count = v.count, metadata = v.metadata})
            end
        end
    end
    return #t > 0 and json.encode(t) or nil
end

RegisterNetEvent('smq_jobgarage:save_car', function(plate, props)
    local src = source
    local p = string.gsub(plate, "%s+", "")
    
    local trunk = get_inv('trunk' .. p)
    local glove = get_inv('glove' .. p)

    MySQL.update('UPDATE job_garages SET vehicle = ?, trunk = ?, glovebox = ?, state = 1 WHERE plate = ?', {
        json.encode(props), trunk, glove, plate
    })
    
    exports.ox_inventory:ClearInventory('trunk' .. p)
    exports.ox_inventory:ClearInventory('glove' .. p)
    
    local item = exports.ox_inventory:GetItem(src, key_item, { plate = plate }, false)
    if item then exports.ox_inventory:RemoveItem(src, key_item, 1, nil, item.slot) end
end)

RegisterNetEvent('smq_jobgarage:load_inv', function(plate)
    local p = string.gsub(plate, "%s+", "")

    MySQL.query('SELECT trunk, glovebox FROM job_garages WHERE plate = ?', {plate}, function(res)
        if res and res[1] then
            Wait(1000)
            local function put(inv, data)
                if not data then return end
                local items = json.decode(data)
                for _, i in ipairs(items) do
                    exports.ox_inventory:AddItem(inv .. p, i.name, i.count, i.metadata)
                end
            end
            put('trunk', res[1].trunk)
            put('glove', res[1].glovebox)
            MySQL.update('UPDATE job_garages SET trunk = NULL, glovebox = NULL WHERE plate = ?', {plate})
        end
    end)
end)

RegisterNetEvent('smq_jobgarage:give_key', function(plate)
    exports.ox_inventory:AddItem(source, key_item, 1, { plate = plate })
end)

lib.callback.register('smq_jobgarage:buy_car', function(source, model, garage)
    local p = ESX.GetPlayerFromId(source)
    local plate = string.upper(lib.string.random('8AA11AA')) 
    local props = json.encode({model = GetHashKey(model), plate = plate})

    return MySQL.insert.await('INSERT INTO job_garages (plate, owner, job, vehicle, state) VALUES (?, ?, ?, ?, ?)', {
        plate, p.identifier, p.job.name, props, 1
    })
end)

RegisterNetEvent('smq_jobgarage:set_state', function(plate, state) 
    MySQL.update('UPDATE job_garages SET state = ? WHERE plate = ?', {state, plate}) 
end)