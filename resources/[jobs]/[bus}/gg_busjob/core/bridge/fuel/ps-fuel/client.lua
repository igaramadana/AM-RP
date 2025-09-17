gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['ps-fuel']:GetFuel(veh, val)
end


gg.fuel.setFuel = function(veh, val)
    return exports['ps-fuel']:SetFuel(veh, val)
end