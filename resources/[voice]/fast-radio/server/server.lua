local Framework, frameworkName = getFramework()
RADIO_DATA = {}
local talking = {}

RegisterNetEvent('fast-radio:getPlayersC', function(frequency)
    if RADIO_DATA[frequency] then
        TriggerClientEvent("fast-radio:client:getPlayersC", source, RADIO_DATA[frequency].users)
        -- return 
    else
        -- return false
    end
end)


-- lib.callback.register('fast-radio:getPlayerData', function(freq)
--     if RADIO_DATA[frequency] then 
--         return RADIO_DATA[frequency].users
--     else
--         return false
--     end
-- end)

RegisterNetEvent('fast-radio:connectChannel')
AddEventHandler('fast-radio:connectChannel', function(freq)
    local src = source 

    if not RADIO_DATA[freq] then
        RADIO_DATA[freq] = {
            users = {}
        }
    end
    local userIndex = #RADIO_DATA[freq]["users"] + 1
    RADIO_DATA[freq]["users"][userIndex] = {
        id = src,
        PlayerName = getName(src),
        IsTalking = false
    }
    
    updateMembers(src, RADIO_DATA[freq]["users"])
end)

RegisterNetEvent('fast-radio:disconnect')
AddEventHandler('fast-radio:disconnect', function()
    local src = source
    for k,v in pairs(RADIO_DATA) do
        for a, user in pairs(v.users) do
            if source == user.id then
                RADIO_DATA[k]["users"][a] = nil
                updateMembers(source, RADIO_DATA[k]["users"])
                return true
            end
        end
    end
    return false
end)

AddEventHandler('playerDropped', function (reason)
    local src = source
    for k,v in pairs(RADIO_DATA) do
        for a, user in pairs(v.users) do
            if src == user.id then
                RADIO_DATA[k]["users"][a] = nil
                updateMembers(src, RADIO_DATA[k]["users"])
                break
            end
        end
    end
end)

RegisterNetEvent("pma-voice:setTalkingOnRadio")
AddEventHandler("pma-voice:setTalkingOnRadio", function(value)
    local src = source
    talking[src] = value
    -- TriggerClientEvent('fast-radio:client:getTalkingData', -1, talking)
end)

RegisterNetEvent("fast-radio:isTalking")
AddEventHandler("fast-radio:isTalking", function(value)
    local src = source
    talking[src] = value
    -- TriggerClientEvent('fast-radio:client:getTalkingData', -1, talking)
end)


Citizen.CreateThread(function()
    while true do
        TriggerClientEvent('fast-radio:client:getTalkingData', -1, talking)
        Citizen.Wait(750)
    end
end)


if FastConfig.Core == 'qb' then
    Framework.Functions.CreateUseableItem("radio", function(source, item)
        local src = source
        TriggerClientEvent("fast-radio:useRadio", src, item.name)
    end)
elseif FastConfig.Core == 'esx' then
    Framework.RegisterUsableItem('radio', function(source)
        local xPlayer = Framework.GetPlayerFromId(source)
        TriggerClientEvent("fast-radio:useRadio", source, 'radio')
    end)
else
    -- print("Hata: QBCore veya ESX bulunamadı.")
end

lib.callback.register('fast-radio:getPlayerName', function(source)
    local playerName = getName(source)
    return playerName
end)

function getName(src)
    local xPlayer = getXPlayer(src)
    local fullname

    if xPlayer then
        if FastConfig.Core == "esx" or FastConfig.Core == "oldesx" then
            fullname = xPlayer.getName()
        elseif FastConfig.Core == "qb" then
            fullname = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
        end
    end
    return fullname
end

function getXPlayer(src)
    if FastConfig.Core == "esx" or FastConfig.Core == "oldesx" then
        return Framework.GetPlayerFromId(src)
    elseif FastConfig.Core == "qb" then
        return Framework.Functions.GetPlayer(src)
    end
    return nil
end

-- RegisterServerEvent('fast-radio:leave')
-- AddEventHandler('fast-radio:leave', function(frequency)
--     exports["saltychat"]:RemovePlayerRadioChannel(source, frequency)
-- end)

