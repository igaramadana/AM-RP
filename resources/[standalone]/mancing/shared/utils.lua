-- Utils = {}
-- Utils.Debug = {}
-- Utils.Table = {}
-- Utils.Math = {}
-- Utils.String = {}
-- Utils.CustomScripts = {}

-- Utils.Lang = {}

-- Utils.Animations = {}

-- function Utils.Animations.stopPlayerAnim(upper)
-- 	if upper then
-- 		ClearPedSecondaryTask(PlayerPedId())
-- 	else
-- 		ClearPedTasks(PlayerPedId())
-- 	end
-- end

-- function Utils.Animations.loadAnimDict(dict)
-- 	RequestAnimDict(dict)
-- 	while not HasAnimDictLoaded(dict) do
-- 		Citizen.Wait(5)
-- 	end
-- end

-- Utils.Blips = {}

-- CreateThread(function()
--     if lib.context == 'client' then
--         SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
--     end
-- end)

-- function Utils.Blips.createBlipForCoords(x,y,z,idtype,idcolor,text,scale,set_route)
-- 	if idtype ~= 0 then
-- 		local blip = AddBlipForCoord(x,y,z)
-- 		SetBlipSprite(blip,idtype)
-- 		SetBlipAsShortRange(blip,true)
-- 		SetBlipColour(blip,idcolor)
-- 		SetBlipScale(blip,scale)

-- 		if text then
-- 			BeginTextCommandSetBlipName("STRING")
-- 			AddTextComponentSubstringPlayerName(text)
-- 			EndTextCommandSetBlipName(blip)
-- 		end

-- 		if set_route then
-- 			SetBlipRoute(blip, true)
-- 		end
-- 		return blip
-- 	end
-- end

-- function Utils.Blips.createBlipForArea(x,y,z,radius,idcolor,alpha,set_route)
-- 	local areaBlip = AddBlipForRadius(x, y, z, radius)
-- 	SetBlipHighDetail(areaBlip, true)
-- 	SetBlipColour(areaBlip, idcolor)
-- 	SetBlipAlpha(areaBlip, alpha)
-- 	SetNewWaypoint(x, y)

-- 	if set_route then
-- 		SetBlipRoute(areaBlip, true)
-- 	end

-- 	return areaBlip
-- end

-- function Utils.Blips.removeBlip(blip_id)
-- 	RemoveBlip(blip_id)
-- end

-- function Utils.Blips.createBlipForEntity(entity,blip_name,blip_id,blip_color)
-- 	local blip = AddBlipForEntity(entity)
-- 	SetBlipSprite(blip,blip_id)
-- 	SetBlipColour(blip,blip_color)
-- 	SetBlipAsShortRange(blip,false)
-- 	BeginTextCommandSetBlipName("STRING")
-- 	AddTextComponentSubstringPlayerName(blip_name)
-- 	EndTextCommandSetBlipName(blip)
-- 	return blip
-- end

-- Utils.Entity = {}

-- function Utils.Entity.isPlayerNearCoords(x,y,z,max_distance)
-- 	local distance = #(GetEntityCoords(PlayerPedId()) - vector3(x,y,z))
-- 	if distance <= max_distance then
-- 		return true
-- 	end
-- 	return false
-- end

-- function Utils.Entity.isThereSomethingWrongWithThoseBoys(vehicles,peds)
-- 	for _, vehicle in pairs(vehicles) do
-- 		if not IsEntityAVehicle(vehicle) then
-- 			return true, 'vehicle_doesnt_exist'
-- 		end
-- 		if GetVehicleEngineHealth(vehicle) <= 150 or GetVehicleBodyHealth(vehicle) <= 150 then
-- 			return true, 'vehicle_almost_destroyed'
-- 		end
-- 		if not IsVehicleDriveable(vehicle,false) then
-- 			return true, 'vehicle_undriveable'
-- 		end
-- 	end
-- 	for _, ped in pairs(peds) do
-- 		if IsEntityDead(ped) then
-- 			return true, 'ped_is_dead'
-- 		end
-- 	end
-- 	return false
-- end

-- function Utils.Entity.loadModel(model)
-- 	if HasModelLoaded(model) then return end
-- 	RequestModel(model)
-- 	while not HasModelLoaded(model) do
-- 		Wait(1)
-- 	end
-- end

-- Utils.Markers = {}

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- Markers
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- function Utils.Markers.drawMarker(marker_type,x,y,z,scale,r,g,b,a)
-- 	scale = scale or 0.5
-- 	r = r or 255
-- 	g = g or 0
-- 	b = b or 0
-- 	a = a or 50
-- 	---@diagnostic disable-next-line: param-type-mismatch
-- 	DrawMarker(marker_type,x,y,z-0.6,0,0,0,0.0,0,0,scale,scale,scale,r,g,b,a,false, false, 0, true, false, false, false)
-- end

-- function Utils.Markers.drawText3D(x,y,z, text)
-- 	if Config.marker_style == 1 then
-- 		local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x,y,z)
-- 		local px,py,pz=table.unpack(GetFinalRenderedCamCoord())
-- 		local dist = #(vector3(px,py,pz) - vector3(x,y,z))

-- 		local fov = (1/GetGameplayCamFov())*100
-- 		local scale = fov*(1/dist)*2

-- 		if onScreen then
-- 			SetTextScale(0.0*scale, 0.35*scale)
-- 			SetTextFont(0)
-- 			SetTextProportional(true)
-- 			SetTextDropshadow(0, 0, 0, 0, 255)
-- 			SetTextEdge(2, 0, 0, 0, 150)
-- 			SetTextDropShadow()
-- 			SetTextOutline()
-- 			SetTextCentre(true)
-- 			BeginTextCommandDisplayText("STRING")
-- 			AddTextComponentSubstringPlayerName(text)
-- 			EndTextCommandDisplayText(_x,_y)
-- 		end
-- 	else
-- 		SetTextScale(0.35, 0.35)
-- 		SetTextFont(4)
-- 		SetTextProportional(true)
-- 		SetTextColour(255, 255, 255, 215)
-- 		BeginTextCommandDisplayText("STRING")
-- 		SetTextCentre(true)
-- 		AddTextComponentSubstringPlayerName(text)
-- 		SetDrawOrigin(x,y,z, 0)
-- 		EndTextCommandDisplayText(0.0, 0.0)
-- 		local factor = string.len(text) / 370
-- 		DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
-- 		ClearDrawOrigin()
-- 	end
-- end

