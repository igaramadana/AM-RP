gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['LegacyFuel']:GetFuel(veh)
end

gg.fuel.setFuel = function(veh, val)
    return exports['LegacyFuel']:SetFuel(veh, val)
end