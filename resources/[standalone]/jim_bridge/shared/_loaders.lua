--[[
    Player & Resource Event Utility Functions
    -------------------------------------------
    This module provides functions to:
      • Execute code when the player character is loaded or unloaded.
      • Execute code on resource start and stop.
      • Wait for the player to be logged in before proceeding.
]]

local onLoadLast = {} -- keyed by tostring(func)

local function _debouncedRun(func)
    local key  = tostring(func)
    local now  = GetGameTimer()
    local last = onLoadLast[key] or -1e12

    if (now - last) < 5000 then
        debugPrint(("^6Bridge^7 ^3onPlayerLoaded^7 skipped — cooldown %dms remaining"):format(5000 - (now - last)))
        return
    end

    onLoadLast[key] = now
    CreateThread(function()
        Wait(2000) -- keep your small delay
        debugPrint("^6Bridge^7: ^2Executing onPlayerLoaded callback")
        func()
    end)
end

-------------------------------------------------------------
-- Player Loaded and Unloaded Events
-------------------------------------------------------------

--- Executes a function when the player character is loaded.
--- If onStart is true, the function will also run on resource start (after ensuring the player is logged in).
---
--- @param func function The function to execute when the player is loaded.
--- @param onStart boolean (optional) If true, also execute on resource start. Default is false.
--- @usage
--- ```lua
--- onPlayerLoaded(function()
---     print("Player logged in")
---     -- Your initialization code here.
--- end, true)
--- ```
function onPlayerLoaded(func, onStart)
    local onPlayerFramework = ""
    local loaded = false

    if onStart then
        onResourceStart(function()
            if not waitForLogin() then return end
            debugPrint("^6Bridge^7: ^3onResourceStart^7()^2 routed through ^3onPlayerLoaded^7()")
            _debouncedRun(func)
        end, true)
    end

    local handler = function()
        _debouncedRun(func)
    end

    if isStarted(QBExport) or isStarted(QBXExport) then
        onPlayerFramework = QBExport
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', handler)

    elseif isStarted(ESXExport) then
        onPlayerFramework = ESXExport
        RegisterNetEvent('esx:playerLoaded', function()
            if waitForSharedLoad() then handler() end
        end)

    elseif isStarted(OXCoreExport) then
        onPlayerFramework = OXCoreExport
        RegisterNetEvent('ox:playerLoaded', handler)

    elseif isStarted(RSGExport) then
        onPlayerFramework = RSGExport
        RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', handler)

    elseif isStarted(VorpExport) then
        onPlayerFramework = VorpExport
        RegisterNetEvent('vorp_core:Client:OnPlayerSpawned', handler)
    end

    if onPlayerFramework ~= "" then
        debugPrint("^6Bridge^7: ^2Registering ^3onPlayerLoaded^7()^2 with ^3" .. onPlayerFramework .. "^7")
    else
        print("^4ERROR^7: No supported core detected for onPlayerLoaded - Check starter.lua")
    end
end

--- Executes a function when the player character is unloaded.
--- @param func function The function to execute when the player unloads.
--- @usage
--- ```lua
--- onPlayerUnload(function()
---     print("Player has logged out of their character")
---     -- Your cleanup code here.
--- end)
--- ```
function onPlayerUnload(func)
    debugPrint("^6Bridge^7: ^2Registering ^3onPlayerUnload^7()")
    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() func() end)

    RegisterNetEvent('ox:playerLogout', function() func() end)

    RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function() func() end)

    RegisterNetEvent('esx:onPlayerLogout', function() func() end)

end

-------------------------------------------------------------
-- Resource Start and Stop Events
-------------------------------------------------------------

