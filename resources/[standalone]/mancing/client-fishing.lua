local fishing_rod_object = nil
local fish_ped = nil
local fishing_line_rope = nil
local is_fishing = false
local fishing_areas = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- Fishing Area
-----------------------------------------------------------------------------------------------------------------------------------------


-- RegisterCommand('stf', function ()
-- 	TriggerEvent('stevid_ikanv2:startFishing')
-- end)

RegisterNetEvent('stevid_ikanv2:startFishing')
AddEventHandler('stevid_ikanv2:startFishing', function()
	local current_area = getCurrentFishingArea()
	local ped = PlayerPedId()

	if not current_area then
		exports['sstore_utils']:notify("error", Utils.translate("area_not_found"))
		return
	end

	local isAtWater, coordForUI = isPointInWater()
	if not isAtWater or not coordForUI then
		exports['sstore_utils']:notify("error", Utils.translate("water_not_found"))
		return
	end

	if IsPedInAnyVehicle(ped, false) then
		exports['sstore_utils']:notify("error", Utils.translate("cannot_fish_in_vehicle"))
		return
	end

	if IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped) then
		exports['sstore_utils']:notify("error", Utils.translate("area_not_found"))
		return
	end

	TriggerServerEvent('stevid_ikanv2:removeBait')

	-- Utils.Callback.TriggerServerCallback('fishing_simulator:getDataFishing', function(fishing_data)
	-- 	initFishing(fishing_data)
	-- end, current_area)

	-- initFishing({
	-- 	selected_equipments = {
	-- 		rod = {item = 'ufe_telerod_370'},
	-- 		reel = {item = 'ufe_canta_1000'},
	-- 		hook = {item = 'ufa_bait_hook'},
	-- 		bait = {item = 'bread'},
	-- 		line = {item = 'express_fishing_super_line'},
	-- 		-- bonus = 10,
	-- 	},
	-- 	fishing_simulator_user = {}
	-- })
	local fishData = lib.callback.await('stevid_ikanv2:getFishingData')
	local user = lib.callback.await('stevid_ikanv2:getUserData')
	local totalBonus = 0

	for k,v in pairs(fishData) do
		totalBonus += Config.equipments_upgrades[k][v.item].bonus
	end

	fishData.bonus = totalBonus

	-- print('total bonus', totalBonus)

	initFishing({
		selected_equipments = fishData,
		fishing_simulator_user = user
	})
end)

function initFishing(fishing_data)
	if is_fishing == false then

		local area = getCurrentFishingArea()
		if not area then
			exports['sstore_utils']:notify("error", Utils.translate("area_not_found"))
			return
		end

		local isAtWater, coordForUI = isPointInWater()
		if not isAtWater or not coordForUI then
			exports['sstore_utils']:notify("error", Utils.translate("water_not_found"))
			return
		end

		is_fishing = true

		createRodAndStartAnim(coordForUI)
		disableActions()
		
		if Config.MinigameNP then
			local fishData = generateFish()
			local Equipments = lib.callback.await('stevid_ikanv2:getFishingData')
			local eqLevel = 0
			eqLevel += Config.equipments_upgrades['rod'][Equipments.rod.item].bonus
			eqLevel += Config.equipments_upgrades['reel'][Equipments.reel.item].bonus
			eqLevel += Config.equipments_upgrades['hook'][Equipments.hook.item].bonus
			eqLevel += Config.equipments_upgrades['bait'][Equipments.bait.item].bonus
			eqLevel += Config.equipments_upgrades['line'][Equipments.line.item].bonus
			local rarities = {
				["common"] = 1,
				["uncommon"] = 2,
				["rare"] = 3,
				["legendary"] = 4,
				["mythic"] = 5,
			}
			local playerInfluence, automaticSpeed, directionChangeInterval, fishInterval = exports.sstore_ikanv2_np:hitungDifficulty(Config.fishing_difficulties['tension'], rarities[fishData.fish_data.rarity], eqLevel)
			Wait(math.random(Config.fishing_difficulties['bait_hook_wait']['min'] * 1000, Config.fishing_difficulties['bait_hook_wait']['max'] *1000))
			StartMinigameNP(playerInfluence, automaticSpeed, directionChangeInterval, fishInterval, function (success)
				if success then
					SetNuiFocus(true, true)
					SendNUIMessage({
						showFishDetails = true,
						resourceName = GetCurrentResourceName(),
						utils = { config = Utils.Config, lang = Utils.Lang },
						fishData = fishData.fish_data,
					})
				else
					stopAnimAndClearItems()
				end
			end)
		else
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
			local _, _x,_y = GetScreenCoordFromWorldCoord(coordForUI.x,coordForUI.y,coordForUI.z)
			fishing_data.fishing_simulator_user.x = _x
			fishing_data.fishing_simulator_user.y = _y
			SendNUIMessage({
				startFishing = true,
				resourceName = GetCurrentResourceName(),
				utils = { config = Utils.Config, lang = Utils.Lang },
				fishing_difficulties = Utils.Table.deepCopy(Config.fishing_difficulties),
				equipments_upgrades = Utils.Table.deepCopy(Config.equipments_upgrades),
				fishing_simulator_user = fishing_data.fishing_simulator_user,
				selected_equipments = fishing_data.selected_equipments
			});
			SetTimeout(1500, function ()
				SetNuiFocus(true, true)
				SetNuiFocusKeepInput(true)
			end)
			updateFishingCoords(coordForUI)
		end
	end
