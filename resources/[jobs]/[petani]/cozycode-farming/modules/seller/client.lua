local seller = nil
local sellerBlip = nil
local isSelling = false


CreateThread(function()
    if not Config.Seller.enabled then return end


    RequestModel(GetHashKey(Config.Seller.model))
    while not HasModelLoaded(GetHashKey(Config.Seller.model)) do
        Wait(1)
    end

    seller = CreatePed(4, GetHashKey(Config.Seller.model), Config.Seller.location.x, Config.Seller.location.y, Config.Seller.location.z - 1, Config.Seller.location.w, false, true)
    SetEntityHeading(seller, Config.Seller.location.w)
    FreezeEntityPosition(seller, true)
    SetEntityInvincible(seller, true)
    SetBlockingOfNonTemporaryEvents(seller, true)

 
    sellerBlip = AddBlipForCoord(Config.Seller.location.x, Config.Seller.location.y, Config.Seller.location.z)
    SetBlipSprite(sellerBlip, 280)
    SetBlipDisplay(sellerBlip, 4)
    SetBlipScale(sellerBlip, 0.8)
    SetBlipColour(sellerBlip, 2)
    SetBlipAsShortRange(sellerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Farm Buyer")
    EndTextCommandSetBlipName(sellerBlip)
end)


CreateThread(function()
    if not Config.Seller.enabled then return end

    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local sellerCoords = vector3(Config.Seller.location.x, Config.Seller.location.y, Config.Seller.location.z)
        local dist = #(coords - sellerCoords)

        if dist < 3.0 then
            sleep = 0
            DrawText3D(sellerCoords.x, sellerCoords.y, sellerCoords.z + 1.0, "Press ~g~[E]~w~ to sell farm items")
            
            if IsControlJustPressed(0, 38) and not isSelling then -- E key
                SellAllFarmItems()
            end
        end

        Wait(sleep)
    end
end)

function SellAllFarmItems()
    if isSelling then return end
    isSelling = true
    
    TriggerServerEvent('cozycode-farming:sellAllItems')
    
   
    SetTimeout(2000, function()
        isSelling = false
    end)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end 