-- function Utils.Markers.drawText2D(text,font,x,y,scale,r,g,b,a)
-- 	SetTextFont(font)
-- 	SetTextScale(scale,scale)
-- 	SetTextColour(r,g,b,a)
-- 	SetTextOutline()
-- 	SetTextCentre(true)
-- 	BeginTextCommandDisplayText("STRING")
-- 	AddTextComponentSubstringPlayerName(text)
-- 	EndTextCommandDisplayText(x,y)
-- end

-- function Utils.Markers.createMarkerInCoords(location_id,x,y,z,marker_text,onControlIsPressedCallback,callbackData,distance)
-- 	distance = distance or #(GetEntityCoords(PlayerPedId()) - vector3(x,y,z))
-- 	Utils.Markers.drawMarker(21,x,y,z)
-- 	if distance <= 1.0 then
-- 		Utils.Markers.drawText3D(x,y,z-0.6, marker_text)
-- 		if IsControlJustPressed(0,38) then
-- 			onControlIsPressedCallback(location_id,callbackData)
-- 		end
-- 	end
-- end

-- function Utils.Markers.showHelpNotification(msg, thisFrame, beep, duration)
-- 	AddTextEntry('lcutilsHelpNotification', msg)

-- 	if thisFrame then
-- 		DisplayHelpTextThisFrame('lcutilsHelpNotification', false)
-- 	else
-- 		if beep == nil then
-- 			beep = true
-- 		end
-- 		BeginTextCommandDisplayHelp('lcutilsHelpNotification')
-- 		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
-- 	end
-- end

-- function notify(type,message)
-- 	assert(type == "success" or type == "error" or type == "warning" or type == "info", ("Notification Type Mismatch: The accepted types include success, error, warning, and info. The received type is %s."):format(type))
-- 	if Config.custom_scripts_compatibility.notification == "okokNotify" then
-- 		exports['okokNotify']:Alert(Utils.String.capitalizeFirst(type), message, 8000, type, false)
-- 	elseif Config.custom_scripts_compatibility.notification == "qbcore" then
-- 		QBCore = exports['qb-core']:GetCoreObject()
-- 		QBCore.Functions.Notify(message, type, 8000)
-- 	elseif Config.custom_scripts_compatibility.notification == "ox_lib" then
-- 		exports.ox_lib:notify({
-- 			title = Utils.String.capitalizeFirst(type),
-- 			description = message,
-- 			type = type
-- 		})
-- 	elseif Config.custom_scripts_compatibility.notification == "default" then
-- 		local title = nil
-- 		if Config.notification.has_title then
-- 			title = Utils.translate("notification." .. type)
-- 		end
-- 		SendNUIMessage({
-- 			notification = message,
-- 			notification_type = type,
-- 			duration = Config.notification.duration,
-- 			position = Config.notification.position,
-- 			title = title
-- 		})
-- 	else
-- 		Utils.CustomScripts.notify(type,message)
-- 	end
-- end
-- exports("notify", notify)

-- function changeTheme(dark_theme)
-- 	SendNUIMessage({
-- 		dark_theme = dark_theme
-- 	})
-- end
-- exports("changeTheme", changeTheme)

-- Utils.Peds = {}

-- function Utils.Peds.spawnPedAtCoords(model, x, y, z, h, freeze, invincible, emote)
-- 	while not HasModelLoaded(model) do
-- 		Wait(10)
-- 		RequestModel(model)
-- 	end
-- 	local entity = CreatePed(4, model, x, y, z-1, h, false, false)
-- 	SetEntityHeading(entity, h)
-- 	SetEntityAsMissionEntity(entity, true, true)
-- 	if freeze then
-- 		FreezeEntityPosition(entity, true)
-- 		SetBlockingOfNonTemporaryEvents(entity, true)
-- 	end
-- 	if invincible then
-- 		SetEntityInvincible(entity, true)
-- 		SetEntityProofs(entity, true, true, true, true, true, true, true, true)
-- 	end
-- 	SetModelAsNoLongerNeeded(model)

-- 	if emote then
-- 		TaskStartScenarioInPlace(entity, emote, 0, true)
-- 	end
-- 	return entity
-- end

-- function Utils.Peds.deletePed(entity)
-- 	DeleteEntity(entity)
-- end

-- Utils.Scaleform = {}

-- function Utils.Scaleform.showScaleform(title, desc, sec)
-- 	Citizen.CreateThreadNow(function()
-- 		function Initialize(scaleform)
-- 			local scaleform = RequestScaleformMovieInstance(scaleform)

-- 			while not HasScaleformMovieLoaded(scaleform) do
-- 				Citizen.Wait(0)
-- 			end
-- 			BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
-- 			ScaleformMovieMethodAddParamTextureNameString(title)
-- 			ScaleformMovieMethodAddParamTextureNameString(desc)
-- 			EndScaleformMovieMethod()
-- 			return scaleform
-- 		end
-- 		scaleform = Initialize("mp_big_message_freemode")
-- 		while sec > 0 do
-- 			sec = sec - 0.02
-- 			Citizen.Wait(0)
-- 			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
-- 		end
-- 		SetScaleformMovieAsNoLongerNeeded(scaleform)
-- 	end)
-- end

-- Utils.Target = {}