RegisterNetEvent('fast-radio:addFavoriteChannel')
AddEventHandler('fast-radio:addFavoriteChannel', function(frequency)
    local src = source
    local Identifier = GetPlayerIdentifierByType(src, "license")
    local freqValue = tonumber(frequency)  
    if Identifier and freqValue then
        MySQL.Async.fetchScalar('SELECT frequency FROM favorite_channels WHERE player_id = @player_id AND frequency = @frequency', {
            ['@player_id'] = Identifier,
            ['@frequency'] = freqValue
        }, function(result)
            if result then
                TriggerClientEvent('fast-radio:notify', src, FastConfig.Locales.alreadyFavorite, 'error', 5000)
            else
                MySQL.Async.execute('INSERT INTO favorite_channels (player_id, frequency) VALUES (@player_id, @frequency)', {
                    ['@player_id'] = Identifier,
                    ['@frequency'] = freqValue
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        ReloadData(src, Identifier)
                        TriggerClientEvent('fast-radio:notify', src, FastConfig.Locales.favoriteAdded, 'success', 5000)
                    else
                        TriggerClientEvent('fast-radio:notify', src, FastConfig.Locales.frequencyAddError, 'error', 5000)
                    end
                end)
            end
        end)
    else
        TriggerClientEvent('fast-radio:notify', src, FastConfig.Locales.steamIdNotFound, 'error', 5000)
    end
end)

RegisterNetEvent('fast-radio:removeFavoriteChannel')
AddEventHandler('fast-radio:removeFavoriteChannel', function(frequency)
    local src = source
    local Identifier = GetPlayerIdentifierByType(src, "license")
    local freqValue = tonumber(frequency) 
    if Identifier and freqValue then
        MySQL.Async.execute('DELETE FROM favorite_channels WHERE player_id = @player_id AND frequency = @frequency', {
            ['@player_id'] = Identifier,
            ['@frequency'] = freqValue
        }, function(rowsChanged)
            if rowsChanged > 0 then
                ReloadData(src, Identifier)
                TriggerClientEvent('fast-radio:notify', src, FastConfig.Locales.favoriteRemoved, 'success', 5000)
            else
                TriggerClientEvent('fast-radio:notify', src, FastConfig.Locales.frequencyRemoveError, 'error', 5000)
            end
        end)
    else
        -- TriggerClientEvent('fast-radio:notify', src, FastConfig.Locales.steamIdNotFound, 'error', 5000)
    end
end)


function ReloadData(source, identifier)
    if identifier then
        MySQL.Async.fetchAll('SELECT frequency FROM favorite_channels WHERE player_id = @player_id', {
            ['@player_id'] = identifier
        }, function(favorites)
            local send_data = {}
            
            if favorites and #favorites > 0 then
                for _, favorite in ipairs(favorites) do
                    table.insert(send_data, tonumber(favorite.frequency))  
                end
            end
        
            TriggerClientEvent("fast-radio:client:data_function", source, json.encode(send_data))
        end)
    end
end

RegisterNetEvent("fast-radio:getFavoriteChannels", function()
        local src = source
        local Identifier = GetPlayerIdentifierByType(src, "license")
    
        if Identifier then
            MySQL.Async.fetchAll('SELECT frequency FROM favorite_channels WHERE player_id = @player_id', {
                ['@player_id'] = Identifier
            }, function(favorites)
                local send_data = {}
                
                if favorites and #favorites > 0 then
                    for _, favorite in ipairs(favorites) do
                        table.insert(send_data, tonumber(favorite.frequency))  
                    end
                end
            
                TriggerClientEvent("fast-radio:client:data_function", src, json.encode(send_data))
            end)
        end
end)

lib.callback.register('fast-radio:getPlayerProfile', function(source)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local steamID = nil
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "steam:") then
            steamID = identifier
            break
        end
    end

    if steamID then
        local steamID64 = tonumber(string.sub(steamID, 7), 16)
        local promise = promise.new()

        PerformHttpRequest("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. FastConfig_SV.apiKey .. "&steamids=" .. steamID64, function(err, response, headers)
            if err == 200 then
                local data = json.decode(response)
                if data and data.response and #data.response.players > 0 then
                    local playerInfo = data.response.players[1]
                    local profilePicUrl = playerInfo.avatarfull
                    promise:resolve(profilePicUrl)
                else
                    print("Steam profil bilgileri bulunamadı.")
                    promise:resolve(nil)
                end
            else
                print("Steam API error: Please remember to enter the Steam API key in the apiKey section of the config. Error code: " .. tostring(err))
                promise:resolve(nil)
            end
        end, "GET", "")

        return Citizen.Await(promise)
    else
        return nil
    end
end)

RegisterServerEvent('fast-radio:checkRadioItem')
AddEventHandler('fast-radio:checkRadioItem', function()
    local src = source
    local hasRadio = false
    if FastConfig.Core == "esx" or FastConfig.Core == "oldesx" then
        local xPlayer = Framework.GetPlayerFromId(src)
        if xPlayer then
            local radioItem = xPlayer.getInventoryItem('radio')
            if radioItem and radioItem.count > 0 then
                hasRadio = true
            end
        end
    elseif FastConfig.Core == "qb" then
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            local radioItem = Player.Functions.GetItemByName('radio')
            if radioItem then
                hasRadio = true
            end
        end
    end
    TriggerClientEvent('fast-radio:useRadio', src, hasRadio)
end)

lib.callback.register('fast-radio:getJob', function(source)
    local player = getPlayer(source)

    if frameworkName == "esx" then
        return player.getJob().name or nil
    else
        return player.PlayerData.job.name or nil
    end
end)

function getPlayer(source)
    if frameworkName == "esx" then
        return Framework.GetPlayerFromId(source)
    else
        return Framework.Functions.GetPlayer(source)
    end
end
