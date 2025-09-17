cfg = cfg or {} cfg.clothing = cfg.clothing or {}

cfg.blipSettings = {
    ["busjob"] = {
        showBlip = true,
        blipSprite = 513,
        blipColor = 83,
        scale = 0.8,
        display = 6,
    },
}

cfg.npcSettings = {
    ["busjob"] = {
        model = "s_m_y_xmech_01",
        scene = "WORLD_HUMAN_SMOKING",
        speech = { -- Find Unique Speeches Here: https://pastebin.com/Vk9609qj
            enableSpeech = true,
            speechName = "BLOCKED_GENERIC",
            speechParam = "SPEECH_PARAMS_FORCE_SHOUTED_CRITICAL",
        },
    },
}

cfg.targetSettings = {
    ["busjob"] = {
        icon = "fas fa-recycle",
        distance = 2.5,
        job = nil, -- Set to "busjob" to require that job to access menu
    },
}

cfg.npcLocations = {
    {   
        label = "Bus Depot",
        npcData = cfg.npcSettings["busjob"],
        blipData = cfg.blipSettings["busjob"],
        targetData = cfg.targetSettings["busjob"],   
        menu = "busjob",
        coords = vector4(449.55, -650.86, 28.48, 260.34),
        rentalSpawn = {
            vector4(457.56, -654.52, 28.64, 213.58),
            vector4(458.9, -648.49, 29.01, 214.19),
            vector4(459.3, -641.36, 29.29, 212.99),
            vector4(460.82, -635.32, 28.48, 213.58),
            vector4(461.7, -628.39, 28.49, 212.82),
            vector4(461.15, -619.72, 28.5, 213.08),
            vector4(462.08, -613.18, 28.49, 213.5),
            vector4(462.95, -606.41, 29.33, 213.97),
            vector4(466.78, -649.99, 28.98, 173.2),
            vector4(468.41, -636.34, 29.33, 173.2),
            vector4(470.94, -615.05, 29.33, 173.23),
            
        },
    },
}

cfg.DailyBonusChallenge = {
    can_earn_item = true,   -- Can earn item on challenge completion
    amount_required = 5, -- Total Jobs Need to Complete to Earn Reward
    rewards = {
        money = 1000, -- Reward money given on challenge completion
        experience = 1250, -- Experience points given on challenge completion
    },
    items = {
        { item = "plastic", probability_weight = 50, min = 10, max = 20 },
        { item = "glass", probability_weight = 25, min = 10, max = 20 },
        { item = "copper", probability_weight = 15, min = 10, max = 20 },
    },
}

cfg.levels = {
    [1] = { experience = 0, buffs = { money_multiplier = 0, experience_multiplier = 0 } },
    [2] = { experience = 500, buffs = { money_multiplier = 2, experience_multiplier = 5 } },
    [3] = { experience = 1500, buffs = { money_multiplier = 5, experience_multiplier = 10 } },
    [4] = { experience = 4000, buffs = { money_multiplier = 10, experience_multiplier = 20 } },
    [5] = { experience = 7500, buffs = { money_multiplier = 15, experience_multiplier = 30 } },
    [6] = { experience = 10000, buffs = { money_multiplier = 20, experience_multiplier = 40 } },
    [7] = { experience = 50000, buffs = { money_multiplier = 25, experience_multiplier = 55 } },
    [8] = { experience = 150000, buffs = { money_multiplier = 35, experience_multiplier = 70 } },
    [9] = { experience = 300000, buffs = { money_multiplier = 40, experience_multiplier = 85 } },
    [10] = { experience = 500000, buffs = { money_multiplier = 50, experience_multiplier = 100 } },
}


cfg.clothing.settings = {
    enabled = true
}

cfg.clothing.outfit = {
    {   -- Mens Clothing
        tshirt_1 = 15,
        torso_1 = 95,
        arms = 11,
        pants_1 = 15,
        decals_2 = 0,
        hair_color_2 = 0,
        helmet_2 = 0,
        torso_2 = 0,
        shoes_1 = 12,
        hair_1 = 0,
        skin = 0,
        pants_2 = 0,
        hair_2 = 0,
        decals_1 = 0,
        tshirt_2 = 0,
        helmet_1 = -1
    },
    {   -- Womens Clothing
        tshirt_1 = 15,
        torso_1 = 95,
        arms = 11,
        pants_1 = 15,
        decals_2 = 0,
        hair_color_2 = 0,
        helmet_2 = 0,
        torso_2 = 0,
        shoes_1 = 12,
        hair_1 = 0,
        skin = 0,
        pants_2 = 0,
        hair_2 = 0,
        decals_1 = 0,
        tshirt_2 = 0,
        helmet_1 = -1
    }
}



-- IGNORE CODE BELOW
-- IGNORE CODE BELOW
-- IGNORE CODE BELOW

while not lang or not lang.translations or not cfg or not cfg.routeData or not cfg.vehicles do Wait(100) end

while true do
    local new_unlocks = {}
    if cfg and cfg.levels then

        for k, v in pairs(cfg.routeData) do
            new_unlocks[v.level] = new_unlocks[v.level] or {}
            local template = {
                id = #new_unlocks[v.level] + 1,
                icon = "fas fa-route",
                description = lang:get("unlocks_route")..": " .. v.label,
            }
            table.insert(new_unlocks[v.level], template)
        end

        for k, v in pairs(cfg.vehicles) do
            new_unlocks[v.level] = new_unlocks[v.level] or {}
            local template = {
                id = #new_unlocks[v.level] + 1,
                icon = "fas fa-bus",
                description = lang:get("unlocks_vehicle")..": " .. v.label,
            }
            table.insert(new_unlocks[v.level], template)
        end

        for k, v in pairs(cfg.levels) do
            if new_unlocks[k] then
                cfg.levels[k].new_unlocks = new_unlocks[k]
            end
        end


        break
    end
    Wait(1000)
end
