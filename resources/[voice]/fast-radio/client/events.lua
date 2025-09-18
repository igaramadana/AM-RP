local Framework, frameworkName = getFramework()
CurrentRadioData = {}
TalkingTable = {}

AddEventHandler("onResourceStop", function(res)
    if not GetCurrentResourceName() == res then return end
    for _, v in pairs(PropList) do 
        DeleteEntity(v)
    end
end)

RegisterNetEvent("fast-radio:client:getPlayersC", function(data)
    CurrentRadioData = data
end)

function UpdatePlayerList()

    TriggerServerEvent("fast-radio:getPlayersC", CurrentChannel)
    Wait(10)
    if CurrentChannel then 

        
        TotalUser = 0
        for k, v in pairs(CurrentRadioData) do 
            if TalkingTable[v.id] then 
                CurrentRadioData[k].IsTalking = TalkingTable[v.id] 
            end
            TotalUser = TotalUser + 1
        end

        SendNUIMessage({
            sendData = true, 
            radioData = json.encode(CurrentRadioData),
            radioMemberCount = TotalUser,
            current_Channel = tostring(CurrentChannel)
        })
    end
end

function UpdateTalkingData()
    if CurrentChannel then 
        -- Wait
        TotalUser = 0 
        for k, v in pairs(CurrentRadioData) do 
            if TalkingTable[v.id] then 
                CurrentRadioData[k].IsTalking = TalkingTable[v.id] 
            end
            TotalUser = TotalUser + 1
        end

        SendNUIMessage({
            sendData = true, 
            radioData = json.encode(CurrentRadioData),
            radioMemberCount = TotalUser,
            current_Channel = tostring(CurrentChannel)
        })
    end 
end

RegisterNetEvent("fast-radio:client:getTalkingData")
AddEventHandler("fast-radio:client:getTalkingData", function(data)
    if CurrentChannel then 
        TalkingTable = data
        UpdateTalkingData()
    end
end)

RegisterNetEvent("SaltyChat_TalkStateChanged", function(player, key, value)
    if CurrentChannel then
        local talking = false

        if IsEntityPlayingAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 3) then
            talking = true
        else
            if IsEntityPlayingAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 3) then
                talking = true
            end
        end
        TriggerServerEvent('fast-radio:isTalking', talking)
    end
end)

if FastConfig.VoiceSystem == "mumble-voip" and GetResourceState('mumble-voip') == 'started' then
    local lastTalkingState = false

    CreateThread(function()
        while true do
            if not CurrentChannel then
                Wait(1000)
            else
                local talking = NetworkIsPlayerTalking(PlayerId())

                if talking and CurrentChannel then
                    if talking ~= lastTalkingState then
                        TriggerServerEvent('fast-radio:isTalking', talking)
                        lastTalkingState = talking
                    end
                else
                    if lastTalkingState then
                        TriggerServerEvent('fast-radio:isTalking', false)
                        lastTalkingState = false
                    end
                end
                Wait(500)
            end
        end
    end)
end






RegisterNetEvent("fast-radio:client:refreshPlayers")
AddEventHandler("fast-radio:client:refreshPlayers", function()
    UpdatePlayerList()
end)


CreateThread(function()
    while true do 
        if CurrentChannel then 
            UpdatePlayerList()
            Citizen.Wait(250)
        else
            Citizen.Wait(2000)
        end
    end
end)
