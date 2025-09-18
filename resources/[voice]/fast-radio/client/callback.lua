local Framework, frameworkName = getFramework()
RegisterNUICallback("closeUI", function()
    UseRadio()
end)

RegisterNUICallback("error", function()

    SendNotify(FastConfig.Locales.notOnAnyChannel, "error", 5000)
    
end)


RegisterNUICallback("error2", function()

    SendNotify(FastConfig.Locales.uneeddisconnectCurrentChannel, "error", 5000)
    
end)

local playerCooldowns = {}

RegisterNUICallback('setFrequency', function(data, cb)
    local player = source
    local frequency = tonumber(data.frequency)
    local currentTime = GetGameTimer()
    if playerCooldowns[player] and (currentTime - playerCooldowns[player]) < 3000 then
        SendNotify(FastConfig.Locales.spamWaitMessage, "error", 5000)
        cb({ success = false, message = FastConfig.Locales.cooldownActive })
        return
    end
    if not frequency or frequency <= 0 then
        SendNotify(FastConfig.Locales.invalidFrequency, "error", 5000)
        cb({ success = false, message = FastConfig.Locales.invalidFrequency })
        return
    end
    if frequency > FastConfig.ChannelLimit then
        SendNotify(FastConfig.Locales.frequencyLimitExceeded, "error", 5000)
        cb({ success = false, message = FastConfig.Locales.frequencyLimitExceeded })
        return
    end
    local allowedFrequency = FastConfig.AllowedFrequencies[tostring(frequency)] 
    if allowedFrequency then
        local jobName = lib.callback.await('fast-radio:getJob', 5000, player)

        if not jobName then
            SendNotify(FastConfig.Locales.noAccessToChannel, "error", 5000)
            cb({ success = false, message = FastConfig.Locales.noAccessToChannel })
            return
        end
        if not table.contains(allowedFrequency.jobs, jobName) then
            SendNotify(FastConfig.Locales.noAccessToChannel, "error", 5000)
            cb({ success = false, message = FastConfig.Locales.noAccessToChannel })
            return
        end
    end
    local voiceSystem = FastConfig.VoiceSystem
    if voiceSystem == "pma-voice" then
        exports["pma-voice"]:SetRadioChannel(frequency)
        exports['pma-voice']:setRadioVolume(100)
        exports['pma-voice']:setVoiceProperty('radioEnabled', true)
        exports['pma-voice']:setVoiceProperty('micClicks', true)
    elseif voiceSystem == "mumble-voip" then
        exports['mumble-voip']:SetRadioChannel(frequency)
    elseif voiceSystem == "saltychat" then
        exports["saltychat"]:SetRadioChannel(frequency, true)
    end

    TriggerServerEvent("fast-radio:connectChannel", frequency)
    -- TriggerCl")
    CurrentChannel = frequency
    SendNotify(FastConfig.Locales.connectedToChannel .. frequency, "success", 5000)
    cb({ success = true })
    playerCooldowns[player] = currentTime
end)


function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

RegisterNUICallback('disconnectRadio', function(data, cb)
    local player = source
    local voiceSystem = FastConfig.VoiceSystem
    if voiceSystem == "pma-voice" then
        exports['pma-voice']:SetRadioChannel(0)
        exports['pma-voice']:setVoiceProperty('radioEnabled', false)
        exports['pma-voice']:setVoiceProperty('micClicks', false)
    elseif voiceSystem == "mumble-voip" then
        exports['mumble-voip']:SetRadioChannel(0)
    elseif voiceSystem == "saltychat" then
        exports.saltychat:SetRadioChannel('', false)
    end
    TriggerServerEvent("fast-radio:disconnect")
    CurrentChannel = nil
    SendNotify(FastConfig.Locales.leftRadioChannel, "error", 5000)
    cb({ success = true })
end)


local volume = FastConfig.defaultVolume 