-- function Utils.Target.createTargetInCoords(location_id,x,y,z,onSelectTargetOptionCallback,labelText,icon,iconColor,zone_id,callbackData)
-- 	if Config.custom_scripts_compatibility.target == 'ox_target' then
-- 		exports['ox_target']:addSphereZone({
-- 			coords = vector3(x,y,z),
-- 			radius = 2.0,
-- 			debug = false,
-- 			options = {
-- 				{
-- 					icon = icon,
-- 					iconColor = iconColor,
-- 					label = labelText,
-- 					distance = 2.5,
-- 					onSelect = function()
-- 						onSelectTargetOptionCallback(location_id,callbackData)
-- 					end,
-- 				}
-- 			}
-- 		})
-- 	elseif Config.custom_scripts_compatibility.target == 'qb-target' then
-- 		assert(Config.framework ~= "ESX", "qb-target not available for ESX")
-- 		local caller_resource = cache.resource
-- 		zone_id = caller_resource .. ":" .. (zone_id or location_id)
-- 		exports['qb-target']:AddBoxZone(zone_id, vector3(x,y,z), 2.5, 2.5, {
-- 			name = zone_id,
-- 			debugPoly = false,
-- 			heading = 0.0,
-- 			minZ = z - 2,
-- 			maxZ = z + 2,
-- 		}, {
-- 			options = {
-- 				{
-- 					action = function()
-- 						onSelectTargetOptionCallback(location_id,callbackData)
-- 					end,
-- 					icon = icon,
-- 					label = labelText
-- 				}
-- 			},
-- 			distance = 2.5
-- 		})
-- 	else
-- 		Utils.CustomScripts.createTargetInCoords(location_id,x,y,z,onSelectTargetOptionCallback,labelText,icon,iconColor,zone_id,callbackData)
-- 	end
-- end

-- Utils.Vehicles = {}
-- local generatedPlates = {}

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- SpawnVehicle functions
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- function Utils.Vehicles.spawnVehicle(model,x,y,z,h,blip_data,properties)
-- 	assert(Utils.Entity.isPlayerNearCoords(x,y,z,424.0),("^3Resource ^1%s^3 Tried to spawn vehicle on the client but the position is too far away (Out of onesync range).^7"):format(cache.resource))
-- 	assert(properties, "Vehicle properties are null")
-- 	assert(properties.plate, "Vehicle properties must have at least properties.plate")
-- 	properties.fuelLevel = properties.fuelLevel or 100.0
-- 	properties.engineHealth = properties.engineHealth or 1000.0
-- 	properties.bodyHealth = properties.bodyHealth or 1000.0

-- 	local model_hash = GetHashKey(model)
-- 	Utils.Entity.loadModel(model_hash)

-- 	local vehicle = CreateVehicle(model_hash,x,y,z+0.5,h,true,false)
-- 	local netid = NetworkGetNetworkIdFromEntity(vehicle)
-- 	SetVehicleHasBeenOwnedByPlayer(vehicle, true)
-- 	SetNetworkIdCanMigrate(netid, true)
-- 	SetVehicleNeedsToBeHotwired(vehicle, false)
-- 	SetVehRadioStation(vehicle, 'OFF')

-- 	Utils.Vehicles.setVehicleProperties(vehicle, properties)
-- 	Utils.Framework.setVehicleFuel(vehicle, properties.plate, model, properties.fuelLevel + 0.0)
-- 	Utils.Framework.giveVehicleKeys(vehicle, properties.plate, model)

-- 	SetModelAsNoLongerNeeded(model_hash)

-- 	local blip
-- 	if blip_data and blip_data.name then
-- 		blip = Utils.Blips.createBlipForEntity(vehicle,blip_data.name,blip_data.sprite,blip_data.color)
-- 	end

-- 	generatedPlates[properties.plate] = vehicle
-- 	return vehicle,blip
-- end

-- function Utils.Vehicles.deleteVehicle(vehicle)
-- 	local plate = removePlateInGeneratedPlatesFromVehicle(vehicle)
-- 	if IsEntityAVehicle(vehicle) then
-- 		Utils.Framework.removeVehicleKeys(vehicle)
-- 		SetEntityAsMissionEntity(vehicle, true, true)
-- 		DeleteVehicle(vehicle)
-- 	elseif plate then
-- 		Utils.Framework.removeVehicleKeysFromPlate(plate)
-- 	end
-- end

-- function removePlateInGeneratedPlatesFromVehicle(vehicle)
-- 	for k, v in pairs(generatedPlates) do
-- 		if v == vehicle then
-- 			generatedPlates[k] = nil
-- 			return k
-- 		end
-- 	end
-- end

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- Functions
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- function Utils.Vehicles.getPlate(vehicle)
-- 	if vehicle == 0 then return end
-- 	return Utils.Math.trim(GetVehicleNumberPlateText(vehicle))
-- end

-- function Utils.Vehicles.generateTempVehiclePlateWithPrefix(resource)
-- 	config_spawned_vehicles = Config.spawned_vehicles[resource]
-- 	if not config_spawned_vehicles then
-- 		print("^3WARNING: Missing config '^1Config.spawned_vehicles[" .. resource .. "]^3' in resource '^1stevid_utils^3'. The value will be set to its default. Consider redownloading the original config to obtain the correct config.^7")
-- 		Config.spawned_vehicles[resource] = {
-- 			['is_static'] = false,
-- 			['plate_prefix'] = "TEMP"
-- 		}
-- 		config_spawned_vehicles = Config.spawned_vehicles[resource]
-- 	end
-- 	if config_spawned_vehicles.is_static then
-- 		return config_spawned_vehicles.plate_prefix
-- 	else
-- 		return Utils.Vehicles.generateTempVehiclePlate(config_spawned_vehicles.plate_prefix)
-- 	end
-- end

