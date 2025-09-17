gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports["rcore_fuel"]:GetVehicleFuelLiters(veh)
end


gg.fuel.setFuel = function(veh, val)
    return exports["rcore_fuel"]:SetVehicleFuel(veh, val)
end