--- Executes a function when the resource starts.
--- @param func function The function to execute.
--- @param thisScript boolean (optional) If true, only runs when this resource starts (default true).
--- @usage
--- ```lua
--- onResourceStart(function()
---     print("Script ensured")
---     -- Initialization code on resource start.
--- end, true)
--- ```
local hasPrinted = false
function onResourceStart(func, thisScript)
    debugPrint("^6Bridge^7: ^2Registering ^3onResourceStart^7()")
    AddEventHandler('onResourceStart', function(resourceName)
        if getScript() == resourceName and (thisScript or true) then
            if waitForSharedLoad() then
                if not hasPrinted then
                    debugPrint("^6Bridge^7: ^2Shared Load Detected^7.")
                    hasPrinted = true
                end
                func(resourceName)
            end
        end
    end)
end

--- Executes a function when the resource stops.
--- @param func function The function to execute.
--- @param thisScript boolean (optional) If true, only runs when this resource stops (default true).
--- @usage
--- ```lua
--- onResourceStop(function()
---     -- Cleanup code here.
--- end, true)
--- ```
function onResourceStop(func, thisScript)
    debugPrint("^6Bridge^7: ^2Registering ^3onResourceStop^7()")
    AddEventHandler('onResourceStop', function(resourceName)
        if getScript() == resourceName and (thisScript or true) then
            func(resourceName)
        end
    end)
end

-------------------------------------------------------------
-- Wait for Login
-------------------------------------------------------------

--- Blocks execution until the player is logged in.
--- @usage
--- waitForLogin()
function waitForLogin()
    local timeout = 10000  -- 10 seconds in milliseconds
    local startTime = GetGameTimer()
    local loggedIn = false

    if isStarted(ESXExport) then
        while (GetGameTimer() - startTime) < timeout do
            local playerData = ESX.GetPlayerData()
            if playerData and playerData.job then
                loggedIn = true
                break
            end
            Wait(100)
        end
    elseif isStarted(OXCoreExport) then
        if OxPlayer["stateId"] then
            loggedIn = true
        end
        while not OxPlayer["stateId"] do
            Wait(1000)
            debugPrint("Waiting for stateId to class as logged in")
            if OxPlayer.get["stateId"] then
                loggedIn = true
                break
            end
        end
    elseif isStarted(VorpExport) then
        -- For other frameworks, use LocalPlayer.state.isLoggedIn.
        while not LocalPlayer.state.IsInSession and (GetGameTimer() - startTime) < timeout do
            Wait(100)
        end
        loggedIn = LocalPlayer.state.IsInSession
    else
        -- For other frameworks, use LocalPlayer.state.isLoggedIn.
        while not LocalPlayer.state.isLoggedIn and (GetGameTimer() - startTime) < timeout do
            Wait(100)
        end
        loggedIn = LocalPlayer.state.isLoggedIn
    end

    if not loggedIn then
        print("^4Error^7: ^2Timeout reached while waiting for player login^7.")
        return false
    else
        debugPrint("^6Bridge^7: ^2Player Login Detected^7.")
        return true
    end
end

local messageShown = false
function waitForSharedLoad()
    local timeout = GetGameTimer() + 900000 -- 15 minutes max wait (had to up this from 2 minutes because of slow servers)
    local loop = 0

    while ((not Jobs or not next(Jobs)) or
        (not Items or not next(Items)) or
        (not Vehicles or not next(Vehicles))
    ) and (timeout and GetGameTimer() < timeout) do
        if loop >= 3 and not messageShown then
            if (not Jobs or not next(Jobs)) then
                print("^4Debug^7: ^2Waiting for ^7Jobs^2 to be loaded")
            end
            if (not Items or not next(Items)) then
                print("^4Debug^7: ^2Waiting for ^7Items^2 to be loaded")
            end
            if (not Vehicles or not next(Vehicles)) then
                print("^4Debug^7: ^2Waiting for ^7Vehicles^2 to be loaded")
            end
            messageShown = true
        end
        Wait(1000)

        loop += 1
    end

    if Jobs and Items and Vehicles then
        debugPrint("^6Bridge^7: ^2Jobs, Items, and Vehicles Loaded^7.")
        return true
    else
        print("^4Error^7: ^1Timeout reached while waiting for shared load^7.")
        return false
    end
end