-- function Utils.Vehicles.generateTempVehiclePlate(prefix)
-- 	assert(#prefix <= 7, "Plate prefix is too long: '" .. prefix .. "' (maximum 7 characters allowed)")

-- 	local remainingChars = 8 - #prefix
-- 	local maxAttempts = 1000

-- 	for _ = 1, maxAttempts do
-- 		local randomChars = ""
-- 		for i = 1, remainingChars do
-- 			local randomNumber = tostring(math.random(0, 9))
-- 			randomChars = randomChars .. randomNumber
-- 		end

-- 		local plate = prefix .. randomChars

-- 		if not generatedPlates[plate] then
-- 			generatedPlates[plate] = true
-- 			return plate
-- 		end
-- 	end

-- 	error("Failed to generate a unique plate for the prefix: '" ..prefix.. "'")
-- end

-- function Utils.Vehicles.removeKeysFromPlate(plate,model)
-- 	generatedPlates[plate] = nil
-- 	Utils.Framework.removeVehicleKeysFromPlate(plate,model)
-- end

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- VehicleProperties
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- function Utils.Vehicles.getVehicleProperties(vehicle)
-- 	if DoesEntityExist(vehicle) then
-- 		---@type number | number[], number | number[]
-- 		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
-- 		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

-- 		if GetIsVehiclePrimaryColourCustom(vehicle) then
-- 			colorPrimary = { GetVehicleCustomPrimaryColour(vehicle) }
-- 		end

-- 		if GetIsVehicleSecondaryColourCustom(vehicle) then
-- 			colorSecondary = { GetVehicleCustomSecondaryColour(vehicle) }
-- 		end

-- 		local extras = {}

-- 		for i = 1, 15 do
-- 			if DoesExtraExist(vehicle, i) then
-- 				extras[i] = IsVehicleExtraTurnedOn(vehicle, i) and 0 or 1
-- 			end
-- 		end

-- 		local modLiveryCount = GetVehicleLiveryCount(vehicle)
-- 		local modLivery = GetVehicleLivery(vehicle)

-- 		if modLiveryCount == -1 or modLivery == -1 then
-- 			modLivery = GetVehicleMod(vehicle, 48)
-- 		end

-- 		local damage = {
-- 			windows = {},
-- 			doors = {},
-- 			tyres = {},
-- 		}

-- 		local windows = 0

-- 		for i = 0, 7 do
-- 			RollUpWindow(vehicle, i)

-- 			if not IsVehicleWindowIntact(vehicle, i) then
-- 				windows += 1
-- 				damage.windows[windows] = i
-- 			end
-- 		end

-- 		local doors = 0

-- 		for i = 0, 5 do
-- 			if IsVehicleDoorDamaged(vehicle, i) then
-- 				doors += 1
-- 				damage.doors[doors] = i
-- 			end
-- 		end

-- 		for i = 0, 7 do
-- 			if IsVehicleTyreBurst(vehicle, i, false) then
-- 				damage.tyres[i] = IsVehicleTyreBurst(vehicle, i, true) and 2 or 1
-- 			end
-- 		end

-- 		local neons = {}

-- 		for i = 0, 3 do
-- 			neons[i + 1] = IsVehicleNeonLightEnabled(vehicle, i)
-- 		end

-- 		return {
-- 			model = GetEntityModel(vehicle),
-- 			plate = GetVehicleNumberPlateText(vehicle),
-- 			plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
-- 			bodyHealth = math.floor(GetVehicleBodyHealth(vehicle) + 0.5),
-- 			engineHealth = math.floor(GetVehicleEngineHealth(vehicle) + 0.5),
-- 			tankHealth = math.floor(GetVehiclePetrolTankHealth(vehicle) + 0.5),
-- 			fuelLevel = math.floor(GetVehicleFuelLevel(vehicle) + 0.5),
-- 			oilLevel = math.floor(GetVehicleOilLevel(vehicle) + 0.5),
-- 			dirtLevel = math.floor(GetVehicleDirtLevel(vehicle) + 0.5),
-- 			color1 = colorPrimary,
-- 			color2 = colorSecondary,
-- 			pearlescentColor = pearlescentColor,
-- 			interiorColor = GetVehicleInteriorColor(vehicle),
-- 			dashboardColor = GetVehicleDashboardColour(vehicle),
-- 			wheelColor = wheelColor,
-- 			wheelWidth = GetVehicleWheelWidth(vehicle),
-- 			wheelSize = GetVehicleWheelSize(vehicle),
-- 			wheels = GetVehicleWheelType(vehicle),
-- 			windowTint = GetVehicleWindowTint(vehicle),
-- 			xenonColor = GetVehicleXenonLightsColor(vehicle),
-- 			neonEnabled = neons,
-- 			neonColor = { GetVehicleNeonLightsColour(vehicle) },
-- 			extras = extras,
-- 			tyreSmokeColor = { GetVehicleTyreSmokeColor(vehicle) },
-- 			modSpoilers = GetVehicleMod(vehicle, 0),
-- 			modFrontBumper = GetVehicleMod(vehicle, 1),
-- 			modRearBumper = GetVehicleMod(vehicle, 2),
-- 			modSideSkirt = GetVehicleMod(vehicle, 3),
-- 			modExhaust = GetVehicleMod(vehicle, 4),
-- 			modFrame = GetVehicleMod(vehicle, 5),
-- 			modGrille = GetVehicleMod(vehicle, 6),
-- 			modHood = GetVehicleMod(vehicle, 7),
-- 			modFender = GetVehicleMod(vehicle, 8),
-- 			modRightFender = GetVehicleMod(vehicle, 9),
-- 			modRoof = GetVehicleMod(vehicle, 10),
-- 			modEngine = GetVehicleMod(vehicle, 11),
-- 			modBrakes = GetVehicleMod(vehicle, 12),
-- 			modTransmission = GetVehicleMod(vehicle, 13),
-- 			modHorns = GetVehicleMod(vehicle, 14),
-- 			modSuspension = GetVehicleMod(vehicle, 15),
-- 			modArmor = GetVehicleMod(vehicle, 16),
-- 			modNitrous = GetVehicleMod(vehicle, 17),
-- 			modTurbo = IsToggleModOn(vehicle, 18),
-- 			modSubwoofer = GetVehicleMod(vehicle, 19),
-- 			modSmokeEnabled = IsToggleModOn(vehicle, 20),
-- 			modHydraulics = IsToggleModOn(vehicle, 21),
-- 			modXenon = IsToggleModOn(vehicle, 22),
-- 			modFrontWheels = GetVehicleMod(vehicle, 23),
-- 			modBackWheels = GetVehicleMod(vehicle, 24),
-- 			modCustomTiresF = GetVehicleModVariation(vehicle, 23),
-- 			modCustomTiresR = GetVehicleModVariation(vehicle, 24),
-- 			modPlateHolder = GetVehicleMod(vehicle, 25),
-- 			modVanityPlate = GetVehicleMod(vehicle, 26),
-- 			modTrimA = GetVehicleMod(vehicle, 27),
-- 			modOrnaments = GetVehicleMod(vehicle, 28),
-- 			modDashboard = GetVehicleMod(vehicle, 29),
-- 			modDial = GetVehicleMod(vehicle, 30),
-- 			modDoorSpeaker = GetVehicleMod(vehicle, 31),
-- 			modSeats = GetVehicleMod(vehicle, 32),
-- 			modSteeringWheel = GetVehicleMod(vehicle, 33),
-- 			modShifterLeavers = GetVehicleMod(vehicle, 34),
-- 			modAPlate = GetVehicleMod(vehicle, 35),
-- 			modSpeakers = GetVehicleMod(vehicle, 36),
-- 			modTrunk = GetVehicleMod(vehicle, 37),
-- 			modHydrolic = GetVehicleMod(vehicle, 38),
-- 			modEngineBlock = GetVehicleMod(vehicle, 39),
-- 			modAirFilter = GetVehicleMod(vehicle, 40),
-- 			modStruts = GetVehicleMod(vehicle, 41),
-- 			modArchCover = GetVehicleMod(vehicle, 42),
-- 			modAerials = GetVehicleMod(vehicle, 43),
-- 			modTrimB = GetVehicleMod(vehicle, 44),
-- 			modTank = GetVehicleMod(vehicle, 45),
-- 			modWindows = GetVehicleMod(vehicle, 46),
-- 			modDoorR = GetVehicleMod(vehicle, 47),
-- 			modLivery = modLivery,
-- 			modRoofLivery = GetVehicleRoofLivery(vehicle),
-- 			modLightbar = GetVehicleMod(vehicle, 49),
-- 			windows = damage.windows,
-- 			doors = damage.doors,
-- 			tyres = damage.tyres,
-- 			bulletProofTyres = GetVehicleTyresCanBurst(vehicle),
-- 			driftTyres = GetDriftTyresEnabled(vehicle),
-- 		}
-- 	end
-- end

-- function Utils.Vehicles.setVehicleProperties(vehicle, props)
-- 	if not DoesEntityExist(vehicle) then error(("Unable to set vehicle properties for '%s' (entity does not exist)"):format(vehicle)) end

-- 	local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
-- 	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

-- 	SetVehicleModKit(vehicle, 0)
-- 	SetVehicleAutoRepairDisabled(vehicle, true)

-- 	SetVehicleNumberPlateText(vehicle, props.plate)

-- 	if props.plateIndex then
-- 		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
-- 	end

-- 	if props.bodyHealth then
-- 		SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
-- 	else
-- 		SetVehicleBodyHealth(vehicle, 1000.0)
-- 	end

-- 	if props.engineHealth then
-- 		SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
-- 	else
-- 		SetVehicleEngineHealth(vehicle, 1000.0)
-- 	end

-- 	if props.tankHealth then
-- 		SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0)
-- 	end

