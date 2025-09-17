local cam = nil
local charPed = nil
local loadScreenCheckState = false
local QBCore = exports['qb-core']:GetCoreObject()
local cached_player_skins = {}

local randommodels = { -- models possible to load when choosing empty slot
    'mp_m_freemode_01',
    'mp_f_freemode_01',
}

local isCinematicActive = false

-- Define different camera styles
local cameraStyles = {
    {
        rotationSpeed = 0.001,
        zoomSpeed = 0.001,
        minFov = 40.0,
        maxFov = 60.0,
        maxRotationAngle = 10.0,
        angleSpeed = 0.012,
        maxAngle = -09.53,
        minAngle = 08.00
    },
    {
        rotationSpeed = 0.003,
        zoomSpeed = 0.005,
        minFov = 45.0,
        maxFov = 55.0,
        maxRotationAngle = 15.0,
        angleSpeed = 0.0055,
        maxAngle = -15.53,
        minAngle = 15.00
    },
    {
        rotationSpeed = 0.002,
        zoomSpeed = 0.015,
        minFov = 35.0,
        maxFov = 65.0,
        maxRotationAngle = 6.0,
        angleSpeed = 0.016,
        maxAngle = -21.53,
        minAngle = 04.0
    }
}

-- Main Thread

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('qb-multicharacter:client:chooseChar')
			return
		end
	end
end)

-- Functions

local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

-- Function to set ped animation
local function setPedAnimation(ped, name, dic, loop)
    RequestAnimDict(dic)
    while not HasAnimDictLoaded(dic) do
        Wait(500)
    end

    TaskPlayAnim(ped, dic, name, 8.0, 8.0, -1, 1, 0, false, false, false)
end

