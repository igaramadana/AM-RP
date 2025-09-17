gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['okokGasStation']:GetFuel(veh)
end


gg.fuel.setFuel = function(veh, val)
    return exports['okokGasStation']:SetFuel(veh, val)
end