-- 	if props.fuelLevel then
-- 		SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
-- 	else
-- 		SetVehicleFuelLevel(vehicle, 100.0)
-- 	end

-- 	if props.oilLevel then
-- 		SetVehicleOilLevel(vehicle, props.oilLevel + 0.0)
-- 	end

-- 	if props.dirtLevel then
-- 		SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
-- 	end

-- 	if props.color1 then
-- 		if type(props.color1) == 'table' then
-- 			SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
-- 		else
-- 			ClearVehicleCustomPrimaryColour(vehicle)
-- 			SetVehicleColours(vehicle, tonumber(props.color1) --[[@as number]], tonumber(props.color2) or colorSecondary --[[@as number]])
-- 		end
-- 	end

-- 	if props.color2 then
-- 		if type(props.color2) == 'table' then
-- 			SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
-- 		else
-- 			ClearVehicleCustomPrimaryColour(vehicle)
-- 			SetVehicleColours(vehicle, tonumber(props.color1) or colorPrimary --[[@as number]], tonumber(props.color2) --[[@as number]])
-- 		end
-- 	end

-- 	if props.pearlescentColor or props.wheelColor then
-- 		SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor or wheelColor)
-- 	end

-- 	if props.interiorColor then
-- 		SetVehicleInteriorColor(vehicle, props.interiorColor)
-- 	end

-- 	if props.dashboardColor then
-- 		SetVehicleDashboardColor(vehicle, props.dashboardColor)
-- 	end

-- 	if props.wheels then
-- 		SetVehicleWheelType(vehicle, props.wheels)
-- 	end

-- 	if props.wheelSize then
-- 		SetVehicleWheelSize(vehicle, props.wheelSize)
-- 	end

-- 	if props.wheelWidth then
-- 		SetVehicleWheelWidth(vehicle, props.wheelWidth)
-- 	end

-- 	if props.windowTint then
-- 		SetVehicleWindowTint(vehicle, props.windowTint)
-- 	end

-- 	if props.neonEnabled then
-- 		for i = 1, #props.neonEnabled do
-- 			SetVehicleNeonLightEnabled(vehicle, i - 1, props.neonEnabled[i])
-- 		end
-- 	end

