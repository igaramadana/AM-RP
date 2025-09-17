Config = {
    MenuLanguage = 'en',
    DebugDisplay = false,
    EnableXtoCancel = true,
    CancelEmoteKey = 'x',
    AllowedInCars = true,
    MenuKeybindEnabled = true,
    MenuKeybind = 'f4',
    FavKeybindEnabled = true,
    FavKeybind = 'capital',
    CustomMenuEnabled = true,
    MenuImage = "https://i.giphy.com/media/ldgXxQ6pJ23yh6Lvjd/giphy.gif",
    MenuTitle = "",
    MenuPosition = "right",
    RagdollEnabled = false,
    RagdollKeybind = 'u', 
    RagdollAsToggle = true,
    ExpressionsEnabled = true,
    PersistentExpression = true,
    WalkingStylesEnabled = true,
    PersistentWalk = true,
    PersistencePollPeriod = 60000,
    SharedEmotesEnabled = true,
    -- If you have the SQL imported enable this to turn on keybinding.
    SqlKeybinding = false,
    -- If you don't like gta notifications, you can disable them here to have messages in the chat.
    NotificationsAsChatMessage = false,
    -- Used for few framework dependent things. Accepted values: "qb-core", false
    Framework = 'qb-core',
    -- You can disable the Adult Emotes here.
    AdultEmotesDisabled = false,
    -- You can disable the Animal Emotes here.
    AnimalEmotesEnabled = true,
    -- Used to enable or disable the search feature in the menu.
    Search = true,
    -- You can disable the handsup here / change the keybind. It is currently set to Y
    HandsupEnabled = true,
    HandsupKeybind = 'Y', -- Get the button string here https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    HandsupKeybindEnabled = false,
    HandsupKeybindInCarEnabled = false,
    PersistentEmoteAfterHandsup = true, -- If true, you will play the emote you were playing previously after you stop handsup.
    -- You can disable the fingrer pointing here / change the keybind. It is currently set to B
    PointingEnabled = false,
    PointingKeybindEnabled = true,
    PointingKeybind = 'B', -- Get the button string here https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    PersistentEmoteAfterPointing = true, -- If true, you will play the emote you were playing previously after you stop pointing.
    -- If crouching should be enabled.
    CrouchEnabled = true,
    CrouchKeybindEnabled = true, -- If true, crouching will use keybinds.
    CrouchKeybind = 'lcontrol', -- The default crouch keybind, get the button string here: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    CrouchOverride = false, -- If true, you won't enter stealth mode even if the crouch key and the "duck" key are the same.
    -- If crawling should be enabled.
    CrawlEnabled = true,
    CrawlKeybindEnabled = true, -- If true, crawling will use keybinds.
    CrawlKeybind = 'rcontrol', -- The default crawl keybind, get the button string here: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    -- If turned on, playing an emote will cancel the previous one.
    CancelPreviousEmote = false,
    -- If turned off, opening the menu and playing an emote will not be possible while swimming
    AllowInWater = true,
    -- If set to true, the /binoculars command will be enabled.
    BinocularsEnabled = true,
    -- If set to true, you'll be able to toggle between different vision modes in the binoculars
    AllowVisionsToggling = true,
    -- If set to true, the /newscam command will be enabled.
    NewscamEnabled = true,
    -- Check for updates
    CheckForUpdates = false,
}

Config.KeybindKeys = {
    ['num4'] = 108,
    ['num5'] = 110,
    ['num6'] = 109,
    ['num7'] = 117,
    ['num8'] = 111,
    ['num9'] = 118
}
