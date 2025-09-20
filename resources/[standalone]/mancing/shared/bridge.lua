core = {
    client = {},
    server = {},
    items = {}
}

if Config.FW == 'QBX' then
    core.object = exports['qb-core']:GetCoreObject() -- kalo ga paham, jgn sentuh. walaupun nama resourcenya misal qbx_core, leave it qb-core aja.
elseif Config.FW == 'QBCore' then
    core.object = exports['qb-core']:GetCoreObject() -- sesuaikan dengan nama resource frameworknya
elseif Config.FW == 'ESX' then
    core.object = exports.es_extended:getSharedObject() -- sesuaikan dengan nama resource frameworknya
end

if lib.context == 'client' then
    RegisterNetEvent('stevid_ikanv2:pakai', function (slot)
        TriggerServerEvent('stevid_ikanv2:pakai', slot)
    end)
else
    if Config.FW == 'QBX' then
        core.server.GetPlayer = function (src)
            return exports.qbx_core:GetPlayer(src)
        end

        core.server.Identifier = function (src)
            local pd = core.server.GetPlayer(src)
            return pd.PlayerData.citizenid
        end

        core.server.UseItem = function (name, cb)
            exports.qbx_core:CreateUseableItem(name, function (source, item)
                return cb(source, item)
            end)
        end

        core.server.AddAccount = function (src, tipe, amount)
            local pd = core.server.GetPlayer(src)
            pd.Functions.AddMoney(tipe, amount)
        end
    elseif Config.FW == 'QBCore' then
        core.server.GetPlayer = function (src)
            return core.object.Functions.GetPlayer(src)
        end

        core.server.Identifier = function (src)
            local pd = core.server.GetPlayer(src)
            return pd.PlayerData.citizenid
        end

        core.server.UseItem = function (name, cb)
            core.object.Functions.CreateUseableItem(name, function (source, item)
                return cb(source, item)
            end)
        end

        core.server.AddAccount = function (src, tipe, amount)
            local pd = core.server.GetPlayer(src)
            pd.Functions.AddMoney(tipe, amount)
        end
    elseif Config.FW == 'ESX' then
        core.server.GetPlayer = function (src)
            return core.object.GetPlayerFromId(src)
        end

        core.server.Identifier = function (src)
            local pd = core.server.GetPlayer(src)
            return pd.identifier
        end

        core.server.UseItem = function (name, cb)
            core.object.RegisterUsableItem(name, function (source, name, item)
                return cb(source, item)
            end)
        end

        core.server.AddAccount = function (src, tipe, amount)
            local pd = core.server.GetPlayer(src)
            if tipe == 'cash' then
                pd.addMoney(amount)
            else
                pd.addAccountMoney(tipe, amount)
            end
        end

        -- core.server.UseItem = function (name, cb)
        --     core.items[name] = cb
        -- end

        -- RegisterNetEvent('stevid_ikanv2:pakai', function (slot)
        --     local src = source
        --     if not core.items[slot.name] then return end
        --     local item = exports.ox_inventory:GetSlot(src, slot.slot)
        --     core.items[slot.name](src, item)
        -- end)
    end

    if Config.ItemMetadata then
        core.server.addItem = function (src, data)
            if Config.canCarryItem then
                if data.metadata.weight then
                    if not exports.ox_inventory:CanCarryWeight(src, data.metadata.weight) then
                        lib.notify(src, {
                            title = 'Ruang di dalam tas tidak cukup',
                            type = 'error'
                        })
                        return false
                    end
                end
            end
            return exports.ox_inventory:AddItem(src, data.kategori, data.jumlah or 1, data.metadata)
        end

        core.server.removeItem = function (src, data)
            return exports.ox_inventory:RemoveItem(src, data.kategori, data.jumlah or 1, data.metadata)
        end

        core.server.countItem = function (src, data)
            local brp = exports.ox_inventory:Search(src, 'count', data.kategori, data.metadata)
            if data.jumlah then
                return brp >= data.jumlah
            end
            return brp
        end

        core.server.searchItem = function (src, data)
            return exports.ox_inventory:Search(src, 'slots', data.kategori, data.metadata)
        end
    else
        core.server.addItem = function (src, data, meta)
            if Config.canCarryItem then
                if not exports.ox_inventory:CanCarryItem(src, data.metadata.tipe, data.jumlah or 1) then
                    lib.notify(src, {
                        title = 'Ruang di dalam tas tidak cukup',
                        type = 'error'
                    })
                    return false
                end
            end
            return exports.ox_inventory:AddItem(src, data.metadata.tipe, data.jumlah or 1, meta and data.metadata or nil)
        end

        core.server.removeItem = function (src, data, meta)
            return exports.ox_inventory:RemoveItem(src, data.metadata.tipe, data.jumlah or 1, meta and data.metadata or nil)
        end

        core.server.countItem = function (src, data)
            local brp = exports.ox_inventory:Search(src, 'count', data.metadata.tipe)
            if data.jumlah then
                return brp >= data.jumlah
            end
            return brp
        end

        core.server.searchItem = function (src, data, meta)
            return exports.ox_inventory:Search(src, 'slots', data.metadata.tipe, meta and data.metadata or nil)
        end
    end

    core.server.getPlayerName = function (src)
        local player = core.server.GetPlayer(src)
        if Config.FW == 'QBX' or Config.FW == 'QBCore' then
            return player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname
        elseif Config.FW == 'ESX' then
            return player.get('firstName')..' '..player.get('lastName')
        end
    end

    -- contoh

    -- RegisterCommand('rod_add', function (source)
    --     core.server.addItem(source, {
    --         kategori = 'rod',
    --         jumlah = 1,
    --         metadata = {
    --             tipe = 'ufe_telerod_370',
    --             imageurl = 'nui://stevid_ikanv2/nui/images/equipments/rod/ufe_telerod_370.png',
    --             label = Config.equipments_upgrades['rod']['ufe_telerod_370']['name'],
    --             weight = Config.equipments_upgrades['rod']['ufe_telerod_370'].weight
    --         },
    --     })
    -- end, false)

    -- RegisterCommand('fish_add', function (source)
    --     core.server.addItem(source, {
    --         kategori = 'ikan',
    --         jumlah = 1,
    --         metadata = {
    --             tipe = 'sockeye_salmon',
    --             imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/sockeye_salmon.png',
    --             label = Config.fishes_available['sockeye_salmon']['name'],
    --             weight = Config.fishes_available['sockeye_salmon']['weight'],
    --         }
    --     })
    -- end, false)

    -- RegisterCommand('fish_remove', function (source)
    --     if not core.server.removeItem(source, {
    --         kategori = 'ikan',
    --         jumlah = 2,
    --         metadata = {
    --             tipe = 'sockeye_salmon',
    --             imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/sockeye_salmon.png',
    --             label = Config.fishes_available['sockeye_salmon']['name'],
    --             weight = Config.fishes_available['sockeye_salmon']['weight'],
    --         }
    --     }) then print('gaada salmon') end
    -- end, false)

    -- RegisterCommand('rod_count', function (source)
    --     if not core.server.countItem(source, {
    --         kategori = 'rod',
    --         jumlah = 3,
    --         metadata = {
    --             tipe = 'ufe_telerod_370',
    --             imageurl = 'nui://stevid_ikanv2/nui/images/equipments/rod/ufe_telerod_370.png',
    --             label = Config.equipments_upgrades['rod']['ufe_telerod_370']['name'],
    --             weight = Config.equipments_upgrades['rod']['ufe_telerod_370'].weight
    --         },
    --     }) then print('gaada 3 rod') else print('ada rod') end

    -- end, false)

    -- RegisterCommand('rod_search', function (source)
    --     local data = core.server.searchItem(source, {
    --         kategori = 'rod',
    --         metadata = {
    --             tipe = 'ufe_telerod_370',
    --             imageurl = 'nui://stevid_ikanv2/nui/images/equipments/rod/ufe_telerod_370.png',
    --             label = Config.equipments_upgrades['rod']['ufe_telerod_370']['name'],
    --             weight = Config.equipments_upgrades['rod']['ufe_telerod_370'].weight
    --         },
    --     })
    --     lib.print.info(data)
    -- end, false)
end







