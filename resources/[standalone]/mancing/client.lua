-- Utils = Utils or exports['sstore_utils']:GetUtils()
main_ui_open = false
current_fishing_location_id = nil
cached_translations = {}
local fishAvailable = nil

local sortir = function(tb)
    local cc = {}
    for k, v in pairs(tb) do
        if v then
            cc[#cc + 1] = v
        end
    end
    return cc
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------	

-- Main menu locations
function createMarkersThread()
	-- Process the fishing location ui markers
	for fishing_location_id,fishing_location_data in pairs(Config.fishing_locations) do
		Citizen.CreateThreadNow(function()
			while true do
				local timer = 1500
				if not main_ui_open then
					local x,y,z = table.unpack(fishing_location_data.menu_location)
					if Utils.Entity.isPlayerNearCoords(x,y,z,20.0) then
						timer = 2
						Utils.Markers.createMarkerInCoords(fishing_location_id,x,y,z,cached_translations.open,openFishingUiCallback)
					end
				end
				Citizen.Wait(timer)
			end
		end)
	end

	-- Process the fishing properties ui markers
	for property_id, property_location_data in pairs(Config.available_items_store.property) do
		Citizen.CreateThreadNow(function()
			local timer = 2
			while true do
				timer = 1500
				if not main_ui_open then
					local x,y,z = table.unpack(property_location_data.location)
					if Utils.Entity.isPlayerNearCoords(x,y,z,20.0) then
						timer = 2
						Utils.Markers.createMarkerInCoords(property_id,x,y,z,cached_translations.open,openPropertyUiCallback)
					end
				end
				Citizen.Wait(timer)
			end
		end)
	end

	-- Process the fishing stores ui markers
	for fishing_store_id,fishing_store_data in pairs(Config.fish_stores) do
		Citizen.CreateThreadNow(function()
			while true do
				local timer = 1500
				if not main_ui_open then
					local x,y,z = table.unpack(fishing_store_data.menu_location)
					if Utils.Entity.isPlayerNearCoords(x,y,z,20.0) then
						timer = 2
						Utils.Markers.createMarkerInCoords(fishing_store_id,x,y,z,cached_translations.open,openFishingStoreUiCallback)
					end
				end
				Citizen.Wait(timer)
			end
		end)
	end
end

function createTargetsThread()
	-- Process the fishing location ui target
	for fishing_location_id,fishing_location_data in pairs(Config.fishing_locations) do
		local x,y,z = table.unpack(fishing_location_data.menu_location)
		Utils.Target.createTargetInCoords(fishing_location_id,x,y,z,openFishingUiCallback,cached_translations.open_main_target,"fas fa-fish-fins","#2986cc")
	end

	-- Process the fishing properties ui target
	for property_id,property_location_data in pairs(Config.available_items_store.property) do
		local x,y,z = table.unpack(property_location_data.location)
		Utils.Target.createTargetInCoords(property_id,x,y,z,openPropertyUiCallback,cached_translations.open_property_target,"fas fa-warehouse","#2986cc")
	end

	-- Process the fishing stores ui target
	for fishing_store_id,fishing_store_data in pairs(Config.fish_stores) do
		local x,y,z = table.unpack(fishing_store_data.menu_location)
		Utils.Target.createTargetInCoords(fishing_store_id,x,y,z,openFishingStoreUiCallback,cached_translations.open_store_target,"fas fa-store","#2986cc")
	end
end

function openFishingUiCallback(fishing_location_id)
	current_fishing_location_id = fishing_location_id
	-- TriggerServerEvent("stevid_ikanv2:getData",current_fishing_location_id)
	-- ExecuteCommand('opn2')
	TriggerEvent('stevid_ikanv2:bukaDashboard')
end

function openPropertyUiCallback(property_location_id)
	-- TriggerServerEvent("stevid_ikanv2:getDataProperty",property_location_id)
	TriggerEvent('stevid_ikanv2:openProperty', property_location_id)
end

function openFishingStoreUiCallback(fishing_store_id)
	current_fishing_location_id = fishing_store_id
	-- TriggerServerEvent("stevid_ikanv2:getDataStore",fishing_store_id)
	-- ExecuteCommand('str')
	TriggerEvent('stevid_ikanv2:bukaPenjualan')
end


-- RegisterCommand('opn2', function (source, args, raw)
-- 	local cfg = Utils.Table.deepCopy(Config)
-- 	cfg.contracts = Config.available_contracts['definitions']
-- 	cfg.dives = Config.available_dives['definitions']
-- 	local kontrak = lib.callback.await('stevid_ikanv2:getAvailableContracts')
-- 	local dives = lib.callback.await('stevid_ikanv2:getAvailableDives')

-- 	local playerinv = lib.callback.await('stevid_ikanv2:getIkanSaya')
-- 	local user = lib.callback.await('stevid_ikanv2:getUserData')
-- 	local pinv = {}
-- 	cfg.player_level = user.player_level
-- 	cfg.max_loan = user.max_loan
-- 	for k,v in pairs(playerinv) do
-- 		pinv[#pinv+1] = {
-- 			name = k,
-- 			amount = v
-- 		}
-- 	end
-- 	local properties = {
-- 		{
-- 			stock = {}
-- 		}
-- 	}
-- 	for k,v in pairs(Config.fishes_available) do
-- 		properties[1].stock[k] = 0
-- 	end
-- 	TriggerEvent('stevid_ikanv2:open', {
-- 		fishing_simulator_users = user,
-- 		player_inventory = pinv,
-- 		config = cfg,
-- 		fishing_simulator_fishes_caught = {},
-- 		fishing_simulator_loans = {},
-- 		fishing_simulator_available_contracts = kontrak,
-- 		fishing_simulator_available_dives = dives,
-- 		fishing_simulator_vehicles = {},
-- 		fishing_simulator_properties = properties,
-- 		top_users = {}
-- 	}, false)
-- 	SetTimeout(2000, function ()
-- 		SetNuiFocus(true,true)
-- 	end)
-- end)

RegisterNetEvent('stevid_ikanv2:bukaDashboard', function (update)
	local cfg = Utils.Table.deepCopy(Config)
	cfg.contracts = Config.available_contracts['definitions']
	cfg.dives = Config.available_dives['definitions']
	local kontrak = lib.callback.await('stevid_ikanv2:getAvailableContracts')
	local dives = lib.callback.await('stevid_ikanv2:getAvailableDives')

	local playerinv = lib.callback.await('stevid_ikanv2:getIkanSaya')
	local user = lib.callback.await('stevid_ikanv2:getUserData')
	local userfish = lib.callback.await('stevid_ikanv2:getUserFishes')
	local theme = lib.callback.await('stevid_ikanv2:getTheme')
	local vehicles = lib.callback.await('stevid_ikanv2:getVehicleData')
	local top = lib.callback.await('stevid_ikanv2:getTopUser', 500)
	local turney = lib.callback.await('stevid_ikanv2:getNextTourney')
	if turney then
		turney.joined = lib.table.contains(turney.participants, user.user_id)
	end
	local pinv = {}
	cfg.player_level = user.player_level
	cfg.max_loan = user.max_loan
	for k,v in pairs(playerinv) do
		pinv[#pinv+1] = {
			name = k,
			amount = v
		}
	end
	-- local properties = {
	-- 	{
	-- 		stock = {}
	-- 	}
	-- }
	-- for k,v in pairs(Config.fishes_available) do
	-- 	properties[1].stock[k] = 0
	-- end
	local properties = lib.callback.await('stevid_ikanv2:getPropertyData')
	local prp = {}
	for k,v in pairs(properties) do
		prp[#prp+1] = v
	end
	-- local allProperties = {}
	-- for k,v in pairs(properties) do
	-- 	local idP = #allProperties+1
	-- 	allProperties[idP] = {
	-- 		stock = {},
	-- 		property = k,
	-- 		property_condition = 100,
	-- 		stock_weight = 0
	-- 	}
	-- 	for a,b in pairs(v) do
	-- 		allProperties[idP].stock[b.id] = b.value
	-- 		allProperties[idP].stock_weight += (b.value * Config.fishes_available[b.id].weight)
	-- 		-- v.stock[b.id] = b.value
	-- 	end
	-- end
	user.dark_theme = theme
	local max_garage_slots = Config.max_garage_slots + (Config.upgrades['vehicles']?[user.vehicles_upgrade]?.level_reward or 0) +  (Config.upgrades['boats']?[user.boats_upgrade]?.level_reward or 0)
	TriggerEvent('stevid_ikanv2:open', {
		fishing_simulator_users = user,
		player_inventory = pinv,
		config = cfg,
		fishing_simulator_fishes_caught = userfish,
		fishing_simulator_loans = {},
		fishing_simulator_available_contracts = kontrak,
		fishing_simulator_available_dives = dives,
		fishing_simulator_vehicles = vehicles,
		max_garage_slots = max_garage_slots,
		fishing_simulator_properties = prp,
		available_money = exports.ox_inventory:Search('count', 'money'),
		top_users = top or {},
		next_tournament = turney
		-- next_tournament = {
		-- 	joined = true,
		-- 	prizes = Config.fishing_tournaments["prizes"][1],
		-- 	isToday = true,
		-- }
	}, update)
	-- SetTimeout(2000, function ()
	-- 	if main_ui_open then
	-- 		SetNuiFocus(true,true)
	-- 	end
	-- end)
end)

local function getFishAvailable()
	local fishes_available = Config.fishes_available
	if Config.fish_prices['enable'] then
		if not fishAvailable then
			fishAvailable = lib.callback.await('stevid_ikanv2:fishAvailable')
		end
		fishes_available = lib.table.deepclone(fishAvailable)
	end
	return fishes_available
end

RegisterNetEvent('stevid_ikanv2:bukaPenjualan', function (lokasi)
	local IkanSaya = lib.callback.await('stevid_ikanv2:getIkanSaya')
	local user = lib.callback.await('stevid_ikanv2:getUserData')
	local fishes_available = getFishAvailable()
	-- Wait(1000)
	TriggerScreenblurFadeIn(1000)
	main_ui_open = true
	-- print('current_fishing_location_id',current_fishing_location_id or lokasi)
	SendNUIMessage({
		openFishStoreUI = true,
		data = {
			fishing_simulator_users = user,
			store_data = Config.fish_stores[current_fishing_location_id or lokasi],
			fishes_available = fishes_available,
			items_in_inventory = IkanSaya,
			player_level = user.player_level,
			available_money = user.money,
		},
		utils = { config = Utils.Config, lang = Utils.Lang },
		resourceName = GetCurrentResourceName()
	})
	-- Wait(2000)
	-- if not update then
	-- 	if main_ui_open then
	-- 		SetNuiFocus(true,true)
	-- 	end
	-- end
end)

RegisterNetEvent('stevid_ikanv2:open')
AddEventHandler('stevid_ikanv2:open', function(data,isUpdate)
	data.config.available_items_store = Utils.Table.deepCopy(Config.available_items_store)

	TriggerScreenblurFadeIn(1000)
	main_ui_open = true
	SendNUIMessage({
		openOwnerUI = true,
		isUpdate = isUpdate,
		data = data,
		utils = { config = Utils.Config, lang = Utils.Lang },
		resourceName = GetCurrentResourceName()
	})
	if not main_ui_open then
		SetNuiFocus(false,false)
	end
	-- if isUpdate == false then
	-- 	main_ui_open = true
	-- 	SetNuiFocus(true,true)
	-- end
end)

RegisterNetEvent('stevid_ikanv2:openProperty')
AddEventHandler('stevid_ikanv2:openProperty', function(property)
	local cekProperty = lib.callback.await('stevid_ikanv2:cekPropertyOwned', false, property)
	if not cekProperty then exports['stevid_utils']:notify("error", 'Properti ini belum dimiliki!') return end
	local user = lib.callback.await('stevid_ikanv2:getUserData')
	local IkanSaya = lib.callback.await('stevid_ikanv2:getIkanSaya')
	local PropertyData = lib.callback.await('stevid_ikanv2:getPropertyData', false, property)
	local fishes_available = getFishAvailable()
	Wait(1000)
	TriggerScreenblurFadeIn(1000)
	main_ui_open = true
	-- local data = Config.fishes_available['alligator_gar']
	-- data.id = 'alligator_gar'
	local ikan = {}
	for k,v in pairs(IkanSaya) do
		if fishes_available[k] then
			ikan[#ikan+1] = {
				name = k,
				amount = v,
				label = fishes_available[k].name
			}
		end
	end

	PropertyData.stock = sortir(PropertyData.stock)

	user.dark_theme = lib.callback.await('stevid_ikanv2:getTheme')
	SendNUIMessage({
		openPropertyUI = true,
		property = {
			property = property,
			stock =  PropertyData.stock,
			stock_weight = PropertyData.stock_weight,
			name = Config.available_items_store['property'][property]['name']
		},
		data = {
			fishing_simulator_users = user,
			config = {
				player_level = user.player_level,
				available_items_store = Utils.Table.deepCopy(Config.available_items_store),
				fishes_available = Config.fishes_available,
			},
			player_inventory = ikan
		},
		utils = { config = Utils.Config, lang = Utils.Lang },
		resourceName = GetCurrentResourceName()
	})
	main_ui_open = true
	-- SetNuiFocus(true,true)
end)

-- RegisterCommand('prp1', function (source, args, raw)
-- 	TriggerEvent('stevid_ikanv2:openProperty', 'sandy_shores_warehouse')
-- end)

-- RegisterCommand('str', function (source, args, raw)

-- end)

RegisterNetEvent('stevid_ikanv2:openStore')
AddEventHandler('stevid_ikanv2:openStore', function(data)
	TriggerScreenblurFadeIn(1000)
	main_ui_open = true
	SendNUIMessage({
		openFishStoreUI = true,
		data = data,
		utils = { config = Utils.Config, lang = Utils.Lang },
		resourceName = GetCurrentResourceName()
	})
	
	-- SetNuiFocus(true,true)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------

local cooldown = nil
local klikClose = false
RegisterNUICallback('post', function(body, cb)
	if cooldown == nil then
		cooldown = true
		-- print(body.event)

		if body.event == "close" then
			main_ui_open = false
			klikClose = true
			closeUI()
		elseif body.event == "closeFishingUI" then
			closeFishingUI()
		elseif body.event == "focusFishingUI" then
			if not klikClose then
				SetNuiFocusKeepInput(false)
				SetNuiFocus(true, true)
			else
				closeUI()
				SetTimeout(2000, function ()
					klikClose = false
				end)
			end
		elseif body.event == 'forceFishingUI' then
			SetNuiFocusKeepInput(false)
			SetNuiFocus(true, true)
		elseif body.event == "endFishingGame" then
			TriggerEvent("stevid_ikanv2:endFishingGame", body.data)
		else
			TriggerServerEvent('stevid_ikanv2:'..body.event,current_fishing_location_id,body.data)
			-- print('stevid_ikanv2:'..body.event,current_fishing_location_id,body.data)
		end
		cb(200)

		SetTimeout(5,function()
			cooldown = nil
		end)
	end
end)



RegisterNUICallback('close', function(data, cb)
	closeUI()
	cb(200)
end)

RegisterNetEvent('stevid_ikanv2:closeUI')
AddEventHandler('stevid_ikanv2:closeUI', function()
	closeUI()
end)

function closeUI()
	current_fishing_location_id = nil
	main_ui_open = false
	SetNuiFocus(false,false)
	SendNUIMessage({ hidemenu = true })
	TriggerScreenblurFadeOut(1000)
	TriggerServerEvent('stevid_ikanv2:closeUI')
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------

local route_blip
RegisterNetEvent('stevid_ikanv2:startContract')
AddEventHandler('stevid_ikanv2:startContract', function(contract_data)
	-- closeUI()


	-- contract_data.delivery_location = 
	local x,y,z = contract_data.lokasi.x, contract_data.lokasi.y, contract_data.lokasi.z

	route_blip = Utils.Blips.createBlipForCoords(x,y,z,1,5,Utils.translate('contract_destination_blip'),1.0,true)

	local timer
	while DoesBlipExist(route_blip) do
		timer = 3000
		local distance = #(GetEntityCoords(PlayerPedId()) - vector3(x,y,z))
		if distance <= 20.0 then
			timer = 2
			Utils.Markers.drawMarker(21,x,y,z,0.5)
			if distance <= 2.0 then
				Utils.Markers.drawText3D(x,y,z-0.6,Utils.translate('contract_finish_delivery'))
				if IsControlJustPressed(0,38) then
					TriggerServerEvent("stevid_ikanv2:finishContract")
				end
			end
		end
		Citizen.Wait(timer)
	end
end)

RegisterNetEvent('stevid_ikanv2:cancelContract')
AddEventHandler('stevid_ikanv2:cancelContract', function()
	Utils.Blips.removeBlip(route_blip)
end)

RegisterNetEvent('stevid_ikanv2:viewLocation')
AddEventHandler('stevid_ikanv2:viewLocation', function(location)
	-- closeUI()
	SetNewWaypoint(location[1],location[2])
end)

local swinSuit = {
	mask = 0,
	tank = 0,
}

RegisterNetEvent('stevid_ikanv2:toggleswimsuit')
AddEventHandler('stevid_ikanv2:toggleswimsuit', function()
	if swinSuit.mask ~= 0 and swinSuit.tank ~= 0 then
		deleteSwinSuit()
	else
		local maskModel = GetHashKey("p_d_scuba_mask_s")
		local tankModel = GetHashKey("p_s_scuba_tank_s")
		local ped = PlayerPedId()

		Utils.Entity.loadModel(tankModel)
		local tankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, true, true, false)
		local bone1 = GetPedBoneIndex(ped, 24818)
		AttachEntityToEntity(tankObject, ped, bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, true, true, false, false, 2, true)
		swinSuit.tank = tankObject

		Utils.Entity.loadModel(maskModel)
		local maskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, true, true, false)
		local bone2 = GetPedBoneIndex(ped, 12844)
		AttachEntityToEntity(maskObject, ped, bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, true, true, false, false, 2, true)
		swinSuit.mask = maskObject

		SetEnableScuba(ped, true)
		SetPedDiesInWater(PlayerPedId(), false)
		ClearPedTasks(ped)
	end
end)

function deleteSwinSuit()
	if swinSuit.mask ~= 0 then
		DetachEntity(swinSuit.mask, false, true)
		DeleteEntity(swinSuit.mask)
		swinSuit.mask = 0
	end
	if swinSuit.tank ~= 0 then
		DetachEntity(swinSuit.tank, false, true)
		DeleteEntity(swinSuit.tank)
		swinSuit.tank = 0
	end
	SetEnableScuba(PlayerPedId(), false)
	SetPedDiesInWater(PlayerPedId(), true)
end

local dive_area_blip
local chest
local isPlayerInDive = false
RegisterNetEvent('stevid_ikanv2:startDive')
AddEventHandler('stevid_ikanv2:startDive', function(dive_data)
	-- closeUI()
	isPlayerInDive = true 
	-- dive_data.dive_location = json.decode(dive_data.dive_location)
	-- local x,y,z = table.unpack(dive_data.dive_location)
	local x,y,z = dive_data.lokasi.x, dive_data.lokasi.y, dive_data.lokasi.z
	x = x + 0.001
	y = y + 0.001
	z = z + 1.001
	local radius = 90.0
	local randomX, randomY = randomPositionWithinCircle(x, y, radius)
	dive_area_blip = Utils.Blips.createBlipForArea(randomX, randomY, z, radius + 10.0, 3, 128, true)

	local timer
	while isPlayerInDive do
		timer = 3000
		local playerCoords = GetEntityCoords(PlayerPedId())
		local distance = #(playerCoords - vector3(x, y, z))
		if distance < 80.0 and not chest then
			local success, groundZ = GetGroundZExcludingObjectsFor_3dCoord(x, y, z, false)
			if success then
				z = groundZ
			else
				print("No ground found.")
			end
			chest = CreateObject(Config.chest_model, x, y, z, false, false, false)
			PlaceObjectOnGroundProperly_2(chest)
		elseif distance >= 120.0 and chest then
			DeleteObject(chest)
			chest = nil
		end

		if distance <= 50.0 then
			timer = 2
			Utils.Markers.drawMarker(21, x, y, z + 2.2, 1.2, 12, 120, 200, 90)
			if distance <= 3.0 then
				Utils.Markers.drawText3D(x, y, z + 1.2, Utils.translate('dive_finish'))
				if IsControlJustPressed(0, 38) then
					TriggerServerEvent("stevid_ikanv2:finishDive")
				end
			end
		end
		Citizen.Wait(timer)
	end
end)

function randomPositionWithinCircle(centerX, centerY, radius)
	local angle = math.random() * 2 * math.pi
	local distance = math.sqrt(math.random()) * radius
	local x = centerX + distance * math.cos(angle)
	local y = centerY + distance * math.sin(angle)
	return x, y
end

RegisterNetEvent('stevid_ikanv2:cancelDive')
AddEventHandler('stevid_ikanv2:cancelDive', function()
	isPlayerInDive = false
	Utils.Blips.removeBlip(dive_area_blip)
	if chest then
		DeleteObject(chest)
		chest = nil
	end
end)

local vehicle,vehicle_blip
local update_vehicle_status = 0
RegisterNetEvent('stevid_ikanv2:spawnVehicle')
AddEventHandler('stevid_ikanv2:spawnVehicle', function(vehicle_data,garage_to_spawn,teleport_location,blip_config)
	if IsEntityAVehicle(vehicle) then
		exports['sstore_utils']:notify("error",Utils.translate('vehicle_already_spawned'))
		return
	end

	closeUI()

	local i = #garage_to_spawn
	local x,y,z,h
	while i > 0 do
		x,y,z,h = table.unpack(garage_to_spawn[i])
		if not Utils.Vehicles.isSpawnPointClear({['x']=x,['y']=y,['z']=z},5.001) then
			if i <= 1 then
				exports['sstore_utils']:notify("error",Utils.translate('occupied_places'))
				return
			end
		else
			break
		end
		i = i - 1
	end

	vehicle_data.properties = vehicle_data.properties or {}
	vehicle_data.properties.plate = vehicle_data.properties.plate or Utils.Vehicles.generateTempVehiclePlateWithPrefix(GetCurrentResourceName())
	vehicle_data.properties.bodyHealth = vehicle_data.health
	vehicle_data.properties.engineHealth = vehicle_data.health
	vehicle_data.properties.fuelLevel = vehicle_data.fuel
	local blip_data = { name = Utils.translate('vehicle_blip'), sprite = blip_config.sprite, color = blip_config.color }
	vehicle,vehicle_blip = Utils.Vehicles.spawnVehicle(vehicle_data.vehicle,x,y,z,h,blip_data,vehicle_data.properties)
	exports['sstore_utils']:notify("success",Utils.translate('vehicle_spawned'))

	local timer = 2
	local engine_health = GetVehicleEngineHealth(vehicle)
	local vehicle_fuel = GetVehicleFuelLevel(vehicle)
	local body_health = GetVehicleBodyHealth(vehicle)

	local is_frozen = false
	if GetVehicleType(vehicle) == "boat" or GetVehicleType(vehicle) == "submarine" then
		SetTimeout(2000,function()
			FreezeEntityPosition(vehicle,true)
			is_frozen = true
		end)
		SetTimeout(20000,function()
			FreezeEntityPosition(vehicle,false)
			is_frozen = false
		end)
	end
	TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
	while IsEntityAVehicle(vehicle) do
		timer = 2000
		local coords = GetEntityCoords(vehicle)
		local ped = PlayerPedId()
		if oldpos ~= nil then
			if is_frozen and #(coords - GetEntityCoords(ped)) < 10 then
				FreezeEntityPosition(vehicle,false)
				is_frozen = false
			end
			local dist = #(coords - oldpos)
			vehicle_data.traveled_distance = vehicle_data.traveled_distance + dist
			veh = GetVehiclePedIsIn(ped,false)
			if veh == vehicle then
				for k,mark in pairs(garage_to_spawn) do
					local x,y,z = table.unpack(mark)
					local distance = #(GetEntityCoords(PlayerPedId()) - vector3(x,y,z))
					if distance <= 20.0 then
						timer = 2
						Utils.Markers.drawMarker(36,x,y,z,1.0)
						if distance <= 2.0 then
							Utils.Markers.drawText2D(Utils.translate('press_e_to_store_vehicle'), 8,0.5,0.95,0.50,255,255,255,180)
							if IsControlJustPressed(0,38) and IsEntityAVehicle(vehicle) then
								DoScreenFadeOut(500)
								Wait(500)
								TriggerServerEvent("stevid_ikanv2:updateVehicleStatus",vehicle_data,GetVehicleEngineHealth(vehicle),GetVehicleBodyHealth(vehicle),GetVehicleFuelLevel(vehicle),Utils.Vehicles.getVehicleProperties(vehicle))
								Utils.Vehicles.deleteVehicle(vehicle)
								Utils.Blips.removeBlip(vehicle_blip)
								if teleport_location then
									SetEntityCoords(ped,teleport_location[1],teleport_location[2],teleport_location[3],true,false,false,true)
								end
								Wait(500)
								DoScreenFadeIn(500)
								return
							end
						end
					end
				end
			end

			if IsEntityAVehicle(vehicle) and update_vehicle_status == 0 and (engine_health ~= GetVehicleEngineHealth(vehicle) or vehicle_fuel ~= GetVehicleFuelLevel(vehicle)) then
				update_vehicle_status = 3
				engine_health = GetVehicleEngineHealth(vehicle)
				body_health = GetVehicleBodyHealth(vehicle)
				vehicle_fuel = GetVehicleFuelLevel(vehicle)
				TriggerServerEvent("stevid_ikanv2:updateVehicleStatus",vehicle_data,engine_health,body_health,vehicle_fuel,Utils.Vehicles.getVehicleProperties(vehicle))
			end
		end

		local vehicles = { vehicle }
		local peds = { ped }
		local has_error, error_message = Utils.Entity.isThereSomethingWrongWithThoseBoys(vehicles,peds)
		if has_error then
			Utils.Framework.removeVehicleKeysFromPlate(vehicle_data.properties.plate, vehicle_data.vehicle)
			Utils.Blips.removeBlip(route_blip)
			Utils.Blips.removeBlip(vehicle_blip)
			PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", false)
			if Utils.Table.contains({'vehicle_almost_destroyed','vehicle_undriveable','ped_is_dead'}, error_message) then
				SetVehicleEngineHealth(vehicle,-4000)
				SetVehicleUndriveable(vehicle,true)
			end
			if error_message == 'ped_is_dead' then
				exports['sstore_utils']:notify("error",Utils.translate('you_died'))
			else
				exports['sstore_utils']:notify("error",Utils.translate('vehicle_destroyed'))
			end
			TriggerServerEvent("stevid_ikanv2:updateVehicleStatus",vehicle_data,engine_health,body_health,vehicle_fuel)
			return
		end

		oldpos = coords
		Citizen.Wait(timer)
	end
	Utils.Blips.removeBlip(vehicle_blip)
	exports['sstore_utils']:notify("error",Utils.translate('vehicle_lost'))
	TriggerServerEvent("stevid_ikanv2:updateVehicleStatus",vehicle_data,engine_health,body_health,vehicle_fuel)
end)

Citizen.CreateThread(function()
	while true do
		timer = 10000
		if update_vehicle_status > 0 then
			update_vehicle_status = update_vehicle_status - 1
		end
		Citizen.Wait(timer)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOURNAMENTS
-----------------------------------------------------------------------------------------------------------------------------------------

if Config.fishing_tournaments.enabled then
	RegisterCommand(Config.fishing_tournaments.command,function(source)
		-- Utils.Callback.TriggerServerCallback('fishing_simulator:getTournamentScoreboard', function(fishing_simulator_tournaments_users)
		-- 	if Utils.Table.tableLength(fishing_simulator_tournaments_users) > 0 then
		-- 		SendNUIMessage({
		-- 			openTournamentUI = true,
		-- 			fishing_simulator_tournaments_users = fishing_simulator_tournaments_users,
		-- 			utils = { config = Utils.Config, lang = Utils.Lang },
		-- 			resourceName = GetCurrentResourceName()
		-- 		})
		-- 		SetNuiFocus(true,true)
		-- 	end
		-- end)
		local turney = lib.callback.await('stevid_ikanv2:getNextTourney')
		if turney and turney.score then
			for k,v in pairs(turney.score) do
				v.catches = v.points
			end
			SendNUIMessage({
				openTournamentUI = true,
				fishing_simulator_tournaments_users = turney.score,
				utils = { config = Utils.Config, lang = Utils.Lang },
				resourceName = GetCurrentResourceName()
			})
		end
		
		-- Wait(2000)
		-- SetNuiFocus(true,true)
	end, false)
end

local tournament_blip_id = nil
local tournament_area_blip_id = nil
RegisterNetEvent('stevid_ikanv2:createTournamentBlip')
AddEventHandler('stevid_ikanv2:createTournamentBlip', function(location, set_waypoint)
	if tournament_blip_id and DoesBlipExist(tournament_blip_id) then
		Utils.Blips.removeBlip(tournament_blip_id)
		tournament_blip_id = nil
	end
	if tournament_area_blip_id and DoesBlipExist(tournament_area_blip_id) then
		Utils.Blips.removeBlip(tournament_area_blip_id)
		tournament_area_blip_id = nil
	end

	tournament_blip_id = Utils.Blips.createBlipForCoords(location[1],location[2],location[3],Config.fishing_tournaments.blip.id,Config.fishing_tournaments.blip.color,Config.fishing_tournaments.blip.name,Config.fishing_tournaments.blip.scale,false)
	tournament_area_blip_id = Utils.Blips.createBlipForArea(location[1],location[2],location[3],Config.fishing_tournaments.radius + 0.0,Config.fishing_tournaments.blip.color,128,true)
end)

RegisterNetEvent('stevid_ikanv2:removeTournamentBlip')
AddEventHandler('stevid_ikanv2:removeTournamentBlip', function()
	Utils.Blips.removeBlip(tournament_blip_id)
	Utils.Blips.removeBlip(tournament_area_blip_id)
	tournament_blip_id = nil
	tournament_area_blip_id = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- OTHERS
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	for _,fishing_location_data in pairs(Config.fishing_locations) do
		local x,y,z = table.unpack(fishing_location_data.menu_location)
		local blips = fishing_location_data.blips
		if blips then
			Utils.Blips.createBlipForCoords(x,y,z,blips.id,blips.color,blips.name,blips.scale,false)
		end
	end

	for _,store_data in pairs(Config.fish_stores) do
		local x,y,z = table.unpack(store_data.menu_location)
		local blips = store_data.blips
		if blips then
			Utils.Blips.createBlipForCoords(x,y,z,blips.id,blips.color,blips.name,blips.scale,false)
		end
	end
end)

RegisterNetEvent('stevid_ikanv2:Notify')
AddEventHandler('stevid_ikanv2:Notify', function(type,message)
	exports['sstore_utils']:notify(type,message)
end)

Citizen.CreateThread(function()
	Wait(1000)
	SetNuiFocus(false,false)
	SetNuiFocusKeepInput(false)

	Utils.loadLanguageFile(Lang)

	cached_translations = {
		open = Utils.translate('open'),
		open_main_target = Utils.translate('open_main_target'),
		open_property_target = Utils.translate('open_property_target'),
		open_store_target = Utils.translate('open_store_target'),
	}

	if Utils.Config.custom_scripts_compatibility.target == "disabled" then
		createMarkersThread()
	else
		createTargetsThread()
	end

	if Config.anchor_boat.enable then
		RegisterKeyMapping(Config.anchor_boat.command, Utils.translate('anchor_boat_command'), "keyboard", Config.anchor_boat.shortcut)
	end

	for _, property_data in pairs(Config.available_items_store.property) do
		property_data.address = GetStreetNameFromHashKey(GetStreetNameAtCoord(property_data.location[1],property_data.location[2],property_data.location[3]))
	end

	-- Translate the contracts texts
	for _, contract in pairs(Config.available_contracts.contracts) do
		contract.name = Utils.translate(contract.name)
		contract.description = Utils.translate(contract.description)
		for _, item_data in pairs(contract.required_items) do
			if item_data.name then
				local fish_data = Config.fishes_available[item_data.name]
				if fish_data then
					item_data.display_name = item_data.display_name or fish_data.name
				else
					item_data.display_name = item_data.display_name or item_data.name
				end
			end
		end
	end

	for _, dive in pairs(Config.available_dives.dives) do
		dive.name = Utils.translate(dive.name)
		dive.description = Utils.translate(dive.description)
	end

	if Config.fish_prices.enable then
		for _, fish_data in pairs(Config.fishes_available) do
			local rarity_price = Config.fish_prices.prices[fish_data.rarity]
			if rarity_price then
				fish_data.sale_value = math.random(rarity_price.min, rarity_price.max)
			end
		end
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() ~= resourceName then return end
	if chest then
		DeleteObject(chest)
	end
	stopAnimAndClearItems() -- Do not put anything after this
end)

Citizen.CreateThread(function() while true do Citizen.Wait(30000) collectgarbage() end end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ANCHOR BOAT
-----------------------------------------------------------------------------------------------------------------------------------------	

if Config.anchor_boat.enable then
	RegisterCommand(Config.anchor_boat.command,function(source)
		local ped = PlayerPedId()
		if IsPedInAnyBoat(ped) then
			local boat = GetVehiclePedIsIn(ped, false)
			if GetPedInVehicleSeat(boat, -1) == ped then
				if GetEntitySpeed(ped) <= 3 then -- KM/H
					toggleBoatAnchor(boat)
				else
					exports['sstore_utils']:notify("error",Utils.translate('anchor_too_fast'))
				end
			end
		end
	end, false)
end

function toggleBoatAnchor(boat)
	if IsBoatAnchoredAndFrozen(boat) then
		SetBoatAnchor(boat, false)
		SetBoatFrozenWhenAnchored(boat, false)
		SetForcedBoatLocationWhenAnchored(boat, false)
		exports['sstore_utils']:notify("success",Utils.translate('anchor_raised'))
	else
		if CanAnchorBoatHere(boat) then
			SetBoatAnchor(boat, true)
			SetBoatFrozenWhenAnchored(boat, true)
			SetForcedBoatLocationWhenAnchored(boat, true)
			exports['sstore_utils']:notify("success",Utils.translate('anchor_lowered'))
		else
			exports['sstore_utils']:notify("error",Utils.translate('anchor_not_allowed'))
		end
	end
end
exports('getPlayerLevel', function ()
	local user = lib.callback.await('stevid_ikanv2:getUserData')
	return user.player_level
end)