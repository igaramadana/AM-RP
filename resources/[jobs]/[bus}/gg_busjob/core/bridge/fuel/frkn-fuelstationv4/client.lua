gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports["frkn-fuelstationv4"]:GetFuel(veh)
end

gg.fuel.setFuel = function(veh, val)
    return exports["frkn-fuelstationv4"]:SetFuel(veh, val)
end