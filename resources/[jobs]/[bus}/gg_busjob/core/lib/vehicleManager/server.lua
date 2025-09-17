gg.vehicleManager = gg.vehicleManager or {}


gg.vehicleManager.removeVehicle = function(netid)
    local entity = NetworkGetEntityFromNetworkId(netid)
    if not netid or type(entity) ~= "number" or entity == 0 then
        return false
    end

    if GetResourceState("AdvancedParking") == "started" then
            exports["AdvancedParking"]:DeleteVehicle(entity, false)
        return true
    end

    if not DoesEntityExist(entity) then
        return false
    end

    DeleteEntity(entity)
    return not DoesEntityExist(entity)
end