RegisterNUICallback('volume', function(data, cb)
    if data.value then
        if volume < 100 then
            volume = volume + 10
            SendNotify(FastConfig.Locales.volumeUp, "info", 5000)
            print(volume)
        else
            SendNotify(FastConfig.Locales.volumeMax, "error", 5000)
        end
    else
        if volume > 0 then
            volume = volume - 10
            SendNotify(FastConfig.Locales.volumeDown, "info", 5000)
            print(volume)
        else
            SendNotify(FastConfig.Locales.volumeMin, "error", 5000)
        end
    end

    if FastConfig.VoiceSystem == "pma-voice" then
        exports['pma-voice']:setRadioVolume(volume)
    elseif FastConfig.VoiceSystem == "mumble-voip" then
        exports['mumble-voip']:setRadioVolume(volume)
    elseif FastConfig.VoiceSystem == "saltychat" then
        exports['saltychat']:SetRadioVolume(volume)
    end

    cb({ success = true })
end)

RegisterNUICallback("favChannel", function(_, cb)
    print(json.encode(_))
end)

RegisterNUICallback('getConfig', function(_, cb)
    cb(FastConfig)
end)

RegisterNUICallback("LoadFavorite", function()
    MessageUI("update")
end)

RegisterNUICallback('addFavoriteChannel', function(data, cb)
    local frequency = tonumber(data.frequency) 
    if frequency then

        if not frequency or frequency <= 0 then
            SendNotify(FastConfig.Locales.invalidFrequency, "error", 5000)
            cb({ success = false, message = FastConfig.Locales.invalidFrequency })
            return
        end
        if frequency > FastConfig.ChannelLimit then
            SendNotify(FastConfig.Locales.frequencyLimitExceeded, "error", 5000)
            cb({ success = false, message = FastConfig.Locales.frequencyLimitExceeded })
            return
        end

        local alreadyAdded = false
        -- local favoriteChannels = lib.callback.await("fast-radio:getFavoriteChannels", false)
        if FavoriteData then 
            for _, favFreq in ipairs(FavoriteData) do
                if favFreq == frequency then
                    alreadyAdded = true
                    break
                end
            end
        end

        if not alreadyAdded then

            TriggerServerEvent('fast-radio:addFavoriteChannel', frequency)  
        else
          
            SendNotify("Bu frekans zaten favorilere eklenmiş.", "error", 5000)
      
        end
    end
    cb('ok')
end)

-- RegisterNUICallback("getFavorited", function(data, cb)
--     for k, v in pairs(FavoriteData) do 
--         -- print(v)
--         -- print(data.frequency)
--         if tonumber(data.frequency) == v then 
--             cb(true)
--             -- break
--         else
--             cb(false)
--         end
--     end
 
-- end)

RegisterNUICallback('removeFavoriteChannel', function(data, cb)
    -- print(data.frequency)
    local frequency = tonumber(data.frequency) 
    if frequency then
        TriggerServerEvent('fast-radio:removeFavoriteChannel', frequency) 
    end
    cb(true)
end)

-- RegisterNetEvent('fast-radio:favoriteAdded')
-- AddEventHandler('fast-radio:favoriteAdded', function(frequency)
--     table.insert(favoriteChannels, frequency)
--     SendNUIMessage({
--         type = "updateFavorites",
--         channels = favoriteChannels
--     })
--     SendNUIMessage({
--         type = "notify",
--         message = "Frekans favorilere eklendi: " .. frequency
--     })
-- end)


RegisterNetEvent('fast-radio:favoriteRemoved')
AddEventHandler('fast-radio:favoriteRemoved', function(frequency)
    for i = #favoriteChannels, 1, -1 do
        if favoriteChannels[i] == frequency then
            table.remove(favoriteChannels, i)
            break
        end
    end
    SendNUIMessage({
        type = "updateFavorites",
        channels = favoriteChannels
    })
    SendNUIMessage({
        type = "notify",
        message = "Frekans favorilerden kaldırıldı: " .. frequency
    })
end)