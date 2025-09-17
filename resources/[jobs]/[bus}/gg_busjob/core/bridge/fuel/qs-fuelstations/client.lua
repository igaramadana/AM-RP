gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['qs-fuelstations']:GetFuel(veh)
end


gg.fuel.setFuel = function(veh, val)
    return exports['qs-fuelstations']:SetFuel(veh, val)
end