function Utils.Functions:CustomFuelExport(vehicle)
    -- Check if the vehicle is valid
    if not DoesEntityExist(vehicle) then
        return false
    end

    -- TriggerServerEvent("0R-HUD:Server:ErrorHandle", _t("hud.export.fuel_missing"))

    local fuelLevel = exports['LegacyFuel']:GetFuel(vehicle)
    return fuelLevel
end

function Utils.Functions:CustomVoiceResource()
    -- Add your custom sound system events.
    -- for ex:
    --[[
        AddEventHandler("customVoice:setVoiceRange", function(mode)
            Koci.Client.HUD.data.bars.voice.range = mode
        end)

        AddEventHandler("customVoice:setRadioTalking", function(radioTalking)
            Koci.Client.HUD.data.bars.voice.radio = radioTalking
        end)
    --]]
end

local function SetSeatbeltState(state)
    isSeatbeltOn = state
end

exports("SeatbeltState", function(...)
    Koci.Client.HUD:ToggleSeatBelt(...)
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt", function() -- Triggered in smallresources
    ExeuteCommand('toggleseatbelt')
    Koci.Client.HUD:ToggleSeatBelt()
end)