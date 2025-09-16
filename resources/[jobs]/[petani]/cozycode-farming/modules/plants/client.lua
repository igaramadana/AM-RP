local Interact = false
local LocalPlants = {}

function GetPlayerOffset(seed)
    local cfg = Config.Seeds[seed]
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local offset = cfg.Prop.Offsets.Start
    local coords = GetOffsetFromEntityInWorldCoords(ped, offset.x, offset.y, offset.z - 1.0)
    return vec4(coords.x, coords.y, coords.z, GetEntityHeading(ped) - offset.w)
end

function IsPlantable(seed)
    local cfg = Config.Seeds[seed]
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local coords, heading = v3(GetPlayerOffset(seed))
    if cfg.Materials and #cfg.Materials > 0 then
        local ray = StartShapeTestRay(pcoords, coords, 17, ped, 7)
        local _, hit, endCoords, surfaceNormal, materialHash, entity = GetShapeTestResultIncludingMaterial(ray)
        dprint("ATTEMPT PLANT: ", seed, "Material: ", materialHash)
        if hit then 
            local found = false
            for i=1, #cfg.Materials do
                local material = cfg.Materials[i]
                if type(material) == "number" and materialHash == material then
                    found = true
                    break
                elseif (type(material) == "string" and Materials[material] ~= nil and Materials[material] == materialHash) then
                    found = true
                    break
                end
            end
            if found then
                return true
            end
        end 
    end
    if cfg.Zones and #cfg.Zones > 0 then
        local found = false
        for i=1, #cfg.Zones do
            local zcoord, max_dist = v3(cfg.Zones[i])
            local dist = #(coords - zcoord)
            if dist < max_dist then
                found = true
                break
            end
        end
        if found then
            return true
        end
    end
    return false
end

function CreatePlant(seed)
    if Interact then return end
    Interact = true
    local cfg = Config.Seeds[seed]
    if not cfg then 
        Interact = false 
        return 
    end
    
    local coords, heading = v3(GetPlayerOffset(seed))
    if (IsPlantable(seed)) then 
        ServerCallback("cozycode-farming:createPlant", function(result)
            if result then
                local ped = PlayerPedId()
                FreezeEntityPosition(ped, true)
                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, 1)
                Wait(1000 * Config.Plant.PlantTime)
                ClearPedTasks(ped)
                FreezeEntityPosition(ped, false)
                Interact = false
                ShowNotification("Plant seed successfully!")
            end
            Interact = false
        end, seed, coords)
    else
        ShowNotification("Can't plant here!")
        Interact = false
    end
end

function CreateLocalPlant(key)
    LocalPlants[key] = {}
    local data = GlobalState.Plants[key]
    local cfg = Config.Seeds[data.seed]
    local obj = CreateProp(cfg.Prop.Model, data.coords.x, data.coords.y, data.coords.z, false, true, false)
    FreezeEntityPosition(obj, true)
    LocalPlants[key].object = obj
    CreateThread(function()
        local lastValue = nil

        local startCoords = GetEntityCoords(LocalPlants[key].object)
        local waterPercent = data.water / cfg.WaterNeeded
        local offset = v3(data.coords) + lerp(vector3(0.0, 0.0, 0.0), v3(cfg.Prop.Offsets.End), waterPercent)
        SetEntityCoords(obj, offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, false)

        while LocalPlants[key] and GlobalState.Plants[key] do 
            local data = GlobalState.Plants[key]
            local wait = 1000
            if lastValue ~= data.water then
                Interact = true
                lastValue = data.water
                local startCoords = GetEntityCoords(LocalPlants[key].object)
                local waterPercent = data.water / cfg.WaterNeeded
                local offset = v3(data.coords) + lerp(vector3(0.0, 0.0, 0.0), v3(cfg.Prop.Offsets.End), waterPercent)
                local percent = 0.0
                while percent < 1.0 do
                    percent = percent + Config.Plant.GrowingPerTick
                    local newCoords = lerp(startCoords, offset, percent)
                    SetEntityCoords(obj, newCoords.x, newCoords.y, newCoords.z, 0.0, 0.0, 0.0, false)
                    Wait(Config.Plant.GrowingTick)
                end
                Interact = false
            end
            Wait(wait)
        end
    end)
end

function DestroyLocalPlant(key)
    if LocalPlants[key] then
        DeleteEntity(LocalPlants[key].object)
        LocalPlants[key] = nil
    end
end

function GetLocalPlant(key)
    return LocalPlants[key]
end

function GetPlantCoords(key)
    local data = GlobalState.Plants[key]
    local cfg = Config.Seeds[data.seed]
    local coords = vector3(data.coords.x, data.coords.y, GetEntityCoords(PlayerPedId()).z)
    return coords
end

function ShowPlantInteract(key)
    local data = GlobalState.Plants[key]
    local cfg = Config.Seeds[data.seed]
    local percent = math.floor((data.water / cfg.WaterNeeded) * 100)
    if percent < 100 then
        ShowHelpNotification("Press [E] to interact with plant")
    else
        ShowHelpNotification("Press [E] to harvest plant")
    end
    return true
end