-- 	if props.extras then
-- 		for id, disable in pairs(props.extras) do
-- 			SetVehicleExtra(vehicle, tonumber(id) --[[@as number]], disable == 1)
-- 		end
-- 	end

-- 	if props.windows then
-- 		for i = 1, #props.windows do
-- 			RemoveVehicleWindow(vehicle, props.windows[i])
-- 		end
-- 	end

-- 	if props.doors then
-- 		for i = 1, #props.doors do
-- 			SetVehicleDoorBroken(vehicle, props.doors[i], true)
-- 		end
-- 	end

-- 	if props.tyres then
-- 		for tyre, state in pairs(props.tyres) do
-- 			SetVehicleTyreBurst(vehicle, tonumber(tyre) --[[@as number]], state == 2, 1000.0)
-- 		end
-- 	end

-- 	if props.neonColor then
-- 		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
-- 	end

-- 	if props.modSmokeEnabled ~= nil then
-- 		ToggleVehicleMod(vehicle, 20, props.modSmokeEnabled)
-- 	end

-- 	if props.tyreSmokeColor then
-- 		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
-- 	end

-- 	if props.modSpoilers then
-- 		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
-- 	end

-- 	if props.modFrontBumper then
-- 		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
-- 	end

-- 	if props.modRearBumper then
-- 		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
-- 	end

-- 	if props.modSideSkirt then
-- 		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
-- 	end

-- 	if props.modExhaust then
-- 		SetVehicleMod(vehicle, 4, props.modExhaust, false)
-- 	end

-- 	if props.modFrame then
-- 		SetVehicleMod(vehicle, 5, props.modFrame, false)
-- 	end

-- 	if props.modGrille then
-- 		SetVehicleMod(vehicle, 6, props.modGrille, false)
-- 	end

-- 	if props.modHood then
-- 		SetVehicleMod(vehicle, 7, props.modHood, false)
-- 	end

-- 	if props.modFender then
-- 		SetVehicleMod(vehicle, 8, props.modFender, false)
-- 	end

-- 	if props.modRightFender then
-- 		SetVehicleMod(vehicle, 9, props.modRightFender, false)
-- 	end

-- 	if props.modRoof then
-- 		SetVehicleMod(vehicle, 10, props.modRoof, false)
-- 	end

-- 	if props.modEngine then
-- 		SetVehicleMod(vehicle, 11, props.modEngine, false)
-- 	end

-- 	if props.modBrakes then
-- 		SetVehicleMod(vehicle, 12, props.modBrakes, false)
-- 	end

-- 	if props.modTransmission then
-- 		SetVehicleMod(vehicle, 13, props.modTransmission, false)
-- 	end

-- 	if props.modHorns then
-- 		SetVehicleMod(vehicle, 14, props.modHorns, false)
-- 	end

-- 	if props.modSuspension then
-- 		SetVehicleMod(vehicle, 15, props.modSuspension, false)
-- 	end

-- 	if props.modArmor then
-- 		SetVehicleMod(vehicle, 16, props.modArmor, false)
-- 	end

-- 	if props.modNitrous then
-- 		SetVehicleMod(vehicle, 17, props.modNitrous, false)
-- 	end

-- 	if props.modTurbo ~= nil then
-- 		ToggleVehicleMod(vehicle, 18, props.modTurbo)
-- 	end

-- 	if props.modSubwoofer ~= nil then
-- 		ToggleVehicleMod(vehicle, 19, props.modSubwoofer)
-- 	end

-- 	if props.modHydraulics ~= nil then
-- 		ToggleVehicleMod(vehicle, 21, props.modHydraulics)
-- 	end

-- 	if props.modXenon ~= nil then
-- 		ToggleVehicleMod(vehicle, 22, props.modXenon)
-- 	end

-- 	if props.xenonColor then
-- 		SetVehicleXenonLightsColor(vehicle, props.xenonColor)
-- 	end

-- 	if props.modFrontWheels then
-- 		SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
-- 	end

-- 	if props.modBackWheels then
-- 		SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
-- 	end

-- 	if props.modPlateHolder then
-- 		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
-- 	end

-- 	if props.modVanityPlate then
-- 		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
-- 	end

-- 	if props.modTrimA then
-- 		SetVehicleMod(vehicle, 27, props.modTrimA, false)
-- 	end

-- 	if props.modOrnaments then
-- 		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
-- 	end

-- 	if props.modDashboard then
-- 		SetVehicleMod(vehicle, 29, props.modDashboard, false)
-- 	end

-- 	if props.modDial then
-- 		SetVehicleMod(vehicle, 30, props.modDial, false)
-- 	end

-- 	if props.modDoorSpeaker then
-- 		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
-- 	end

-- 	if props.modSeats then
-- 		SetVehicleMod(vehicle, 32, props.modSeats, false)
-- 	end

-- 	if props.modSteeringWheel then
-- 		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
-- 	end

-- 	if props.modShifterLeavers then
-- 		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
-- 	end

-- 	if props.modAPlate then
-- 		SetVehicleMod(vehicle, 35, props.modAPlate, false)
-- 	end

-- 	if props.modSpeakers then
-- 		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
-- 	end

-- 	if props.modTrunk then
-- 		SetVehicleMod(vehicle, 37, props.modTrunk, false)
-- 	end

-- 	if props.modHydrolic then
-- 		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
-- 	end

-- 	if props.modEngineBlock then
-- 		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
-- 	end

-- 	if props.modAirFilter then
-- 		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
-- 	end

-- 	if props.modStruts then
-- 		SetVehicleMod(vehicle, 41, props.modStruts, false)
-- 	end

-- 	if props.modArchCover then
-- 		SetVehicleMod(vehicle, 42, props.modArchCover, false)
-- 	end

-- 	if props.modAerials then
-- 		SetVehicleMod(vehicle, 43, props.modAerials, false)
-- 	end

