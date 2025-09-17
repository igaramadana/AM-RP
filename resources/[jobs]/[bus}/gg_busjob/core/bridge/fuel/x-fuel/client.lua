gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['x-fuel']:GetFuel(veh)
end

gg.fuel.setFuel = function(veh, val)
    return exports['x-fuel']:SetFuel(veh, val)
end