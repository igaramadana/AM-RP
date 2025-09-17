cfg = cfg or {}
cfg.settings = cfg.settings or {}


cfg.settings.ui_theme = {
    primary_color = "rgb(130, 90, 255)" -- USE THESE COLOR FORMATS: ["#fefefe", "rgb(40, 180, 90)"]
}
-- Numbers can be 1 - 255
cfg.settings.box_outline = {r = 130, g = 90, b = 255, a = 255}

cfg.settings.defaults = {
    ped = "a_m_m_business_01", -- If the prop does not exist it will default to this prop to avoid issues.
    render = 100.0,
    despawn = {                -- Controls if the bus despawns when a user exits it.
        enabled = true,        -- Should this be active?
        time = 120,            -- Seconds
    },
    outline = {                -- Bus outline when you get out
        enabled = true,       -- Enabled True / False
        distance = 100.0,       -- Distance before Outline is removed
    },
    vehicle = {
        teleport_in_vehicle = false,
    },
}

cfg.settings.blip_theme = { --https://docs.fivem.net/docs/game-references/blips/#blip-colors
    blip_color = 83, 
    route_color = 83,
    radius_color = 3,
}

cfg.settings.reset_time = {
    daily = "00:00", -- At Which Time the Daily's Reset [Example: 22:00] 10 PM
    timezone_offset = "GMT", -- Reflects Table cfg.settings.timezone_offsets [Bottom of This Page]
}

cfg.settings.currency = {
    currency = "USD",  -- [USD, EUR, GBP]
}

cfg.settings.popup = {
    enabled = true, -- Turn to false to stop help popups
    popup_pos = "bottom-middle",
    enable_progress = true, -- Turn to false to stop progress popups
    progress_pos = "right-middle",
}

cfg.settings.leaderboards = {
    tables = {
        ["player_experience"] = lang:get("leaderboard_mostexperience"),
        ["total_jobs_completed"] = lang:get("leaderboard_mostjobs"),
    },
    total_requests = 250, -- How many contestants to show on each leaderboard.
}


cfg.settings.timezone_offsets = {
    -- Standard Time Zones
    UTC = 0,                  -- Coordinated Universal Time
    GMT = 0,                  -- Greenwich Mean Time
    EST = -5 * 3600,          -- Eastern Standard Time
    CST = -6 * 3600,          -- Central Standard Time
    MST = -7 * 3600,          -- Mountain Standard Time
    PST = -8 * 3600,          -- Pacific Standard Time
    AKST = -9 * 3600,         -- Alaska Standard Time
    HST = -10 * 3600,         -- Hawaii-Aleutian Standard Time

    -- Daylight Saving Time Zones
    EDT = -4 * 3600,          -- Eastern Daylight Time
    CDT = -5 * 3600,          -- Central Daylight Time
    MDT = -6 * 3600,          -- Mountain Daylight Time
    PDT = -7 * 3600,          -- Pacific Daylight Time

    -- European Time Zones
    CET = 1 * 3600,           -- Central European Time
    EET = 2 * 3600,           -- Eastern European Time
    WET = 0,                  -- Western European Time

    -- Asian Time Zones
    IST = 5.5 * 3600,         -- Indian Standard Time
    CST_China = 8 * 3600,     -- China Standard Time
    JST = 9 * 3600,           -- Japan Standard Time
    KST = 9 * 3600,           -- Korea Standard Time

    -- Australian Time Zones
    AEST = 10 * 3600,         -- Australian Eastern Standard Time
    ACST = 9.5 * 3600,        -- Australian Central Standard Time
    AWST = 8 * 3600,          -- Australian Western Standard Time

    -- Custom Example
    CUSTOM = -3 * 3600,       -- Example for customization
}


cfg.settings.menus = {
    {
        page = "overview",  -- ID (DONT EDIT)
        label = lang:get("nav_overview"),
        icon = "fas fa-home",
        isActive = true,
    },
    {
        page = "progress",  -- ID (DONT EDIT)
        label = lang:get("nav_progress"),
        icon = "fas fa-chart-line",
        isActive = false,
    },
    {
        page = "vehicles",  -- ID (DONT EDIT)
        label = lang:get("nav_vehicles"),
        icon = "fas fa-bus",
        isActive = false,
    },
    {
        page = "jobs",  -- ID (DONT EDIT)
        label = lang:get("nav_jobs"),
        icon = "fas fa-briefcase",
        isActive = false,
    },
    {
        page = "rider",  -- ID (DONT EDIT)
        label = lang:get("nav_riders"),
        icon = "fas fa-user-friends",
        isActive = false,
    },
    {
        page = "leaderboards",  -- ID (DONT EDIT)
        label = lang:get("nav_leaderboard"),
        icon = "fas fa-trophy",
        isActive = false,
    },
}