-- 	if props.modTrimB then
-- 		SetVehicleMod(vehicle, 44, props.modTrimB, false)
-- 	end

-- 	if props.modTank then
-- 		SetVehicleMod(vehicle, 45, props.modTank, false)
-- 	end

-- 	if props.modWindows then
-- 		SetVehicleMod(vehicle, 46, props.modWindows, false)
-- 	end

-- 	if props.modDoorR then
-- 		SetVehicleMod(vehicle, 47, props.modDoorR, false)
-- 	end

-- 	if props.modLivery then
-- 		SetVehicleMod(vehicle, 48, props.modLivery, false)
-- 		SetVehicleLivery(vehicle, props.modLivery)
-- 	end

-- 	if props.modRoofLivery then
-- 		SetVehicleRoofLivery(vehicle, props.modRoofLivery)
-- 	end

-- 	if props.modLightbar then
-- 		SetVehicleMod(vehicle, 49, props.modLightbar, false)
-- 	end

-- 	if props.bulletProofTyres ~= nil then
-- 		SetVehicleTyresCanBurst(vehicle, props.bulletProofTyres)
-- 	end

-- 	if props.driftTyres then
-- 		-- SetDriftTyresEnabled(vehicle, true)
-- 	end

-- 	return true
-- end

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- isSpawnPointClear
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
-- 	local nearbyEntities = {}

-- 	if coords then
-- 		coords = vector3(coords.x, coords.y, coords.z)
-- 	else
-- 		local playerPed = PlayerPedId()
-- 		coords = GetEntityCoords(playerPed)
-- 	end

-- 	for k,entity in pairs(entities) do
-- 		local distance = #(coords - GetEntityCoords(entity))

-- 		if distance <= maxDistance then
-- 			table.insert(nearbyEntities, isPlayerEntities and k or entity)
-- 		end
-- 	end

-- 	return nearbyEntities
-- end

-- local entityEnumerator = {
-- 	__gc = function(enum)
-- 		if enum.destructor and enum.handle then
-- 			enum.destructor(enum.handle)
-- 		end

-- 		enum.destructor = nil
-- 		enum.handle = nil
-- 	end
-- }

-- function EnumerateEntities(initFunc, moveFunc, disposeFunc)
-- 	return coroutine.wrap(function()
-- 		local iter, id = initFunc()
-- 		if not id or id == 0 then
-- 			disposeFunc(iter)
-- 			return
-- 		end

-- 		local enum = {handle = iter, destructor = disposeFunc}
-- 		setmetatable(enum, entityEnumerator)
-- 		local next = true

-- 		repeat
-- 			coroutine.yield(id)
-- 			next, id = moveFunc(iter)
-- 		until not next

-- 		enum.destructor, enum.handle = nil, nil
-- 		disposeFunc(iter)
-- 	end)
-- end

-- function EnumerateVehicles()
-- 	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
-- end

-- GetVehicles = function()
-- 	local vehicles = {}

-- 	for vehicle in EnumerateVehicles() do
-- 		table.insert(vehicles, vehicle)
-- 	end

-- 	return vehicles
-- end

-- GetVehiclesInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(GetVehicles(), false, coords, maxDistance) end
-- Utils.Vehicles.isSpawnPointClear = function(coords, maxDistance) return #GetVehiclesInArea(coords, maxDistance) == 0 end

-- local cached_langs = {}
-- function Utils.loadLanguageFile(lang_file)
-- 	local resource = cache.resource
-- 	assert(resource,"^3Unknown resource loading the language files.^7")

-- 	Utils.Table.deepMerge(lang_file, Utils.Lang)
-- 	cached_langs[resource] = lang_file
-- end

-- function Utils.translate(key)
-- 	local resource = cache.resource
-- 	if not resource then
-- 		return 'missing_resource'
-- 	end

-- 	if not cached_langs[resource] then
-- 		return 'missing_lang'
-- 	end

-- 	local locale = 'en'
-- 	local langObj = cached_langs[resource][locale]
-- 	if not langObj then
-- 		print(string.format("Language '%s' is not available. Using default 'en'.", locale))
-- 		Config.locale = 'en'
-- 		langObj = cached_langs[resource][Config.locale]
-- 	end

-- 	local keys = Utils.String.split(key,".")
-- 	for _, k in ipairs(keys) do
-- 		if not langObj[k] then
-- 			print(string.format("Translation key '%s' not found for language '%s'.", key, locale))
-- 			return 'missing_translation'
-- 		end
-- 		langObj = langObj[k]
-- 	end

-- 	return langObj
-- end



-- exports('GetUtils', function()
-- 	return Utils
-- end)

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- Debug
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- function Utils.Debug.printTable(node)
-- 	if type(node) == "table" then
-- 		-- to make output beautiful
-- 		local function tab(amt)
-- 			local str = ""
-- 			for i=1,amt do
-- 				str = str .. "\t"
-- 			end
-- 			return str
-- 		end
	
-- 		local cache, stack, output = {},{},{}
-- 		local depth = 1
-- 		local output_str = "{\n"
	
-- 		while true do
-- 			local size = 0
-- 			for k,v in pairs(node) do
-- 				size = size + 1
-- 			end
	
-- 			local cur_index = 1
-- 			for k,v in pairs(node) do
-- 				if (cache[node] == nil) or (cur_index >= cache[node]) then
				
-- 					if (string.find(output_str,"}",output_str:len())) then
-- 						output_str = output_str .. ",\n"
-- 					elseif not (string.find(output_str,"\n",output_str:len())) then
-- 						output_str = output_str .. "\n"
-- 					end
	
-- 					-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
-- 					table.insert(output,output_str)
-- 					output_str = ""
				
-- 					local key
-- 					if (type(k) == "number" or type(k) == "boolean") then
-- 						key = "["..tostring(k).."]"
-- 					else
-- 						key = "['"..tostring(k).."']"
-- 					end
	
