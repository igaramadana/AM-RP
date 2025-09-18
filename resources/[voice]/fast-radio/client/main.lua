local Framework, frameworkName = getFramework()
PropList = {}
CurrentChannel = nil
AllChannelData = {}
FavoriteData = {}

RegisterNetEvent("fast-radio:client:data_function", function(data)
    -- print(data)
    -- print(data)
    FavoriteData = data 
    FavoriteData = json.decode(FavoriteData)
    -- print(json.encode(FavoriteData))
end)

CreateThread(function()
    if FastConfig.OpenWithKey then 
        RegisterCommand("+radio", function()
            UseRadio()
        end)
        
        RegisterKeyMapping('+radio', 'Open Radio', 'keyboard', FastConfig.OpenRadioKey)
    end 
end)
