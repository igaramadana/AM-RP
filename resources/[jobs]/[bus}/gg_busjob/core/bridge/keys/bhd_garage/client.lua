gg.keys = gg.keys or {}

gg.keys.AddKeys = function(vehicle)
    if not DoesEntityExist(vehicle) then 
        gg.print.error('Could not add keys, vehicle does not exist!')
        return false 
    end

    TriggerServerEvent('bhd_garage:keys:CreateKey', GetVehicleNumberPlateText(vehicle))
    return true
end

gg.keys.RemoveKeys = function(vehicle)
    if not DoesEntityExist(vehicle) then 
        gg.print.error('Could not remove keys, vehicle does not exist!')
        return false 
    end

    TriggerServerEvent('bhd_garage:keys:DeleteKey', 1, GetVehicleNumberPlateText(vehicle))
    return true
end