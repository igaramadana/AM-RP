gg.dispatch = gg.dispatch or {}

RegisterNetEvent(GetResourceName() .. ":server:lb-tablet:alert", function(data) exports["lb-tablet"]:AddDispatch(data) end)