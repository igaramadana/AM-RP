gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return exports["ti_fuel"]:getFuel(veh)
end

gg.fuel.setFuel = function(veh, val)
    return exports["ti_fuel"]:setFuel(veh, val, "RON91")
end