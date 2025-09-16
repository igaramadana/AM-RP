local sellCooldown = {}

RegisterNetEvent('cozycode-farming:sellAllItems', function()
    local src = source
    
 
    if sellCooldown[src] and (GetGameTimer() - sellCooldown[src]) < 2000 then
        return
    end
    sellCooldown[src] = GetGameTimer()
    
    local totalMoney = 0
    
 
    for item, data in pairs(Config.Seller.items) do
        local count = Search(src, item)
        if count > 0 then
     
            if RemoveItem(src, item, count) then
                local money = count * data.price
                totalMoney = totalMoney + money
            end
        end
    end
    
 
    if totalMoney > 0 then
        AddItem(src, 'cash', totalMoney)
    else
        ShowNotification(src, "You don't have any items to sell!")
    end
end)


AddEventHandler('playerDropped', function()
    local src = source
    sellCooldown[src] = nil
end) 