local Framework, frameworkName = getFramework()
function SendNotify(text, type, len)
    local validTypes = { "success", "error", "primary" }
    if not table.contains(validTypes, type) then
        type = "primary"
    end
    if frameworkName == "qb" then
        Framework.Functions.Notify(text, type, len)
    elseif frameworkName == "esx" then
        Framework.ShowNotification(text)
    end
end

RegisterNetEvent('fast-radio:notify')
AddEventHandler('fast-radio:notify', function(text, type, len)
    SendNotify(text, type, len)
end)



function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

RegisterNetEvent("fast-radio:client:UseRadio", function(data)
    MessageUI(data)
end)

function MessageUI(data)
    if data == "show" then 
        local year, month, day, hour, minute, second = GetLocalTime()
        local profile_photo = lib.callback.await("fast-radio:getPlayerProfile", false)
        local player_name = lib.callback.await("fast-radio:getPlayerName", false, GetPlayerServerId(PlayerId()))
        TriggerServerEvent("fast-radio:getFavoriteChannels")
        Wait(100)
        local favoriteChannels = FavoriteData or {}
        local playerFirstname, playerLastname = string.match(player_name, "(%S+)%s*(.*)")

        SendNUIMessage({
            openUI = true,
            playerFirstname = playerFirstname or "Unknown",
            playerLastname = playerLastname or "",
            serverTime = string.format("%02d:%02d", GetClockHours(), GetClockMinutes()),
            serverDate = string.format("%02d/%02d/%04d", day, month, year),
            profilePhoto = profile_photo or "img/example_profile.png",
            favChannels = favoriteChannels
        })
        SetNuiFocus(true, true)
    elseif data == "close" then 
        SendNUIMessage({
            closeUI = true  
        })
        SetNuiFocus(false, false)
    elseif data == "update" then 
        TriggerServerEvent("fast-radio:getFavoriteChannels")
        Wait(100)

        SendNUIMessage({
            updateData = true,
            favChannels = FavoriteData or {}
        })
    end 
end





function ToggleRadioAnimAndProp(state) 
    LoadAnimDict("cellphone@")
    if state then
        TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
        radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
        AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
        table.insert(PropList, radioProp)
    else
        StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
        ClearPedTasks(PlayerPedId())
        if radioProp ~= 0 then
            DeleteObject(radioProp)
            radioProp = 0
        end
    end
end 

function GetCoreObject()
    local framework, frameworkName = getFramework()
    return framework, frameworkName
end


local IsUsingRadio = false

function UseRadio()
    if not IsUsingRadio then
        TriggerServerEvent('fast-radio:checkRadioItem')
    else
        MessageUI("close")
        ToggleRadioAnimAndProp(false)
        IsUsingRadio = false
    end
end

RegisterNetEvent('fast-radio:useRadio')
AddEventHandler('fast-radio:useRadio', function(hasRadio)
    if hasRadio then
        ToggleRadioAnimAndProp(true)
        MessageUI("show")
        IsUsingRadio = true
        TriggerServerEvent('fast-radio:getFavoriteChannels')
        TriggerServerEvent('fast-radio:getPlayerProfile')
    else
        SendNotify(FastConfig.Locales.noRadioInInventory)
    end
end)


