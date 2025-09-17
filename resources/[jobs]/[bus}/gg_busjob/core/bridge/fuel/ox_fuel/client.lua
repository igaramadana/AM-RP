gg.fuel = gg.fuel or {}

gg.fuel.getFuel = function(veh)
    return Entity(veh).state.fuel
end


gg.fuel.setFuel = function(veh, val)
    Entity(veh).state.fuel = val
    return true
end