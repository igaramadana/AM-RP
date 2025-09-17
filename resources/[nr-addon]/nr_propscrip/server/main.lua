local QBCore = exports['qb-core']:GetCoreObject()

for k, v in pairs(Config.item) do
    QBCore.Functions.CreateUseableItem(v.itemname, function(source)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            local CurrentZone = v
            TriggerClientEvent(v.itemname .. ':SPAWN', source, CurrentZone)
        end
    end)
end
