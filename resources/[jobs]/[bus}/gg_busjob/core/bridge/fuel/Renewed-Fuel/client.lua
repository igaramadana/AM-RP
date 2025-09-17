gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['Renewed-Fuel']:GetFuel(veh)
end


gg.fuel.setFuel = function(veh, val)
    return exports['Renewed-Fuel']:SetFuel(veh, val)
end