end

function updateFishingCoords(coordForUI)
	Citizen.CreateThread(function()
		while is_fishing do
			Wait(10)
			local onScreen, _x,_y = GetScreenCoordFromWorldCoord(coordForUI.x,coordForUI.y,coordForUI.z)
			SendNUIMessage({
				updateFishingCoords = true,
				x = _x,
				y = _y
			});
		end
	end)
end
local FishByPlaces = {
    sea = {},
    river = {},
    lake = {},
    swamp = {}
}

local FishByPlacesAndRarity = {
    sea = {
        common = {},
        uncommon = {},
        rare = {},
        legendary = {},
        mythic = {}
    },
    river = {
        common = {},
        uncommon = {},
        rare = {},
        legendary = {},
        mythic = {}
    },
    lake = {
        common = {},
        uncommon = {},
        rare = {},
        legendary = {},
        mythic = {}
    },
    swamp = {
        common = {},
        uncommon = {},
        rare = {},
        legendary = {},
        mythic = {}
    }
}
local rarities = {
    [1] = 'common',
    [2] = 'uncommon',
    [3] = 'rare',
    [4] = 'legendary',
    [5] = 'mythic'
}
local fishesA = lib.table.deepclone(Config.fishes_available)
for k,v in pairs(fishesA) do
    for area in pairs(Config.areas_available_to_fish) do
        if lib.table.contains(v['areas'], area) then
            v.key = k
            FishByPlaces[area][k] = v
        end
    end
end

