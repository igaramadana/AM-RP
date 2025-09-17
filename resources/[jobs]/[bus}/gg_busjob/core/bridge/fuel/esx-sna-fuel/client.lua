gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports['esx-sna-fuel']:GetFuel(veh)
end

gg.fuel.setFuel = function(veh, val)
    return exports['esx-sna-fuel']:SetFuel(veh, val)
end