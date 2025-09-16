Interact = {}
Plants = {}
GlobalState.Plants = Plants

function UpdatePlants()
    GlobalState.Plants = Plants
end

function CreatePlant(source, seed, coords)
    local allowed, err = CanPlayerPlant(source, seed, coords)
    if allowed then
        RemoveItem(source, seed, 1)
        local key = os.time()
        while Plants[key] do
            key = key .. "_1"
            Wait(0)
        end
        SetTimeout((1000 * Config.Plant.PlantTime), function()
            Plants[key] = {
                source = source,
                seed = seed,
                water = 0,
                growth = 0,
                quality = 100,
                coords = coords
            }
            UpdatePlants()
        end)
        return key
    else
        ShowNotification(source, err)
    end
end

function GetPlayerPlants(source)
    local keys = {}
    for k,v in pairs(Plants) do
        if v.source == source then
            keys[#keys + 1] = k
        end
    end
    return keys
end

function CanPlayerPlant(source, seed, coords)
    local playerPlants = #GetPlayerPlants(source)
    if Search(source, seed) < 1 then
        return false, _L("doesnt_have_this_seed")
    elseif playerPlants + 1 > Config.Plant.MaxPlayerPlants then
        return false, _L("too_many_plants_active") .. " " .. ("..playerPlants.."/"..Config.Plant.MaxPlayerPlants..")
    else
        return true
    end
end

function HarvestPlant(key, source)
    local plant = Plants[key]
    if not plant then return end
    
    local cfg = Config.Seeds[plant.seed]
    if not cfg or not cfg.Rewards then return end


    for i=1, #cfg.Rewards do
        local reward = cfg.Rewards[i]
        local amount = (reward.min < reward.max and math.random(reward.min, reward.max) or reward.min)
        if CanCarryItem(source, reward.name, amount) then
            AddItem(source, reward.name, amount)
        end
    end


    Plants[key] = nil
    UpdatePlants()
    

    TriggerClientEvent("cozycode-farming:removePlant", -1, key)
end

for k,v in pairs(Config.Seeds) do
    RegisterUsableItem(k, function(source)
        TriggerClientEvent("cozycode-farming:plantSeed", source, k)
    end)
end

RegisterCallback("cozycode-farming:createPlant", function(source, cb, seed, coords)
    if Interact[source] then
        cb(false)
        return
    end
    Interact[source] = true
    local plant = CreatePlant(source, seed, coords)
    if plant then
        Interact[source] = false
        cb(plant)
    else
        Interact[source] = false
        cb(false)
    end
end)

RegisterCallback("cozycode-farming:waterPlant", function(source, cb, key)
    if Interact[source] then
        cb(false)
        return
    end
    
    local Plants = GlobalState.Plants
    if not Plants[key] then 
        Interact[source] = false
        cb(false)
        return
    end

    Interact[source] = true
    
    local plant = Plants[key]
    local cfg = Config.Seeds[plant.seed]
    

    plant.water = math.min((plant.water or 0) + Config.Plant.WaterPerUse, cfg.WaterNeeded)
    plant.growth = plant.growth or 0
    plant.quality = plant.quality or 100
    
    Plants[key] = plant
    GlobalState.Plants = Plants
    

    TriggerClientEvent('cozycode-farming:updatePlant', -1, {
        id = key,
        type = plant.seed,
        growth = plant.growth,
        water = plant.water,
        quality = plant.quality
    })
    
    Interact[source] = false
    cb(true)
end)

RegisterCallback("cozycode-farming:harvestPlant", function(source, cb, key)
    if Interact[source] then
        cb(false)
        return
    end

    Interact[source] = true
    local plant = Plants[key]
    
    if not plant then 
        Interact[source] = false
        cb(false)
        return
    end


    HarvestPlant(key, source)
    Interact[source] = false
    cb(true)
end)


RegisterNetEvent('cozycode-farming:growPlant', function(plantId)
    local Plants = GlobalState.Plants
    if Plants[plantId] then
        local plant = Plants[plantId]
        local cfg = Config.Seeds[plant.seed]
        

        plant.growth = plant.growth or 0
        plant.water = plant.water or 0
        plant.quality = plant.quality or 100
        

        if plant.water > 0 then
            local growthIncrease = (plant.water / cfg.WaterNeeded) * (Config.Plant.GrowthRate or 5)
            plant.growth = math.min((plant.growth or 0) + growthIncrease, 100)
            

            plant.water = math.max(0, plant.water - (Config.Plant.WaterDrain or 1))
            
  
            Plants[plantId] = plant
            GlobalState.Plants = Plants
            
         
            TriggerClientEvent('cozycode-farming:updatePlant', -1, {
                id = plantId,
                type = plant.seed,
                growth = plant.growth,
                water = plant.water,
                quality = plant.quality
            })
        end
    end
end)