for area, isiArea in pairs(FishByPlaces) do
    for namaIkan, dataIkan in pairs(isiArea) do
        FishByPlacesAndRarity[area][dataIkan.rarity][#FishByPlacesAndRarity[area][dataIkan.rarity]+1] = namaIkan
    end
end

-- Create a function to pick a value based on the probabilities
local function getRandomByProbability(prob)
    -- Step 1: Calculate the total sum of all probabilities
    local total = 0
    for _, p in pairs(prob) do
        total = total + p
    end

    -- Step 2: Generate a random number between 1 and the total sum
    local rand = math.random(1, total)

    -- Step 3: Iterate through the probability table and determine which value corresponds to the random number
    local cumulative = 0
    for value, p in pairs(prob) do
        cumulative = cumulative + p
        if rand <= cumulative then
            return value
        end
    end
end

randomArray = function(array, kecuali, validasi)
    if table.type(array) ~= 'array' then
        local a1 = {}
        for k,v in pairs(array) do
            a1[#a1+1] = v
        end
        array = a1
    end
    local id = math.random(1, #array)
    if kecuali then
        if type(kecuali) == 'number' then
            if id == kecuali then
                return randomArray(array, kecuali, validasi)
            end
        else
            if next(kecuali) and lib.table.contains(kecuali, id) then
                return randomArray(array, kecuali, validasi)
            end
        end
    end
    if validasi then
        if validasi(array[id]) then
            return array[id], id
        else
            return randomArray(array, kecuali, validasi)
        end
    end
    return array[id], id
end

function generateFish()
	if Config.Random == 'server' then
		local fishing_data = lib.callback.await('stevid_ikanv2:generateFish', false, getCurrentFishingArea())
		if fishing_data then
			return fishing_data
		end
	else
		local areaLevel = lib.callback.await('stevid_ikanv2:getAreaLevel', false, getCurrentFishingArea())
		local rnd = getRandomByProbability(Config.fishing_difficulties['fish_probability_by_level'][areaLevel])
		local rarity = rarities[rnd]
		local dpt = randomArray(FishByPlaces[getCurrentFishingArea()], nil, function (dapetnya)
			return dapetnya.rarity == rarity
		end)
		TriggerServerEvent('stevid_ikanv2:generatedFish', dpt.key)
		dpt.level = rnd
		dpt.areas = nil
		return {fish_data = dpt}
	end
end

RegisterNUICallback('generateFish', function(body, cb)
	cb(generateFish())
end)

function closeFishingUI()
	SetNuiFocus(false, false)
	TriggerScreenblurFadeOut(1000)
	TriggerServerEvent('stevid_ikanv2:closeUI')
end

RegisterNetEvent('stevid_ikanv2:endFishingGame')
AddEventHandler('stevid_ikanv2:endFishingGame', function(data)
	if data.success then
		TriggerServerEvent('stevid_ikanv2:receiveFish', getCurrentFishingArea(), data.released)
		if data.released then
			stopAnimAndClearItems()
		end
	else
		exports['sstore_utils']:notify("error", Utils.translate("fishing_lost"))
		stopAnimAndClearItems()
	end
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
end)

RegisterNetEvent('stevid_ikanv2:StopFishingGetFish')
AddEventHandler('stevid_ikanv2:StopFishingGetFish', function()
	ClearPedTasks(PlayerPedId())
	local forwardVector = GetEntityForwardVector(PlayerPedId())
	local forwardPos = vector3(GetEntityCoords(PlayerPedId())["x"] + forwardVector["x"] * 5, GetEntityCoords(PlayerPedId())["y"] + forwardVector["y"] * 5, GetEntityCoords(PlayerPedId())["z"])
	local fishHandle = Utils.Peds.spawnPedAtCoords(Config.fish_model, forwardPos.x, forwardPos.y, forwardPos.z + 1, 0.0, false, false, false)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(100)
			local asd = GetEntityCoords(fishHandle, false)
			if Vdist(GetEntityCoords(fishHandle, false), forwardPos) <= 1.5 then
				local plypos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -25.0, 0.4)

				local x = plypos.x - asd.x
				local y = plypos.y - asd.y
				local z = plypos.z - asd.z
				ApplyForceToEntity(fishHandle, 3, x, y, z+1, 0.0, 0.0, 0.0, 1, false, false, true, false, false)
				Citizen.Wait(1500)
				SetEntityCoords(fishHandle, plypos)
				Utils.Animations.loadAnimDict( "random@domestic" )
				TaskPlayAnim( PlayerPedId(), "random@domestic", "pickup_low", 100.0, 1.0, 1000, 0, 0, false, false, false)
				Citizen.Wait(500)
				AttachEntityToEntity(fishHandle, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
				Citizen.Wait(1000)
				Utils.Peds.deletePed(fishHandle)
				stopAnimAndClearItems()
			else
				break
			end
		end
	end)
end)

function disableActions()
	Citizen.CreateThreadNow(function()
		while is_fishing do
			DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
			DisableControlAction(1, 140, true) -- Disables the pointing action
			Wait(0)
		end
	end)
end

function isPointInWater()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local forwardVector = GetEntityForwardVector(playerPed)

	local waterPoint = vector3(playerCoords.x + forwardVector.x * 40, playerCoords.y + forwardVector.y * 40, playerCoords.z - 2.0)

	-- Function to check if a single point is in water
	local function isSinglePointInWater(point)
		local waterFound, waterHeight = GetWaterHeight(point.x, point.y, point.z)
		if waterFound and waterHeight then
			return true, vec3(point.x, point.y, waterHeight)
		else
			return false
		end
	end

	-- Check if the entire path is in water
	local numSamples = 5
	local isInWater = true
	local waterHeightPoint = nil

	for i = 1, numSamples do
		local t = i / numSamples
		local interpolatedPoint = vector3(
			playerCoords.x + (waterPoint.x - playerCoords.x) * t,
			playerCoords.y + (waterPoint.y - playerCoords.y) * t,
			playerCoords.z + (waterPoint.z - playerCoords.z) * t
		)
		local singlePointInWater, heightPoint = isSinglePointInWater(interpolatedPoint)

		if not singlePointInWater then
			local entity = Utils.Peds.spawnPedAtCoords(Config.fish_model, interpolatedPoint.x, interpolatedPoint.y, interpolatedPoint.z, 0.0, false, false, false)
			SetEntityVisible(entity, false, false)
			Wait(100)
			if not IsEntityInWater(entity) then
				isInWater = false
				break
			else
				waterHeightPoint = interpolatedPoint
			end
			Utils.Peds.deletePed(entity)
		else
			waterHeightPoint = heightPoint
		end
	end

	if isInWater and waterHeightPoint then
		return true, waterHeightPoint
	else
		return false
	end
end

function getCurrentFishingArea()
	local plyPos = GetEntityCoords(PlayerPedId())
	local zone = GetNameOfZone(plyPos)
	return Config.waterTypes?[zone] or nil
end

function executeAnim(dict, anim, flag)
	Utils.Animations.loadAnimDict(dict)

	TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, 5000.0, flag, 0, false, false, false)
	RemoveAnimDict(dict)
end

function createRodAndStartAnim(fishPosition)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)

	local fishingRodHash = GetHashKey(Config.rod_model)
	Utils.Entity.loadModel(fishingRodHash)

	fishing_rod_object = CreateObject(fishingRodHash, playerCoords.x, playerCoords.y, playerCoords.z, true, false, false)
	AttachEntityToEntity(fishing_rod_object, playerPed, GetPedBoneIndex(playerPed, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
	SetModelAsNoLongerNeeded(fishingRodHash)

	if not Config.disable_fishing_line then
		RopeLoadTextures()
		while not RopeAreTexturesLoaded() do
			Wait(0)
			RopeLoadTextures()
		end
		fishing_line_rope = nil
		fishing_line_rope = AddRope(fishPosition.x, fishPosition.y, fishPosition.z, 0.0, 0.0, 0.0, 40.0, 5, 1000.0, 0.0, 1.0, false, false, false, 1.0, true)
		while not DoesRopeExist(fishing_line_rope) do
			Wait(0)
		end
		Wait(50)
		ActivatePhysics(fishing_line_rope)
		Wait(50)
		fish_ped = Utils.Peds.spawnPedAtCoords(Config.fish_model, fishPosition.x, fishPosition.y, fishPosition.z, 0.0, true, false, false)

		local fishingRodPos = GetOffsetFromEntityInWorldCoords(fishing_rod_object, 0.0, 0.01, 2.5)
		AttachEntitiesToRope(fishing_line_rope, fish_ped, fishing_rod_object, fishPosition.x, fishPosition.y, fishPosition.z, fishingRodPos.x, fishingRodPos.y, fishingRodPos.z, 40.0, false, false, nil, nil)
	end

	executeAnim("amb@world_human_stand_fishing@idle_a", "idle_c", 1)
end

function stopAnimAndClearItems()
    RopeUnloadTextures()
    if fishing_line_rope then DeleteRope(fishing_line_rope) end
	if fishing_rod_object then DeleteEntity(fishing_rod_object) end
	if fish_ped then Utils.Peds.deletePed(fish_ped) end
	ClearPedTasks(PlayerPedId())

	fishing_rod_object = nil
	fish_ped = nil
	is_fishing = false
	main_ui_open = false
	Wait(1000)
end

RegisterCommand('zonename', function ()
	local zone = GetNameOfZone(GetEntityCoords(cache.ped))
	print(zone)
end, false)