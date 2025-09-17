gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['cdn-fuel']:GetFuel(veh)
end


gg.fuel.setFuel = function(veh, val)
    return exports['cdn-fuel']:SetFuel(veh, val)
end
