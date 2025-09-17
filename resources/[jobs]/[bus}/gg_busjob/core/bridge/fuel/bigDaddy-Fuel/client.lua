gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['BigDaddy-Fuel']:GetFuel(veh)
end

gg.fuel.setFuel = function(veh, val)
    return exports['BigDaddy-Fuel']:SetFuel(veh, val)
end