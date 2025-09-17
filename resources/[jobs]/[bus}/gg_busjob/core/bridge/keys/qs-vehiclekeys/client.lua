gg.keys = gg.keys or {}

gg.keys.AddKeys = function(vehicle)
    if not DoesEntityExist(vehicle) then 
        gg.print.error('Could not add keys, vehicle does not exist!')
        return false 
    end
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local plate = GetVehicleNumberPlateText(vehicle)
    
    exports['qs-vehiclekeys']:GiveKeys(plate, model, true)
    return true
end

gg.keys.RemoveKeys = function(vehicle)
    if not DoesEntityExist(vehicle) then 
        gg.print.error('Could not remove keys, vehicle does not exist!')
        return false 
    end

    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local plate = GetVehicleNumberPlateText(vehicle)

    exports['qs-vehiclekeys']:RemoveKeys(plate, model)
    return true
end