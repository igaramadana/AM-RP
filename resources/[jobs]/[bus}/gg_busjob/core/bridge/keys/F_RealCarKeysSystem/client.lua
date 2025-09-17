gg.keys = gg.keys or {}

gg.keys.AddKeys = function(vehicle)
    if not DoesEntityExist(vehicle) then 
        gg.print.error('Could not add keys, vehicle does not exist!')
        return false 
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('F_RealCarKeysSystem:generateVehicleKeys', plate)
    return true
end

gg.keys.RemoveKeys = function(vehicle)
    if not DoesEntityExist(vehicle) then 
        gg.print.error('Could not remove keys, vehicle does not exist!')
        return false 
    end

    return true
end