local function initializePedModel(model, data)
    CreateThread(function()
        if not model then
            model = joaat(randommodels[math.random(#randommodels)])
        end
        loadModel(model)
        charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
        SetPedComponentVariation(charPed, 0, 0, 0, 2)
        FreezeEntityPosition(charPed, false)
        SetEntityInvincible(charPed, true)
        PlaceObjectOnGroundProperly(charPed)
        SetBlockingOfNonTemporaryEvents(charPed, true)
        setPedAnimation(charPed, 'base', 'timetable@ron@ig_3_couch', true)
        if data then
            TriggerEvent('qb-clothing:client:loadPlayerClothing', data, charPed)
        end
    end)
end

local function chooseRandomStyle()
    local index = math.random(1, #cameraStyles)
    return cameraStyles[index]
end

local function skyCam(bool)
    TriggerEvent('qb-weathersync:client:DisableSync')

    if bool then
        local style = chooseRandomStyle()

        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(PlayerPedId(), false)
        
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.CamCoords.x, Config.CamCoords.y, Config.CamCoords.z, 0.00, 0.00, Config.CamCoords.w, style.maxFov, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        
        isCinematicActive = true
        Citizen.CreateThread(function()
            local rotation = Config.CamCoords.w
            local rotatingRight = true
            local currentFov = style.maxFov
            local zoomingIn = true
            local currentAngle = style.maxAngle
            local angleIncreasing = true

            while isCinematicActive do
                if rotatingRight then
                    rotation = rotation + style.rotationSpeed
                    if rotation >= Config.CamCoords.w + style.maxRotationAngle then
                        rotatingRight = false
                    end
                else
                    rotation = rotation - style.rotationSpeed
                    if rotation <= Config.CamCoords.w - style.maxRotationAngle then
                        rotatingRight = true
                    end
                end

                if zoomingIn then
                    currentFov = currentFov - style.zoomSpeed
                    if currentFov <= style.minFov then
                        zoomingIn = false
                    end
                else
                    currentFov = currentFov + style.zoomSpeed
                    if currentFov >= style.maxFov then
                        zoomingIn = true
                    end
                end

                if angleIncreasing then
                    currentAngle = currentAngle - style.angleSpeed
                    if currentAngle <= style.maxAngle then
                        angleIncreasing = false
                    end
                else
                    currentAngle = currentAngle + style.angleSpeed
                    if currentAngle >= style.minAngle then
                        angleIncreasing = true
                    end
                end

                SetCamRot(cam, 0.0, currentAngle, rotation, 2)
                SetCamFov(cam, currentFov)

                Citizen.Wait(0)
            end
        end)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)

        isCinematicActive = false
    end
end

local function openCharMenu(bool)
    QBCore.Functions.TriggerCallback("qb-multicharacter:server:GetNumberOfCharacters", function(result)
        local translations = {}
        for k in pairs(Lang.fallback and Lang.fallback.phrases or Lang.phrases) do
            if k:sub(0, ('ui.'):len()) then
                translations[k:sub(('ui.'):len() + 1)] = Lang:t(k)
            end
        end
        SetNuiFocus(bool, bool)
        SendNUIMessage({
            action = "ui",
            customNationality = Config.customNationality,
            toggle = bool,
            nChar = result,
            enableDeleteButton = Config.EnableDeleteButton,
            translations = translations
        })
        skyCam(bool)
        if not loadScreenCheckState then
            ShutdownLoadingScreenNui()
            loadScreenCheckState = true
        end
    end)
end

-- Events

RegisterNetEvent('qb-multicharacter:client:closeNUIdefault', function() -- This event is only for no starting apartments
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    DoScreenFadeOut(500)
    Wait(2000)
    SetEntityCoords(PlayerPedId(), Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    Wait(500)
    openCharMenu()
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerEvent('qb-weathersync:client:EnableSync')
    TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end)

RegisterNetEvent('qb-multicharacter:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    skyCam(false)
end)

RegisterNetEvent('qb-multicharacter:client:chooseChar', function()
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Wait(1000)
    local interior = GetInteriorAtCoords(Config.Interior.x, Config.Interior.y, Config.Interior.z - 18.9)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Wait(1000)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    openCharMenu(true)
end)

RegisterNetEvent('qb-multicharacter:client:spawnLastLocation', function(coords, cData)
    local result = lib.callback.await('ps-housing:cb:GetOwnedApartment', source, cData.citizenid)
    if result then
        TriggerEvent("apartments:client:SetHomeBlip", result.type)
    end
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
    SetEntityHeading(ped, coords.w)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local insideMeta = PlayerData.metadata["inside"]
    DoScreenFadeOut(500)
    if insideMeta.propertyId then
        TriggerServerEvent('ps-housing:server:enterProperty', tostring(insideMeta.propertyId))
    else
        SetEntityCoords(ped, coords.x, coords.y, coords.z)
        SetEntityHeading(ped, coords.w)
        FreezeEntityPosition(ped, false)
        SetEntityVisible(ped, true)
    end
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    Wait(2000)
    DoScreenFadeIn(250)
end)

-- NUI Callbacks

RegisterNUICallback('closeUI', function(_, cb)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('qb-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if Config.SkipSelection then
        SetNuiFocus(false, false)
        skyCam(false)
    else
        openCharMenu(false)
    end
    cb("ok")
end)

RegisterNUICallback('disconnectButton', function(_, cb)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('qb-multicharacter:server:disconnect')
    cb("ok")
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('qb-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    cb("ok")
end)

RegisterNUICallback('cDataPed', function(nData, cb)
    local cData = nData.cData
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        if not cached_player_skins[cData.citizenid] then
            local temp_model = promise.new()
            local temp_data = promise.new()

            QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(model, data)
                temp_model:resolve(model)
                temp_data:resolve(data)
            end, cData.citizenid)

            local resolved_model = Citizen.Await(temp_model)
            local resolved_data = Citizen.Await(temp_data)

            cached_player_skins[cData.citizenid] = {model = resolved_model, data = resolved_data}
        end

        local model = cached_player_skins[cData.citizenid].model
        local data = cached_player_skins[cData.citizenid].data

        model = model ~= nil and tonumber(model) or false

        if model ~= nil then
            initializePedModel(model, json.decode(data))
        else
            initializePedModel()
        end
        cb("ok")
    else
        initializePedModel()
        cb("ok")
    end
end)

RegisterNUICallback('setupCharacters', function(_, cb)
    QBCore.Functions.TriggerCallback("qb-multicharacter:server:setupCharacters", function(result)
	cached_player_skins = {}
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
        cb("ok")
    end)
end)

RegisterNUICallback('removeBlur', function(_, cb)
    SetTimecycleModifier('default')
    cb("ok")
end)

RegisterNUICallback('createNewCharacter', function(data, cb)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == Lang:t("ui.male") then
        cData.gender = 0
    elseif cData.gender == Lang:t("ui.female") then
        cData.gender = 1
    end
    TriggerServerEvent('qb-multicharacter:server:createCharacter', cData)
    Wait(500)
    cb("ok")
end)

RegisterNUICallback('removeCharacter', function(data, cb)
    TriggerServerEvent('qb-multicharacter:server:deleteCharacter', data.citizenid)
    DeletePed(charPed)
    TriggerEvent('qb-multicharacter:client:chooseChar')
    cb("ok")
end)

RegisterNetEvent("qb-multicharacter:client:destroyCam", function ()
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    RenderScriptCams(false, false, 1, true, true)
end)