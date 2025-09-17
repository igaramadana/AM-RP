gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['qb-fuel']:GetFuel(veh)
end

gg.fuel.setFuel = function(veh, val)
    return exports['qb-fuel']:SetFuel(veh, val)
end