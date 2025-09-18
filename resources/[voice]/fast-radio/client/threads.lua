local Framework, frameworkName = getFramework()

function CheckItem()
    local PlayerItems
    if FastConfig.Core == "qb" then
        PlayerItems = Framework.Functions.GetPlayerData().items
    elseif FastConfig.Core == "esx" then
        PlayerItems = Framework.GetPlayerData().inventory
    else
        return false
    end

    for _, v in pairs(PlayerItems) do
        if v.name == FastConfig.Radio_Item and (FastConfig.Core ~= "esx" or v.count > 0) then
            return true
        end
    end

    return false
end

function DisconnectRadio()
    local voiceSystem = FastConfig.VoiceSystem
    if voiceSystem == "pma-voice" then
        exports['pma-voice']:SetRadioChannel(0)
        exports['pma-voice']:setVoiceProperty('radioEnabled', false)
        exports['pma-voice']:setVoiceProperty('micClicks', false)
    elseif voiceSystem == "mumble-voip" then
        exports['mumble-voip']:SetRadioChannel(0)
    elseif voiceSystem == "saltychat" then
        exports.saltychat:SetRadioChannel('', true)
    end
    TriggerServerEvent("fast-radio:disconnect")

    SendNUIMessage({
        disconnectRadio = true,
         
    })

   
    CurrentChannel = nil
    SendNotify(FastConfig.Locales.leftRadioChannel, "error", 5000)
end

CreateThread(function()
    while true do
        local sleep = 2500

        if FastConfig.ItemCheck and CurrentChannel then
            if not CheckItem() then
                DisconnectRadio()
            end
        end

        Wait(sleep)
    end
end)

local nuiOpen = false

function toggleNUI(open)
    nuiOpen = open
    SetNuiFocus(open, open)
    SendNUIMessage({ closeUI = not open })
end

AddEventHandler('gameEventTriggered', function(event, data)
    if event == "CEventNetworkEntityDamage" then
        local entity = data[1]
        local playerPed = PlayerPedId()        
        if entity == playerPed and IsEntityDead(playerPed) then
            DisconnectRadio()
            ToggleRadioAnimAndProp(false)
            toggleNUI(false)
        end
        
        if nuiOpen then
            SetNuiFocus(true, true)
        end
    end
end)

function openNUI()
    toggleNUI(true)
end

function closeNUI()
    toggleNUI(false)
end



