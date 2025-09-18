FastConfig = {
    Core = "qb", -- qb, oldqb, esx
    Radio_Item = "radio",
    ItemCheck = true, 
    VoiceSystem = "pma-voice", -- pma-voice, mumble-voip, saltychat
    AutoOpenMemberList = true, -- true to auto-open member list when connected, false to disable

    
    -- Sound Settings
    defaultVolume = 50, -- Default volume level (0-100)

    AllowedFrequencies = {
        ["1"] = { jobs = { "police", "sheriff", "ambulance" } },
        ["2"] = { jobs = { "sheriff2", "davis", "vpd" } },
        ["2.0"] = { jobs = { "police", "ambulance", "gangunit" } }
    },
    

    -- Radio Settings
    ChannelLimit = 500, -- Maximum number of channels, must be an integer

    -- UI Settings
    OpenWithKey = false, -- Option to open the radio with a key press
    OpenRadioKey = "F4", -- Key used to open the radio

    -- Locales added
    Locales = {
        -- Profile and UI labels
        yourProfile = "YOUR",
        profile = "PROFILE",
        main = "MAIN",
        channels = "CHANNELS",
        enter = "ENTER",
        frequency = "FREQUENCY",
        connect = "CONNECT",
        radio = "RADIO",
        settings = "SETTINGS",
        radioSize = "Radio Size",
        memberList = "Member List",
        moveRadio = "Move Radio",
        radioColor = "Radio Color",
        favorite = "FAVORITE",
        list = "LIST",
        activeMemberListFirstText = "RADIO",
        activeMemberList = "MEMBER LIST",
       
        -- Notifications
        connectedToChannel = "You have connected to the radio channel: ",
        noAccessToChannel = "You do not have access to this channel!",
        frequencyLimitExceeded = "You are exceeding the frequency limit.",
        invalidFrequency = "You entered an invalid frequency.",
        leftRadioChannel = "You have left the radio channel.",
        volumeUp = "Volume increased.",
        volumeMax = "Volume is at maximum.",
        volumeDown = "Volume decreased.",
        uneeddisconnectCurrentChannel = "You must first log out of the channel you are connected to",
        volumeMin = "Volume is at minimum.",
        cooldownActive = "Cooldown is active, please wait 3 seconds.",
        spamWaitMessage = "Please wait before changing the frequency again.",
        notOnAnyChannel = "You can't favoritize without being connected to the channel!",
        -- Custom notifications for favorite system
        alreadyFavorite = "This frequency is already in your favorites.",
        favoriteAdded = "Frequency successfully added to favorites.",
        favoriteRemoved = "Frequency successfully removed from favorites.",
        steamIdNotFound = "Steam ID not found or invalid frequency. Please try again.",
        frequencyAddError = "Could not add frequency to favorites. Please try again.",
        frequencyRemoveError = "Could not remove frequency from favorites. Please try again.",
        noFavoritesFound = "No favorite channels found.",
        noRadioInInventory = "You don't have a radio in your inventory." -- Message shown if the radio is not in the inventory
    }    
}

function getFramework()
    local framework, frameworkName = nil, nil
    if FastConfig.Core == "esx" then
        framework = exports['es_extended']:getSharedObject()
        frameworkName = "esx"
    elseif FastConfig.Core == "qb" then
        framework = exports["qb-core"]:GetCoreObject()
        frameworkName = "qb"
    elseif FastConfig.Core == "auto" then
        if GetResourceState('qb-core') == 'started' then
            framework = exports["qb-core"]:GetCoreObject()
            frameworkName = "qb"
        elseif GetResourceState('es_extended') == 'started' then
            framework = exports['es_extended']:getSharedObject()
            frameworkName = "esx"
        end
    end
    return framework, frameworkName
end
