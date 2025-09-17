gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports["lc_fuel"]:GetFuel(veh)
end

gg.fuel.setFuel = function(veh, val)
    return exports["lc_fuel"]:SetFuel(veh, val)
end