function InteractPlant(key)
    if Interact then return end
    Interact = true
    local data = GlobalState.Plants[key]
    if not data then Interact = false return end
    
    local cfg = Config.Seeds[data.seed]
    if not cfg then Interact = false return end


    SendNUIMessage({
        type = 'showPlant',
        plant = {
            id = key,
            name = cfg.label or data.seed,
            growth = math.floor((data.water / cfg.WaterNeeded) * 100), 
            water = math.floor((data.water / cfg.WaterNeeded) * 100), 
            quality = 100
        }
    })
    SetNuiFocus(true, true)
end

CreateThread(function()
    while true do
        local wait = 1000
        local Plants = GlobalState.Plants
        local pcoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Plants) do
            local coords = GetPlantCoords(k)
            local dist = #(coords - pcoords)
            local plant = GetLocalPlant(k)
            if (dist < Config.Plant.RenderDistance) then
                wait = 0
                if (not plant) then
                    CreateLocalPlant(k)
                end
                if (not Interact and dist < 1.5) then
                    ShowPlantInteract(k)
                    if IsControlJustPressed(0, 38) then
                        InteractPlant(k)
                    end
                end
            elseif (plant) then
                DestroyLocalPlant(k)
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent("cozycode-farming:removePlant", function(key)
    DestroyLocalPlant(key)
end)

RegisterNetEvent("cozycode-farming:plantSeed", function(seed)
    CreatePlant(seed)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k,v in pairs(LocalPlants) do
        DestroyLocalPlant(k)
    end
end)

local function ShowPlantUI(plant)
    if not plant then return end
    
    SendNUIMessage({
        type = 'showPlant',
        plant = {
            id = plant.id,
            name = Config.Plants[plant.type].label,
            growth = plant.growth or 0,
            water = plant.water or 0,
            quality = plant.quality or 0
        }
    })
    SetNuiFocus(true, true)
end

local function HidePlantUI()
    SendNUIMessage({
        type = 'hidePlant'
    })
    SetNuiFocus(false, false)
end


RegisterNUICallback('closeUI', function(data, cb)
    SendNUIMessage({
        type = 'hidePlant'
    })
    SetNuiFocus(false, false)
    Interact = false
    cb('ok')
end)

RegisterNUICallback('waterPlant', function(data, cb)
    local key = data.plantId
    if not key then cb('ok') return end

    local plantData = GlobalState.Plants[key]
    if not plantData then cb('ok') return end

    ServerCallback("cozycode-farming:waterPlant", function(result)
        if result then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local can = CreateObject(`prop_wateringcan`, coords.x, coords.y, coords.z, true, true, true)
            local boneID = GetPedBoneIndex(ped, 0x8CBD)
            AttachEntityToEntity(can, ped, boneID, 0.15, 0.0, 0.4, 0.0, -180.0, -140.0, false, false, false, true, 1, true)
            PlayAnim(PlayerPedId(), "missfbi3_waterboard", "waterboard_loop_player", -8.0, 8.0, -1, 49, 1.0)
            
            Wait(1000 * Config.Plant.WaterTime)
            ClearPedTasks(PlayerPedId())
            DeleteEntity(can)
            

            local newData = GlobalState.Plants[key]
            if newData then
                local cfg = Config.Seeds[newData.seed]
                SendNUIMessage({
                    type = 'updatePlant',
                    plant = {
                        id = key,
                        name = cfg.label or newData.seed,
                        growth = math.floor((newData.water / cfg.WaterNeeded) * 100),
                        water = math.floor((newData.water / cfg.WaterNeeded) * 100),
                        quality = 100
                    }
                })
            end
            Interact = false
        end
        Interact = false
    end, key)
    cb('ok')
end)

RegisterNUICallback('harvestPlant', function(data, cb)
    local key = data.plantId
    if not key then cb('ok') return end
    
    local plantData = GlobalState.Plants[key]
    if not plantData then cb('ok') return end
    
    if Interact then cb('ok') return end
    Interact = true

    ServerCallback("cozycode-farming:harvestPlant", function(result)
        if result then
            local ped = PlayerPedId()
            FreezeEntityPosition(ped, true)
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, 1)
            Wait(1000 * Config.Plant.HarvestTime)
            ClearPedTasks(ped)
            FreezeEntityPosition(ped, false)
            

            SendNUIMessage({
                type = 'hidePlant'
            })
            SetNuiFocus(false, false)
            

            DestroyLocalPlant(key)
            

            ShowNotification("Plant harvested successfully!")
            Interact = false
        else
            Interact = false
            ShowNotification("Cannot harvest this plant yet!")
        end
    end, key)
    cb('ok')
end)


RegisterNetEvent('cozycode-farming:interact', function(plant)
    ShowPlantUI(plant)
end)


RegisterNetEvent('cozycode-farming:updatePlant', function(plant)
    if not plant or not plant.id then return end
    
    local data = GlobalState.Plants[plant.id]
    if not data then return end
    
    local cfg = Config.Seeds[data.seed]
    if not cfg then return end
    
    SendNUIMessage({
        type = 'updatePlant',
        plant = {
            id = plant.id,
            name = cfg.label or data.seed,
            growth = math.floor((data.water / cfg.WaterNeeded) * 100),
            water = math.floor((data.water / cfg.WaterNeeded) * 100),
            quality = 100
        }
    })
end)


CreateThread(function()
    while true do
        Wait(Config.Plant.GrowthTick or 60000) 
        local Plants = GlobalState.Plants
        for k,v in pairs(Plants) do
            if v.water > 0 then
                TriggerServerEvent('cozycode-farming:growPlant', k)
            end
        end
    end
end)