-- 					if (type(v) == "number" or type(v) == "boolean") then
-- 						output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
-- 					elseif (type(v) == "table") then
-- 						output_str = output_str .. tab(depth) .. key .. " = {\n"
-- 						table.insert(stack,node)
-- 						table.insert(stack,v)
-- 						cache[node] = cur_index+1
-- 						break
-- 					else
-- 						output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
-- 					end
	
-- 					if (cur_index == size) then
-- 						output_str = output_str .. "\n" .. tab(depth-1) .. "}"
-- 					else
-- 						output_str = output_str .. ","
-- 					end
-- 				else
-- 					-- close the table
-- 					if (cur_index == size) then
-- 						output_str = output_str .. "\n" .. tab(depth-1) .. "}"
-- 					end
-- 				end
	
-- 				cur_index = cur_index + 1
-- 			end
	
-- 			if (#stack > 0) then
-- 				node = stack[#stack]
-- 				stack[#stack] = nil
-- 				depth = cache[node] == nil and depth + 1 or depth - 1
-- 			else
-- 				break
-- 			end
-- 		end
	
-- 		-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
-- 		table.insert(output,output_str)
-- 		output_str = table.concat(output)
	
-- 		print(output_str)
-- 	else
-- 		print(node)
-- 	end
-- end

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- Table
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- function Utils.Table.tableLength(T)
-- 	local count = 0
-- 	for _ in pairs(T) do count = count + 1 end
-- 	return count
-- end

-- function Utils.Table.contains(table, element)
-- 	for _, value in pairs(table) do
-- 		if value == element then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end

-- function Utils.Table.deepCopy(orig)
-- 	local orig_type = type(orig)
-- 	local copy
-- 	if orig_type == 'table' then
-- 		copy = {}
-- 		for orig_key, orig_value in next, orig, nil do
-- 			copy[Utils.Table.deepCopy(orig_key)] = Utils.Table.deepCopy(orig_value)
-- 		end
-- 		setmetatable(copy, Utils.Table.deepCopy(getmetatable(orig)))
-- 	else -- number, string, boolean, etc
-- 		copy = orig
-- 	end
-- 	return copy
-- end

-- function Utils.Table.deepMerge(target, source)
-- 	for key, value in pairs(source) do
-- 		if type(value) == "function" then
-- 			target[key] = value
-- 		elseif type(value) == "table" and value ~= nil then
-- 			-- If the target does not have the key, initialize it as a table
-- 			if type(target[key]) ~= "table" then
-- 				target[key] = {}
-- 			end
-- 			-- Recursively merge tables
-- 			Utils.Table.deepMerge(target[key], value)
-- 		else
-- 			target[key] = value
-- 		end
-- 	end
-- end


-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- String
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- function Utils.String.capitalizeFirst(str)
-- 	if str == nil or str == '' then
-- 		return str
-- 	end
-- 	return (str:sub(1, 1):upper() .. str:sub(2))
-- end

-- function Utils.String.split(str, sep)
-- 	sep = sep or "%s"
-- 	local fields = {}
-- 	local pattern = string.format("([^%s]+)", sep)
-- 	str:gsub(pattern, function(c) fields[#fields + 1] = c end)
-- 	return fields
-- end

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- Math
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- function Utils.Math.trim(value)
-- 	if not value then return nil end
-- 	return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
-- end

-- function Utils.Math.round(value, numDecimalPlaces)
-- 	if not numDecimalPlaces then return math.floor(value + 0.5) end
-- 	local power = 10 ^ numDecimalPlaces
-- 	return math.floor((value * power) + 0.5) / (power)
-- end

-- function Utils.Math.weightedRandom(weights, shift)
-- 	local sum = 0
-- 	for _, weight in pairs(weights) do
-- 		sum = sum + weight
-- 	end

-- 	local threshold = math.random(0, sum) + (shift or 0)
-- 	if threshold > sum then threshold = sum end
-- 	local cumulative = 0
-- 	for number, weight in pairs(weights) do
-- 		cumulative = cumulative + weight
-- 		if threshold <= cumulative then
-- 			return number
-- 		end
-- 	end
-- end

-- function Utils.Math.getRandomKeyFromTable(tbl)
-- 	local keys = {}
-- 	for key in pairs(tbl) do
-- 		table.insert(keys, key)
-- 	end
-- 	local index = keys[math.random(1, #keys)]
-- 	return index
-- end

-- function Utils.Math.checkIfCurrentVersionisOutdated(latestVersion, curVersion)
-- 	local curVersionParts = {}
-- 	for part in string.gmatch(curVersion, "[^.]+") do
-- 		table.insert(curVersionParts, part)
-- 	end

-- 	local latestVersionParts = {}
-- 	for part in string.gmatch(latestVersion, "[^.]+") do
-- 		table.insert(latestVersionParts, part)
-- 	end

-- 	local function isPositiveInteger(str)
-- 		return tonumber(str) ~= nil and math.floor(tonumber(str) or 0) == tonumber(str) and tonumber(str) >= 0
-- 	end

-- 	local function validateParts(parts)
-- 		for i = 1, #parts do
-- 			if not isPositiveInteger(parts[i]) then
-- 				return false
-- 			end
-- 		end
-- 		return true
-- 	end

-- 	if not validateParts(curVersionParts) or not validateParts(latestVersionParts) then
-- 		return 0 / 0 -- NaN in Lua
-- 	end

-- 	for i = 1, #latestVersionParts do
-- 		if tonumber(curVersionParts[i]) == tonumber(latestVersionParts[i]) then
-- 			-- Do nothing, continue to the next part
-- 		elseif tonumber(curVersionParts[i]) > tonumber(latestVersionParts[i]) then
-- 			return false
-- 		else
-- 			return true
-- 		end
-- 	end

-- 	if #curVersionParts ~= #latestVersionParts then
-- 		return true
-- 	end

-- 	return false
-- end

-- Utils.Config = Config
-- print('utils loaded')