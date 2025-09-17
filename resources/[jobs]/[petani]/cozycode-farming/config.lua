Config = {}

Config.Language = "en"

Config.Debug = true

Config.Plant = {
    WaterPerUse = 20,      -- How many water points it should add to the plant.

    WaterTime = 5,         -- How long to water the plant.
    HarvestTime = 5,       -- How long to harvest the plant.
    PlantTime = 5,         -- How long to plant the seed.

    WaterPostDelay = 2,    -- Cooldown for Watering.
    MaxPlayerPlants = 5,   -- Maximum plants a player can grow at a time.
    RenderDistance = 30.0, -- Distance to render spawned plants.

    -- Growth Settings
    GrowthTick = 60000, -- How often plants grow (in ms)
    GrowthRate = 5,     -- How much plants grow per tick (percentage)
    WaterDrain = 1,     -- How much water drains per tick (percentage)

    -- Don't change the below unless needed.
    GrowingTick = 10,      -- How often to tick the growing loop (only when growing).
    GrowingPerTick = 0.01, -- How much to add to the percent in the growing lerp.
}

-- You can add new plants below. Simply copy an exsisitng plant and change name and model

Config.Seeds = {
    ['corn_seed'] = {
        label = "Corn Plant",
        Prop = {
            Model = `prop_plant_fern_02a`,
            Offsets = {
                Start = vector4(0.0, 1.0, -1.0, 0.0),
                End = vector4(0.0, 0.0, 1.0, 0.0),
            }
        },
        Rewards = {
            { name = "corn", min = 1, max = 2 },
        },
        Materials = { "Farm", "Farm2", "Farm3" },
        Zones = { vector4(-98.9300, 1911.5332, 196.8396, 10.0) },
        WaterNeeded = 100,
    },
    ['tomato_seed'] = {
        label = "Tomato Plant",
        Prop = {
            Model = `prop_plant_fern_02a`,
            Offsets = {
                Start = vector4(0.0, 1.0, -1.0, 0.0),
                End = vector4(0.0, 0.0, 1.0, 0.0),
            }
        },
        Rewards = {
            { name = "tomato", min = 1, max = 2 },
        },
        Materials = { "Farm", "Farm2", "Farm3" },
        Zones = { vector4(-98.9300, 1911.5332, 196.8396, 10.0) },
        WaterNeeded = 100,
    },
    ['wheat_seed'] = {
        label = "Wheat Plant",
        Prop = {
            Model = `prop_plant_fern_02a`,
            Offsets = {
                Start = vector4(0.0, 1.0, -1.0, 0.0),
                End = vector4(0.0, 0.0, 1.0, 0.0),
            }
        },
        Rewards = {
            { name = "wheat", min = 1, max = 2 },
        },
        Materials = { "Farm", "Farm2", "Farm3" },
        Zones = { vector4(-98.9300, 1911.5332, 196.8396, 10.0) },
        WaterNeeded = 100,
    },
    ['broccoli_seed'] = {
        label = "Broccoli Plant",
        Prop = {
            Model = `prop_plant_fern_02a`,
            Offsets = {
                Start = vector4(0.0, 1.0, -1.0, 0.0),
                End = vector4(0.0, 0.0, 1.0, 0.0),
            }
        },
        Rewards = {
            { name = "broccoli", min = 1, max = 2 },
        },
        Materials = { "Farm", "Farm2", "Farm3" },
        Zones = { vector4(-98.9300, 1911.5332, 196.8396, 10.0) },
        WaterNeeded = 100,
    },
    ['carrot_seed'] = {
        label = "Carrot Plant",
        Prop = {
            Model = `prop_plant_fern_02a`,
            Offsets = {
                Start = vector4(0.0, 1.0, -1.0, 0.0),
                End = vector4(0.0, 0.0, 1.0, 0.0),
            }
        },
        Rewards = {
            { name = "carrot", min = 1, max = 2 },
        },
        Materials = { "Farm", "Farm2", "Farm3" },
        Zones = { vector4(-98.9300, 1911.5332, 196.8396, 10.0) },
        WaterNeeded = 100,
    },
    ['potato_seed'] = {
        label = "Potato Plant",
        Prop = {
            Model = `prop_plant_fern_02a`,
            Offsets = {
                Start = vector4(0.0, 1.0, -1.0, 0.0),
                End = vector4(0.0, 0.0, 1.0, 0.0),
            }
        },
        Rewards = {
            { name = "potato", min = 1, max = 2 },
        },
        Materials = { "Farm", "Farm2", "Farm3" },
        Zones = { vector4(-98.9300, 1911.5332, 196.8396, 10.0) },
        WaterNeeded = 100,
    },
    ['pickle_seed'] = {
        label = "Pickle Plant",
        Prop = {
            Model = `prop_plant_fern_02a`,
            Offsets = {
                Start = vector4(0.0, 1.0, -1.0, 0.0),
                End = vector4(0.0, 0.0, 1.0, 0.0),
            }
        },
        Rewards = {
            { name = "pickle", min = 1, max = 2 },
        },
        Materials = { "Farm", "Farm2", "Farm3" },
        Zones = { vector4(-98.9300, 1911.5332, 196.8396, 10.0) },
        WaterNeeded = 100,
    },
    ['weed_seed'] = {
        label = "Cannabis Plant",
        Prop = {
            Model = `bkr_prop_weed_lrg_01a`,
            Offsets = {
                Start = vector4(0.0, 1.0, -2.4, 0.0),
                End = vector4(0.0, 0.0, 1.8, 0.0),
            }
        },
        Rewards = {
            { name = "weed", min = 1, max = 2 },
        },
        Materials = { "Farm", "Farm2", "Farm3" },
        Zones = { vector4(-98.9300, 1911.5332, 196.8396, 10.0) },
        WaterNeeded = 100,
    },
}

Config.Blips = {
    {
        Label = "Job: Farming (Fields)",
        ID = 677,
        Color = 47,
        Scale = 0.85,
        Location = vector3(2516.3718, 4845.3442, 36.1397)
    },
    {
        Label = "Job: Farming (Fields)",
        ID = 677,
        Color = 47,
        Scale = 0.85,
        Location = vector3(2225.2822, 5586.5454, 53.8013)
    },
    {
        Label = "Job: Farming (Fields)",
        ID = 677,
        Color = 47,
        Scale = 0.85,
        Location = vector3(-98.9300, 1911.5332, 196.8396)
    },
    {
        Label = "Job: Farming (Selling)",
        ID = 207,
        Color = 47,
        Scale = 0.85,
        Location = vector4(2304.4172, 4849.4829, 41.8082, 42.7612)
    }
}

Config.Seller = {
    enabled = true,
    model = "a_m_m_farmer_01",
    location = vector4(2304.4172, 4849.4829, 41.8082, 42.7612),
    items = {
        ['corn'] = { price = 150 },
        ['tomato'] = { price = 120 },
        ['wheat'] = { price = 130 },
        ['broccoli'] = { price = 140 },
        ['carrot'] = { price = 110 },
        ['potato'] = { price = 100 },
        ['pickle'] = { price = 160 },
        ['weed'] = { price = 300 },
        ['cocaine'] = { price = 350 },
        ['heroin'] = { price = 400 }
    }
}
