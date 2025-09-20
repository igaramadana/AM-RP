-- language

local sortir = function(tb)
    local cc = {}
    for k, v in pairs(tb) do
        if v then
            cc[#cc + 1] = v
        end
    end
    return cc
end

CreateThread(function ()
    Utils.loadLanguageFile(Lang)
end)

Citizen.CreateThreadNow(function ()
    local result = MySQL.query.await('SHOW COLUMNS FROM stevid_ikanv2_user')
    local cekPlayerName
    if result then
        for i=1, #result do
            local res = result[i]
            
            if res.Field == 'playername' then
                cekPlayerName = true
            end
        end

        if not cekPlayerName then
            MySQL.query('ALTER TABLE stevid_ikanv2_user ADD COLUMN playername VARCHAR(50) NOT NULL DEFAULT "Nelayan"')
        end
    end
end)

-- variables
local currentDelivery = {}
local currentDive = {}
local turnamen = nil

local FishByPlaces = {
    sea = {},
    river = {},
    lake = {},
    swamp = {}
}

local FishByPlacesAndRarity = {
    sea = {
        common = {},
        uncommon = {},
        rare = {},
        legendary = {},
        mythic = {}
    },
    river = {
        common = {},
        uncommon = {},
        rare = {},
        legendary = {},
        mythic = {}
    },
    lake = {
        common = {},
        uncommon = {},
        rare = {},
        legendary = {},
        mythic = {}
    },
    swamp = {
        common = {},
        uncommon = {},
        rare = {},
        legendary = {},
        mythic = {}
    }
}

local rarities = {
    [1] = 'common',
    [2] = 'uncommon',
    [3] = 'rare',
    [4] = 'legendary',
    [5] = 'mythic'
}

local HasilPancing = {}

local ikan_ygbisa_dijual = {}

for k,v in pairs(Config.fish_stores) do
    ikan_ygbisa_dijual[k] = {}
    for a,b in pairs(v['fishes_to_sell']) do
        ikan_ygbisa_dijual[k][b] = true
    end
end

if Config.fish_prices['enable'] then
    for k,v in pairs(Config.fishes_available) do
        Config.fishes_available[k]['sale_value'] = math.random(Config.fish_prices['prices'][v['rarity']].min, Config.fish_prices['prices'][v['rarity']].max)
    end
end

local fishesA = lib.table.deepclone(Config.fishes_available)
for k,v in pairs(fishesA) do
    for area in pairs(Config.areas_available_to_fish) do
        if lib.table.contains(v['areas'], area) then
            v.key = k
            FishByPlaces[area][k] = v
        end
    end
end

for area, isiArea in pairs(FishByPlaces) do
    for namaIkan, dataIkan in pairs(isiArea) do
        FishByPlacesAndRarity[area][dataIkan.rarity][#FishByPlacesAndRarity[area][dataIkan.rarity]+1] = namaIkan
    end
end

-- utility
randomArray = function(array, kecuali, validasi)
    if table.type(array) ~= 'array' then
        local a1 = {}
        for k,v in pairs(array) do
            a1[#a1+1] = v
        end
        array = a1
    end
    local id = math.random(1, #array)
    if kecuali then
        if type(kecuali) == 'number' then
            if id == kecuali then
                return randomArray(array, kecuali, validasi)
            end
        else
            if next(kecuali) and lib.table.contains(kecuali, id) then
                return randomArray(array, kecuali, validasi)
            end
        end
    end
    if validasi then
        if validasi(array[id]) then
            return array[id], id
        else
            return randomArray(array, kecuali, validasi)
        end
    end
    return array[id], id
end

-- Create a function to pick a value based on the probabilities
local function getRandomByProbability(prob)
    -- Step 1: Calculate the total sum of all probabilities
    local total = 0
    for _, p in pairs(prob) do
        total = total + p
    end

    -- Step 2: Generate a random number between 1 and the total sum
    local rand = math.random(1, total)

    -- Step 3: Iterate through the probability table and determine which value corresponds to the random number
    local cumulative = 0
    for value, p in pairs(prob) do
        cumulative = cumulative + p
        if rand <= cumulative then
            return value
        end
    end
end

local function handle(event, cb)
    RegisterNetEvent('stevid_ikanv2:'..event,cb)
end

-- getter
local function getUserData(src)
    local cid = core.server.Identifier(src)
    local data = exports.oxmysql:executeSync('select fishing_simulator_users from stevid_ikanv2_user where identifier = ?', {cid})
    if data[1] then
        return json.decode(data[1].fishing_simulator_users)
    else
        data = {
            skill_points = 0,
			money = 0,
			total_money_earned = 0,
			total_money_spent = 0,
			total_dives = 0,
			exp = 0,
			total_deliveries = 0,
			user_id = cid,
            player_level = 1,
        }
        for k,v in pairs(Config.upgrades) do
            data[k..'_upgrade'] = 0
        end
        exports.oxmysql:executeSync('insert into stevid_ikanv2_user (identifier, fishing_simulator_users) values(?, ?)', {
            cid,
            json.encode(data)
        })
        return data
    end
end

local function getUserFishes(src)
    local cid = core.server.Identifier(src)
    local data = exports.oxmysql:executeSync('select fishing_simulator_fishes_caught from stevid_ikanv2_user where identifier = ?', {cid})
    if data[1] and json.decode(data[1].fishing_simulator_fishes_caught) then
        return json.decode(data[1].fishing_simulator_fishes_caught)
    else
        data = {}
        for k,v in pairs(Config.fish_prices['prices']) do
            data[#data+1] = {
                rarity = k,
                amount = 0
            }
        end

        local playerData = getUserData(src)
        if playerData then
            exports.oxmysql:executeSync('update stevid_ikanv2_user set fishing_simulator_fishes_caught = ? where identifier = ?', {
                json.encode(data),
                cid
            })
        end
        return data
    end
end

local function getUserEquip(src)
    local cid = core.server.Identifier(src)
    local data = exports.oxmysql:executeSync('select equipments from stevid_ikanv2_user where identifier = ?', {cid})
    if data[1] and json.decode(data[1].equipments) then
        -- print('getUserEquip 1')
        return json.decode(data[1].equipments)
    else
        -- print('getUserEquip 2')

        data = {
            rod = {item = 'ufe_telerod_370'},
			reel = {item = 'ufe_canta_1000'},
			hook = {item = 'ufa_bait_hook'},
			bait = {item = 'bread'},
			line = {item = 'express_fishing_super_line'},
        }
        local playerData = getUserData(src)
        if playerData then
            exports.oxmysql:executeSync('update stevid_ikanv2_user set equipments = ? where identifier = ?', {
                json.encode(data),
                cid
            })
        end
        return data
    end
end

local function getPropertyData(src, lokasi)
    local cid = core.server.Identifier(src)
    local data = exports.oxmysql:executeSync('select property from stevid_ikanv2_user where identifier = ?', {cid})
    if data[1] and json.decode(data[1].property) then
        data = json.decode(data[1].property)
        if lokasi then
            if not data[lokasi] then
                data[lokasi] = {
                    stock = {},
                    property = lokasi,
                    property_condition = 100,
                    stock_weight = 0
                }
                exports.oxmysql:executeSync('update stevid_ikanv2_user set property = ? where identifier = ?', {json.encode(data), cid})
            end
            
            return data[lokasi]
        end
        return data
    else
        data = {}
        if lokasi then
            data[lokasi] = {
                stock = {},
                property = lokasi,
                property_condition = 100,
                stock_weight = 0
            }
            exports.oxmysql:executeSync('update stevid_ikanv2_user set property = ? where identifier = ?', {json.encode(data), cid})
            return data[lokasi]
        end
        return data
    end
end

local function getVehicleData(src)
    local cid = core.server.Identifier(src)
    local data = exports.oxmysql:executeSync('select vehicles from stevid_ikanv2_user where identifier = ?', {cid})
    if data[1] and json.decode(data[1].vehicles) then
        data = json.decode(data[1].vehicles)
        data = sortir(data)
        -- if tipe then
        --     local rv = {}
        --     for k,v in pairs(data) do
        --         if v.type == tipe then
        --             rv[#rv+1] = v
        --         end
        --     end
        --     return rv
        -- end
        return data
    else
        data = {}
        exports.oxmysql:executeSync('update stevid_ikanv2_user set vehicles = ? where identifier = ?', {json.encode(data), cid})
        return data
    end
end

local function getPlayerName(id)
    if type(id) == 'number' and GetPlayerName(id) then
        id = core.server.Identifier(id)
    end

    local db = exports.oxmysql:executeSync('select playername from stevid_ikanv2_user where identifier = ?', {id})
    if db[1] then
        return db[1].playername
    end
    return 'Nelayan'
end

-- setter
local function setVehicleData(src, data)
    local cid = core.server.Identifier(src)
    exports.oxmysql:executeSync('update stevid_ikanv2_user set vehicles = ? where identifier = ?', {
        json.encode(data),
        cid
    })
end

local function setPropertyData(src, lokasi, data)
    local pd = getPropertyData(src)
    pd[lokasi] = data
    local cid = core.server.Identifier(src)
    exports.oxmysql:executeSync('update stevid_ikanv2_user set property = ? where identifier = ?', {
        json.encode(pd),
        cid
    })
end

local function setUserEquip(src, data)
    local cid = core.server.Identifier(src)
    exports.oxmysql:executeSync('update stevid_ikanv2_user set equipments = ? where identifier = ?', {
        json.encode(data),
        cid
    })
end

local function setUserFishes(src, data)
    local cid = core.server.Identifier(src)
    exports.oxmysql:executeSync('update stevid_ikanv2_user set fishing_simulator_fishes_caught = ? where identifier = ?', {
        json.encode(data),
        cid
    })
end

local function setUserData(src, data)
    local cid = core.server.Identifier(src)
    exports.oxmysql:executeSync('update stevid_ikanv2_user set fishing_simulator_users = ? where identifier = ?', {
        json.encode(data),
        cid
    })
end

local function setPlayerName(src)
    local cid = core.server.Identifier(src)
    local nama = core.server.getPlayerName(src)

    if getPlayerName(cid) == 'Nelayan' and getUserData(src) then
        exports.oxmysql:executeSync('update stevid_ikanv2_user set playername = ? where identifier = ?', {nama, cid})
    end
end

-- adder

local function addVehicle(src, data)
    local vd = getVehicleData(src)
    local id = #vd+1
    if #vd > 0 then
        for k,v in pairs(vd) do
            id = v.id
        end
        id += 1
    end

    vd[#vd+1] = {
        type = data.type,
        vehicle = data.vehicle_id,
        health = 1000,
        id = id,
        fuel = 100,
        traveled_distance = 0,
        properties = {}
    }
    setVehicleData(src, vd)
end

-- Local Functions
local function generateContract()
    local data = exports.oxmysql:executeSync('select count(*) as brp from stevid_ikanv2_contracts')
    if data[1].brp < Config.available_contracts['definitions']['max_contracts'] then
        local generate = randomArray(Config.available_contracts['contracts'])
        if generate.reward?.money_min then
            generate.money_reward = math.random(generate.reward.money_min, generate.reward.money_max)
        elseif generate.reward?.item then
            generate.item_reward = generate.reward
            -- generate.display_name = generate.reward.display_name
            -- generate.amount = generate.reward.amount
        end
        for k,v in pairs(generate.required_items) do
            if not v.display_name then
                v.display_name = Config.fishes_available[v.name].name
            end
        end        for k,v in pairs(generate.required_items) do
            if not v.display_name then
                v.display_name = Config.fishes_available[v.name].name
            end
        end
        generate.reward = nil
        generate.progress = 0
        generate.name = Utils.translate(generate.name)
        generate.description = Utils.translate(generate.description)
        generate.lokasi = randomArray(Config.delivery_locations)
        generate.lokasi = vec3(generate.lokasi[1], generate.lokasi[2], generate.lokasi[3])
        exports.oxmysql:executeSync('insert into stevid_ikanv2_contracts (data) values(?)', {json.encode(generate)})
    end
end

local function generateDives()
    local data = exports.oxmysql:executeSync('select count(*) as brp from stevid_ikanv2_dives')
    if data[1].brp < Config.available_dives['definitions']['max_dives'] then
        local generate = randomArray(Config.available_dives['dives'])
        if generate.reward?.money_min then
            generate.money_reward = math.random(generate.reward.money_min, generate.reward.money_max)
        elseif generate.reward?.item then
            generate.item_reward = generate.reward
        end

        generate.reward = nil
        generate.progress = 0
        generate.name = Utils.translate(generate.name)
        generate.description = Utils.translate(generate.description)
        generate.lokasi = randomArray(Config.dives_locations)
        generate.lokasi = vec3(generate.lokasi[1], generate.lokasi[2], generate.lokasi[3])
        exports.oxmysql:executeSync('insert into stevid_ikanv2_dives (data) values(?)', {json.encode(generate)})
    end
end

local function kalkulasiBerat(tb)
    local fishes = Config.fishes_available
    local total = 0
    for k,v in pairs(tb.stock) do
        total += (v.value * fishes[v.id].weight)
    end
    return total
end

local function degradePropertyCondition()
    local db = exports.oxmysql:executeSync('select identifier, property from stevid_ikanv2_user')
    if db[1] then
        for i=1, #db do
            local data = json.decode(db[i].property)
            if data then
                for k,v in pairs(data) do
                    v.property_condition -= 1
                end
            end
            exports.oxmysql:executeSync('update stevid_ikanv2_user set property = ? where identifier = ?', {json.encode(data), db[i].identifier})
        end
    end
end

local function startTournament(cmdKapan, cmdDurasi)
    if turnamen then return end
    -- Wait(100)
    local lokasi = randomArray(Config.fishing_tournaments["locations"])
    lokasi = vec3(lokasi[1], lokasi[2], lokasi[3])
    -- print('akan mulai di ', lokasi)
    local kapan = os.time() + (60 * (cmdKapan or Config.fishing_tournaments["alert_time_before_start"]))
    turnamen = {}
    turnamen = {
        participants = {},
        score = nil,
        startOn = (cmdKapan or Config.fishing_tournaments["alert_time_before_start"]),
        finishOn = (cmdDurasi or Config.fishing_tournaments["event_duration"]),
        announce = function ()
            TriggerClientEvent('stevid_ikanv2:createTournamentBlip', -1, lokasi)
        end,
        lokasi = lokasi,
        kapan = kapan,
        srcByUserId = {},
        remove = function ()
            TriggerClientEvent('stevid_ikanv2:removeTournamentBlip', -1)
        end,
        prizes = Config.fishing_tournaments["prizes"],
        isToday = true,
        jam = os.date("%H", kapan),
        menit = os.date("%M", kapan),
        entryFee = Config.fishing_tournaments["entry_fee"],
        duration = (cmdDurasi or Config.fishing_tournaments["event_duration"]),
        interval = SetInterval(function ()
            if not turnamen then return end
            turnamen.announce()
            if turnamen.startOn >= 1 then
                lib.notify(-1, {
                    title = 'Fishing Tournament',
                    description = 'Lomba mancing akan dimulai '..turnamen.startOn..' menit lagi'
                })
                turnamen.startOn -= 1
            elseif turnamen.finishOn >= 1 then
                if not turnamen.score then
                    turnamen.score = {}
                    for k,v in pairs(turnamen.participants) do
                        turnamen.score[#turnamen.score+1] = {
                            identifier = v,
                            source = turnamen.srcByUserId[v],
                            points = 0,
                            reward = {},
                            user_name = getPlayerName(turnamen.srcByUserId[v])
                        }
                    end
                end
                lib.notify(-1, {
                    title = 'Fishing Tournament',
                    description = 'Lomba mancing akan berakhir '..turnamen.finishOn..' menit lagi'
                })
                turnamen.finishOn -= 1
            else
                if turnamen.participants and #turnamen.participants > 0 then
                    table.sort(turnamen.score, function (a,b)
                        return a.points > b.points
                    end)
                    for k,v in pairs(Config.fishing_tournaments["prizes"]) do
                        -- print(k,v)
                        if turnamen.score[k] then
                            turnamen.score[k].reward = v
                        end
                    end
                    for k,v in pairs(turnamen.score) do
                        if v.reward then
                            lib.notify(-1, {
                                title = 'Fishing Tournament: '..k..'# winner',
                                description = 'Dimenangkan oleh '..v.user_name,
                            })
                            if v.reward.item then
                                if Config.fishes_available[v.reward.item] then
                                    -- exports.ox_inventory:AddItem(src, 'ikan', v.reward.item.amount or 1, {
                                    --     tipe = v.reward.item,
                                    --     imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..v.reward.item..'.png',
                                    --     label = Config.fishes_available[v.reward.item].name,
                                    --     weight = Config.fishes_available[v.reward.item].weight * 1000
                                    -- })
                                    core.server.addItem(src, {
                                        kategori = 'ikan',
                                        jumlah = v.reward.item.amount or 1,
                                        metadata = {
                                            tipe = v.reward.item,
                                            imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..v.reward.item..'.png',
                                            label = Config.fishes_available[v.reward.item].name,
                                            weight = Config.fishes_available[v.reward.item].weight * 1000
                                        }
                                    })
                                    local pd  = getUserData(src)
                                    pd.exp += Config.fishes_available[v.reward.item].exp
                                    if pd.exp >= Config.required_xp_to_levelup[pd.player_level+1] then
                                        pd.player_level += 1
                                        pd.skill_points += 1
                                    end
                                    setUserData(src, pd)
                            
                                    local pdf = getUserFishes(src)
                                    for i=1, #pdf do
                                        if pdf[i].rarity == Config.fishes_available[v.reward.item].rarity then
                                            pdf[i].amount += (v.reward.item.amount or 1)
                                        end
                                    end
                                    setUserFishes(src, pdf)
                                elseif Config.fish_stores['store_1']['items_to_sell'][v.reward.item] then
                                    -- print('disini')
                                    local fishItem = Config.fish_stores['store_1']['items_to_sell']['fishitem']
                                    if fishItem then
                                        -- exports.ox_inventory:AddItem(src, 'fishitem', v.reward.item.amount or 1, {
                                        --     label = fishItem.name,
                                        --     imageurl = 'nui://stevid_ikanv2/nui/'..fishItem.image,
                                        --     tipe = 'fishitem'
                                        -- })

                                        core.server.addItem(src, {
                                            kategori = 'fishitem',
                                            jumlah = v.reward.item.amount or 1,
                                            metadata = {
                                                label = fishItem.name,
                                                imageurl = 'nui://stevid_ikanv2/nui/'..fishItem.image,
                                                tipe = 'fishitem'
                                            }
                                        })
                                    end
                                else
                                    exports.ox_inventory:AddItem(v.source, v.reward.item.label, v.reward.item.amount)
                                end
                            end
                            if v.reward.money then
                                exports.ox_inventory:AddItem(v.source, 'money', v.reward.money)
                            end
                            if v.reward.exp then
                                local pd = getUserData(v.source)
                                pd.exp += v.reward.exp
                                setUserData(v.source, pd)
                            end
                        end
                    end
                end
                turnamen.remove()
                ClearInterval(turnamen.interval)
                turnamen = nil
            end
        end, 60000)
    }
    turnamen.announce()
    lib.notify(-1, {
        title = 'Fishing Tournament',
        description = 'Lomba mancing akan dimulai '..turnamen.startOn..' menit lagi'
    })
    turnamen.startOn -= 1
end

-- handle

handle('startContract', function (lokasi, data)
    local src = source
    local user = getUserData(src)
    local id = data.contract_id

    local db = exports.oxmysql:executeSync('select data from stevid_ikanv2_contracts where id = ?', {id})
    if db[1] and json.decode(db[1].data) then
        exports.oxmysql:executeSync('update stevid_ikanv2_contracts set data = json_set(data, "$.progress", ?) where id = ?', {user.user_id, id})
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
        TriggerClientEvent('stevid_ikanv2:startContract', src, json.decode(db[1].data))
        currentDelivery[user.user_id] = id
    end
end)

handle('cancelContract', function (lokasi, data)
    local src = source
    local user = getUserData(src)
    local id = data.contract_id

    local db = exports.oxmysql:executeSync('select data from stevid_ikanv2_contracts where id = ?', {id})
    if db[1] then
        db = json.decode(db[1].data)
        if db.progress == user.user_id then
            exports.oxmysql:executeSync('update stevid_ikanv2_contracts set data = json_set(data, "$.progress", ?) where id = ?', {0, id})
            TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
            TriggerClientEvent('stevid_ikanv2:cancelContract', src)
        end
    end
end)

handle('finishContract', function ()
    local src = source
    local user = getUserData(src)
    if currentDelivery[user.user_id] then
        local id = currentDelivery[user.user_id]
        local db = exports.oxmysql:executeSync('select data from stevid_ikanv2_contracts where id = ?', {id})
        if db[1] and json.decode(db[1].data) then
            db =  json.decode(db[1].data)
            
            local ada = true
            for i=1, #db.required_items do
                if not core.server.countItem(src, {kategori = 'ikan', jumlah = db.required_items[i].amount, metadata = {tipe = db.required_items[i].name}}) then
                -- if exports.ox_inventory:Search(src, 'count', 'ikan', {tipe = db.required_items[i].name}) < db.required_items[i].amount then
                    ada = false
                end
            end

            if ada then
                for i=1, #db.required_items do
                    local hold = db.required_items[i].name
                    -- exports.ox_inventory:RemoveItem(src, 'ikan', db.required_items[i].amount, {
                    --     tipe = hold,
                    --     imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..hold..'.png',
                    --     label = Config.fishes_available[hold].name,
                    --     weight = Config.fishes_available[hold].weight * 1000
                    -- })

                    core.server.removeItem(src, {
                        kategori = 'ikan',
                        jumlah = db.required_items[i].amount,
                        metadata = {
                            tipe = hold,
                            imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..hold..'.png',
                            label = Config.fishes_available[hold].name,
                            weight = Config.fishes_available[hold].weight * 1000
                        }
                    })
                end
                if db.money_reward then
                    exports.ox_inventory:AddItem(src, 'money', db.money_reward)
                else
                    exports.ox_inventory:AddItem(src, db.item_reward.item, db.item_reward.amount)
                end
                exports.oxmysql:executeSync('delete from stevid_ikanv2_contracts where id = ?', {id})
                user.total_deliveries += 1
                setUserData(src, user)
                currentDelivery[user.user_id] = nil
                TriggerClientEvent('stevid_ikanv2:cancelContract', src)
                lib.notify(src, {
                    title = 'Berhasil menyelesaikan contracts',
                    type = 'success'
                })
            else
                lib.notify(src, {
                    title = 'Membutuhkan ikan sesuai contract yang dipilih!',
                    type = 'error'
                })
            end
        end
    end
end)

handle('startDive', function (lokasi, data)
    local src = source
    local user = getUserData(src)
    local id = data.dive_id

    local db = exports.oxmysql:executeSync('select data from stevid_ikanv2_dives where id = ?', {id})
    if db[1] and json.decode(db[1].data) then
        exports.oxmysql:executeSync('update stevid_ikanv2_dives set data = json_set(data, "$.progress", ?) where id = ?', {user.user_id, id})
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
        TriggerClientEvent('stevid_ikanv2:startDive', src, json.decode(db[1].data))
        currentDive[user.user_id] = id
    end
end)

handle('cancelDive', function (lokasi, data)
    local src = source
    local user = getUserData(src)
    local id = data.dive_id

    local db = exports.oxmysql:executeSync('select data from stevid_ikanv2_dives where id = ?', {id})
    if db[1] then
        db = json.decode(db[1].data)
        if db.progress == user.user_id then
            exports.oxmysql:executeSync('update stevid_ikanv2_dives set data = json_set(data, "$.progress", ?) where id = ?', {0, id})
            TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
            TriggerClientEvent('stevid_ikanv2:cancelDive', src)
        end
    end
end)

handle('finishDive', function ()
    local src = source
    local user = getUserData(src)
    if currentDive[user.user_id] then
        local id = currentDive[user.user_id]
        local db = exports.oxmysql:executeSync('select data from stevid_ikanv2_dives where id = ?', {id})
        if db[1] and json.decode(db[1].data) then
            db =  json.decode(db[1].data)

            if db.money_reward then
                exports.ox_inventory:AddItem(src, 'money', db.money_reward)
            else
                local fishItem = Config.fish_stores['store_1']['items_to_sell'][db.item_reward.item]
                if fishItem then
                    -- exports.ox_inventory:AddItem(src, 'fishitem', db.item_reward.amount, {
                    --     label = fishItem.name,
                    --     imageurl = 'nui://stevid_ikanv2/nui/'..fishItem.image,
                    --     tipe = db.item_reward.item
                    -- })

                    core.server.addItem(src, {
                        kategori = 'fishitem',
                        jumlah = db.item_reward.amount,
                        metadata = {
                            label = fishItem.name,
                            imageurl = 'nui://stevid_ikanv2/nui/'..fishItem.image,
                            tipe = db.item_reward.item
                        }
                    })
                else
                    exports.ox_inventory:AddItem(src, db.item_reward.item, db.item_reward.amount)
                end
            end
            exports.oxmysql:executeSync('delete from stevid_ikanv2_dives where id = ?', {id})
            user.total_dives += 1
            setUserData(src, user)
            currentDive[user.user_id] = nil
            TriggerClientEvent('stevid_ikanv2:cancelDive', src)
            lib.notify(src, {
                title = 'Berhasil menyelesaikan dives',
                type = 'success'
            })
        end
    end
end)

handle('viewLocation', function (lokasi, data)
    local src = source
    if data.contract_id then
        local db = exports.oxmysql:executeSync('select json_extract(`data`, "$.lokasi") as lokasi from stevid_ikanv2_contracts where id = ?', {data.contract_id})
        if db[1] then
            local lok = json.decode(db[1].lokasi)
            TriggerClientEvent('stevid_ikanv2:viewLocation', src, vec3(lok.x, lok.y, lok.z))
        end
    end
end)

handle('viewPropertyLocation', function (lokasi, data)
    local src = source
    local x,y,z = table.unpack(Config.available_items_store['property'][data.property_id].location)
    TriggerClientEvent('stevid_ikanv2:viewLocation', src, vec3(x, y, z))
end)

local otherItems = {}
for k,v in pairs(Config.fish_stores['store_1']['items_to_sell']) do
    otherItems[k] = true
end

handle('sellFish', function (lokasi, data)
    local src = source
    local brp = tonumber(data.amount)
    local hold = data.fish_id
    local tipe, kategori, img, metadata = nil, nil, nil, nil

    if ikan_ygbisa_dijual[lokasi][hold] then
        tipe = 'fishes_to_sell'
        kategori = 'ikan'
        img = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..hold..'.png'
        metadata = {
            tipe = hold,
            imageurl = img,
            label = Config.fishes_available[hold].name,
            weight = Config.fishes_available[hold].weight * 1000
        }
    elseif otherItems[hold] then
        tipe = 'items_to_sell'
        kategori = 'fishitem'
        img = 'nui://stevid_ikanv2/nui/'..Config.fish_stores[lokasi]['items_to_sell'][hold].image
        metadata = {
            label = Config.fish_stores[lokasi]['items_to_sell'][hold].name,
            imageurl = 'nui://stevid_ikanv2/nui/'..Config.fish_stores[lokasi]['items_to_sell'][hold].image,
            tipe = hold
        }
    end

    if not tipe then return end

    if core.server.removeItem(src, {
        kategori = kategori,
        jumlah = brp,
        metadata = metadata
    }) then
        local harga = tonumber(data.value)
        local total = brp * harga
        if Config.CashoutPenjualan == 'player' then
            core.server.AddAccount(src, Config.fish_stores[lokasi]['account'], total)
        else
            local pd = getUserData(src)
            pd.money += total
            pd.total_money_earned += total
            setUserData(src, pd)
        end
        TriggerClientEvent('stevid_ikanv2:bukaPenjualan', src, lokasi)
    end
end)

handle('sellAllFishes', function (lokasi)
    local src = source
    local pd = getUserData(src)
    local data = {}
    if Config.ItemMetadata then
        data = exports.ox_inventory:Search(src, 'slots', 'ikan')
    else
        for k,v in pairs(Config.fishes_available) do
            local meta = {metadata = {tipe = k}}
            local brp = core.server.countItem(src, meta)
            if brp >= 1 then
                data[#data+1] = {
                    count = brp,
                    metadata = meta.metadata
                }
            end
        end
    end
    
    -- fixed penjualan ikan illegal di store biasa
    for k,v in pairs(data) do
        if not ikan_ygbisa_dijual[lokasi][v.metadata.tipe] then
            data[k] = nil
        end
    end


    for k,v in pairs(data) do
        local hold = v.metadata.tipe
        if core.server.removeItem(src, {
            kategori = 'ikan',
            jumlah = v.count,
            metadata = {
                tipe = hold,
                imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..hold..'.png',
                label = Config.fishes_available[hold].name,
                weight = Config.fishes_available[hold].weight * 1000
            }
        }) then
            local harga = tonumber(Config.fishes_available[v.metadata.tipe].sale_value)
            local total = v.count * harga
            if Config.CashoutPenjualan == 'player' then
                core.server.AddAccount(src, Config.fish_stores[lokasi]['account'], total)
            else
                pd.money += total
                pd.total_money_earned += total
            end
        end
    end
    
    if Config.CashoutPenjualan ~= 'player' then
        setUserData(src, pd)
    end

    TriggerClientEvent('stevid_ikanv2:bukaPenjualan', src, lokasi)
end)

handle('joinTournament', function (lokasi, data)
    local src = source
    local user = getUserData(src)
    if not turnamen then return end
    if lib.table.contains(turnamen.participants, user.user_id) then return end
    if user.money >= turnamen.entryFee then
        user.money -= turnamen.entryFee    
        user.total_money_spent += turnamen.entryFee
        table.insert(turnamen.participants, user.user_id)
        turnamen.srcByUserId[user.user_id] = src
        setUserData(src, user)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src)
    end
end)

handle('seeTournamentLocation', function (lokasi, data)
    local src = source 
    if not turnamen then return end

    TriggerClientEvent('stevid_ikanv2:viewLocation', src, {turnamen.lokasi.x, turnamen.lokasi.y})
end)

handle('changeTheme', function (lokasi, data)
    local src = source
    local cid = core.server.Identifier(src)

    exports.oxmysql:executeSync('update stevid_ikanv2_user set darkmode = ? where identifier = ?', {data.dark_theme, cid})
end)

handle('buyProperty', function (lokasi, data)
    local src = source
    local cfg = Config.available_items_store['property'][data.property_id]

    local pd = getUserData(src)
    if pd.money >= cfg.price then
        pd.money -= cfg.price
        pd.total_money_spent += cfg.price
        setUserData(src, pd)
        getPropertyData(src, data.property_id)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

handle('receiveFish', function (lokasi, released)
    local src = source
    -- print('receiveFish', lokasi, released)
    if released then --  released
        
    else -- keep
        if not HasilPancing[src] then return end
        local hold = HasilPancing[src]
        HasilPancing[src] = nil

        if Config.FishBucket and Player(src).state.fishbucket then
            core.server.addItem('fishbucket_'..Player(src).state.fishbucket, {
                kategori = 'ikan',
                jumlah = 1,
                metadata = {
                    tipe = hold,
                    imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..hold..'.png',
                    label = Config.fishes_available[hold].name,
                    weight = Config.fishes_available[hold].weight * 1000
                }
            })
        else
            core.server.addItem(src, {
                kategori = 'ikan',
                jumlah = 1,
                metadata = {
                    tipe = hold,
                    imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..hold..'.png',
                    label = Config.fishes_available[hold].name,
                    weight = Config.fishes_available[hold].weight * 1000
                }
            })
        end
        local pd  = getUserData(src)
        pd.exp += Config.fishes_available[hold].exp
        if pd.player_level < 30 then
            if pd.exp >= Config.required_xp_to_levelup[pd.player_level+1] then
                pd.player_level += 1
                pd.skill_points += 1
            end
        end
        setUserData(src, pd)

        local pdf = getUserFishes(src)
        for i=1, #pdf do
            if pdf[i].rarity == Config.fishes_available[hold].rarity then
                pdf[i].amount += 1
            end
        end
        setUserFishes(src, pdf)
        TriggerClientEvent('stevid_ikanv2:StopFishingGetFish', src)

        if turnamen and lib.table.contains(turnamen.participants, pd.user_id) and turnamen.score then
            for k,v in pairs(turnamen.score) do
                if pd.user_id == v.identifier then
                    local nilai = Config.fishing_tournaments["fish_values"][Config.fishes_available[hold].rarity]
                    v.points += nilai
                end
            end
        end
    end
end)

handle('buyUpgrade', function (lokasi, data)
    local src = source
    local pd = getUserData(src)
    local currentLevel = pd[data.upgrade_type..'_upgrade']
    if Config.upgrades[data.upgrade_type][currentLevel+1] then
        local nextLevel = Config.upgrades[data.upgrade_type][currentLevel+1]
        if pd.skill_points >= nextLevel.points_required then
            pd.skill_points -= nextLevel.points_required
            pd[data.upgrade_type..'_upgrade'] += 1
            setUserData(src, pd)
            TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
        end
    end
end)

handle('updateVehicleStatus', function (data, health, body, fuel, props)
    local src = source
    local vd = getVehicleData(src)
    for k,v in pairs(vd) do
        if tonumber(v.id) == tonumber(data.vehicle_id) then
            v.traveled_distance = data.traveled_distance
            v.health = (health/2) + (body/2)
            v.fuel = fuel
            v.properties = props
            v.properties.plate = nil
            break
        end
    end
    setVehicleData(src, vd)
end)

handle('repairVehicle', function (lokasi, data)
    local src = source
    local vd = getVehicleData(src)
    local pd = getUserData(src)
    local brp = tonumber(data.price)

    if pd.money >= brp then 
        pd.money -= brp
        pd.total_money_spent += brp
        setUserData(src, pd)
        for k,v in pairs(vd) do
            if tonumber(v.id) == tonumber(data.vehicle_id) then
                v.health = 1000
                break
            end
        end
        setVehicleData(src, vd)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

handle('refuelVehicle', function (lokasi, data)
    local src = source
    local vd = getVehicleData(src)
    local pd = getUserData(src)
    local brp = tonumber(data.price)

    if pd.money >= brp then 
        pd.money -= brp
        pd.total_money_spent += brp
        setUserData(src, pd)
        for k,v in pairs(vd) do
            if tonumber(v.id) == tonumber(data.vehicle_id) then
                v.fuel = 100
                break
            end
        end
        setVehicleData(src, vd)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

handle('spawnVehicle', function (lokasi, data)
    local src = source
    local vd = getVehicleData(src)
    local tb = nil
    for k,v in pairs(vd) do
        if tonumber(v.id) == tonumber(data.vehicle_id) then
            tb = lib.table.deepclone(v)
            break
        end
    end
    local cfg = tb.type == 'vehicle' and Config.fishing_locations[lokasi]['garage_locations'] or Config.fishing_locations[lokasi]['boat_garage_locations']

    TriggerClientEvent('stevid_ikanv2:spawnVehicle', src, tb, cfg, Config.fishing_locations[lokasi]['menu_location'], Config.vehicle_blips[tb.type])
end)

handle('buyVehicle', function (lokasi, data)
    local src = source
    local pd = getUserData(src)
    local cfg = Config.available_items_store[data.type][data.vehicle_id]

    if pd.money >= cfg.price then
        pd.money -= cfg.price
        pd.total_money_spent += cfg.price
        addVehicle(src, data)
        setUserData(src, pd)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

handle('sellVehicle', function (lokasi, data)
    local src = source
    local pd = getUserData(src)
    local vd = getVehicleData(src)
    local tb = nil
    for k,v in pairs(vd) do
        if tonumber(v.id) == tonumber(data.vehicle_id) then
            tb = lib.table.deepclone(v)
            break
        end
    end

    if tb then
        local cfg = Config.available_items_store[tb.type][tb.vehicle]
        local sellPrice = cfg.price * Config.vehicle_sell_price_multiplier

        for k,v in pairs(vd) do
            if tonumber(v.id) == tonumber(data.vehicle_id) then
                vd[k] = nil
                break
            end
        end

        setVehicleData(src, vd)
        pd.money += sellPrice
        setUserData(src, pd)

        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

handle('depositMoney', function (lokasi, data)
     local src = source
    local brp = tonumber(data.amount)
    local pd = getUserData(src)
    local xPlayer = core.object.GetPlayerFromId(src)
    if xPlayer and xPlayer.getAccount('bank').money > brp then
        xPlayer.removeAccountMoney('bank', brp)
        pd.money += brp
        setUserData(src, pd)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

handle('withdrawMoney', function (lokasi, data)
    local src = source
    local brp = tonumber(data.amount)
    local pd = getUserData(src)
    local xPlayer = core.object.GetPlayerFromId(src)
    if xPlayer and pd.money >= brp then
        pd.money -= brp
        xPlayer.addAccountMoney('bank', brp)
        -- exports.ox_inventory:AddItem(src, 'money', brp)
        setUserData(src, pd)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

handle('buyEquipment', function (lokasi, data)
    local src = source
    local eq = Config.equipments_upgrades[data.equipment_type][data.equipment_id]
    local pd = getUserData(src)
    if not data.amount then lib.notify(src, {title = 'Masukkan jumlahnya', type = 'error'}) return end
    if pd.money >= (eq.price* tonumber(data.amount)) then 
        pd.money -= (eq.price* tonumber(data.amount))
        pd.total_money_spent += (eq.price* tonumber(data.amount))
        if data.equipment_id == 'scuba' then
            -- exports.ox_inventory:AddItem(src, data.equipment_id, 1, {
            --     label = eq.name,
            --     imageurl = 'nui://stevid_ikanv2/nui/'..eq.icon,
            -- })

            core.server.addItem(src, {
                kategori = data.equipment_id,
                jumlah = 1,
                metadata = {
                    tipe = data.equipment_id,
                    label = eq.name,
                    imageurl = 'nui://stevid_ikanv2/nui/'..eq.icon,
                }
            })
        else
            -- exports.ox_inventory:AddItem(src, data.equipment_type, tonumber(data.amount), {
            --     tipe = data.equipment_id,
            --     label = eq.name,
            --     imageurl = 'nui://stevid_ikanv2/nui/'..eq.icon,
            -- })

            core.server.addItem(src, {
                kategori = data.equipment_type,
                jumlah = tonumber(data.amount),
                metadata = {
                    tipe = data.equipment_id,
                    label = eq.name,
                    imageurl = 'nui://stevid_ikanv2/nui/'..eq.icon,
                }
            })
        end
        setUserData(src, pd)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

handle('withdrawItem', function (lokasi, data)
     local src = source
    local brp = tonumber(data.amount)
    local pd = getUserData(src)
    local dmn = data.property
    local cfg = Config.available_items_store['property'][dmn]
    local fishes = Config.fishes_available
    local saatIni = getPropertyData(src, dmn)

    local ada = false
    for k,v in pairs(saatIni.stock) do
        -- print(tonumber(v.amount), brp)
        if v.id == name and tonumber(v.value) >= brp then
            -- if exports.ox_inventory:AddItem(src, 'ikan', 1, {
            --     tipe = name,
            --     imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..name..'.png',
            --     label = Config.fishes_available[name].name,
            --     weight = Config.fishes_available[name].weight * 1000
            -- }) then
            --     saatIni.stock[k].value -= brp
            --     if saatIni.stock[k].value <= 0 then
            --         saatIni.stock[k] = nil
            --     end
            --     ada = true
            --     break
            -- end

            if core.server.addItem(src, {
                kategori = 'ikan',
                jumlah = brp,
                metadata = {
                    tipe = name,
                    imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..name..'.png',
                    label = Config.fishes_available[name].name,
                    weight = Config.fishes_available[name].weight * 1000
                }
            }) then
                saatIni.stock[k].value -= brp
                if saatIni.stock[k].value <= 0 then
                    saatIni.stock[k] = nil
                end
                ada = true
                break
            end
        end
    end

    saatIni.stock_weight = kalkulasiBerat(saatIni)

    if ada then
        setPropertyData(src, dmn, saatIni)
        TriggerClientEvent('stevid_ikanv2:openProperty', src, dmn)
    end
end)

handle('depositItem', function (lokasi, data)
    local src = source
    local name = data.item
    local brp = data.amount
    local dmn = data.property
    local cfg = Config.available_items_store['property'][dmn]
    local fishes = Config.fishes_available

    local saatIni = getPropertyData(src, dmn)
    local beratSaatIni = 0
    for k,v in pairs(saatIni.stock) do
        beratSaatIni += (v.value * fishes[v.id].weight)
    end

    if (beratSaatIni + (brp * fishes[name].weight)) < cfg.capacity then
        if core.server.removeItem(src, {
            kategori = 'ikan',
            jumlah = brp,
            metadata = {
                tipe = name,
                imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..name..'.png',
                label = Config.fishes_available[name].name,
                weight = Config.fishes_available[name].weight * 1000
            }
        }) then
        -- if exports.ox_inventory:RemoveItem(src, 'ikan', brp, {
        --     tipe = name,
        --     imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..name..'.png',
        --     label = Config.fishes_available[name].name,
        --     weight = Config.fishes_available[name].weight * 1000
        -- }) then
            local dpt = false
            for k,v in pairs(saatIni.stock) do
                if v.id == name then
                    v.value += brp
                    dpt = true
                    break
                end
            end
            if not dpt then
                table.insert(saatIni.stock, {
                    id = name,
                    label = Config.fishes_available[name].name,
                    value = brp
                })
            end

            saatIni.stock_weight = kalkulasiBerat(saatIni)

            setPropertyData(src, dmn, saatIni)
            TriggerClientEvent('stevid_ikanv2:openProperty', src, dmn)
        end
    end
end)

handle('repairProperty', function (lokasi, data)
    local src = source
    local pd = getUserData(src)
    local brp = tonumber(data.biaya)
    
    if pd.money >= brp then
        pd.money -= brp
        pd.total_money_spent += brp
        setUserData(src, pd)
        local pdd = getPropertyData(src, data.property_id)
        pdd.property_condition = 100
        setPropertyData(src, data.property_id, pdd)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

handle('sellProperty', function (lokasi, data)
    local src = source
    local pd = getUserData(src)
    local pdd = getPropertyData(src, data.property_id)
    local harga = Config.available_items_store['property'][data.property_id].price
    local sellPrice = harga * Config.property_sell_price_multiplier

    if pdd then
        pd.money += sellPrice
        setPropertyData(src, data.property_id, nil)
        setUserData(src, pd)
        TriggerClientEvent('stevid_ikanv2:bukaDashboard', src, true)
    end
end)

-- Callbacks
lib.callback.register('stevid_ikanv2:fishAvailable', function()
    return Config.fishes_available
end)

lib.callback.register('stevid_ikanv2:generateFish', function(source, tipe)
    local pd = getUserData(source)
    
    local areaLevel = pd[tipe..'_upgrade'] + 1
    local rnd = getRandomByProbability(Config.fishing_difficulties['fish_probability_by_level'][areaLevel])
    local rarity = rarities[rnd]
    local dpt = randomArray(FishByPlaces[tipe], nil, function (dapetnya)
        return dapetnya.rarity == rarity
    end)

    dpt.level = rnd
    dpt.areas = nil

    if not HasilPancing[source] then HasilPancing[source] = nil end
    HasilPancing[source] = dpt.key


    return {
        fish_data = dpt
    }
end)

handle('generatedFish', function (key)
    local src = source
    if not HasilPancing[src] then HasilPancing[src] = nil end
    HasilPancing[src] = key
end)

lib.callback.register('stevid_ikanv2:getAreaLevel', function(source, area)
    local pd = getUserData(source)
    return pd[area..'_upgrade'] + 1
end)

lib.callback.register('stevid_ikanv2:getIkanSaya', function(source)
    local src = source
    local data, data2 = {}, {}
    if Config.ItemMetadata then
        data = exports.ox_inventory:Search(src, 'slots', 'ikan')
        data2 = exports.ox_inventory:Search(src, 'slots', 'fishitem')
    else
        for k,v in pairs(Config.fishes_available) do
            local meta = {metadata = {tipe = k}}
            local brp = core.server.countItem(src, meta)
            if brp >= 1 then
                data[#data+1] = {
                    count = brp,
                    metadata = meta.metadata
                }
            end
        end

        for k,v in pairs(Config.fish_stores['store_1']['items_to_sell']) do
            local meta = {metadata = {tipe = k}}
            local brp = core.server.countItem(src, meta)
            if brp >= 1 then
                data2[#data2+1] = {
                    count = brp,
                    metadata = meta.metadata
                }
            end
        end
    end
    
    local IkanSaya = {}
    if #data > 0 then
        for k,v in pairs(data) do
            if not IkanSaya[v.metadata.tipe] then
                IkanSaya[v.metadata.tipe] = v.count
            else
                IkanSaya[v.metadata.tipe] += v.count
            end
        end
    end
    if #data2 > 0 then
        for k,v in pairs(data2) do
            if not IkanSaya[v.metadata.tipe] then
                IkanSaya[v.metadata.tipe] = v.count
            else
                IkanSaya[v.metadata.tipe] += v.count
            end
        end
    end

    return IkanSaya
end)

lib.callback.register('stevid_ikanv2:getAvailableContracts', function(source)
    local src = source
    local data = exports.oxmysql:executeSync('select * from stevid_ikanv2_contracts')
    local retval = {}
    for k,v in pairs(data) do
        local id = #retval+1
        retval[id] = json.decode(v.data)
        retval[id].id = v.id
    end
    return retval
end)

lib.callback.register('stevid_ikanv2:getAvailableDives', function(source)
    local src = source
    local data = exports.oxmysql:executeSync('select * from stevid_ikanv2_dives')
    local retval = {}
    for k,v in pairs(data) do
        local id = #retval+1
        retval[id] = json.decode(v.data)
        retval[id].id = v.id
    end
    return retval
end)

lib.callback.register('stevid_ikanv2:getUserData', function(source)
    setPlayerName(source)
    return getUserData(source)
end)

lib.callback.register('stevid_ikanv2:getUserFishes', function(source)
    return getUserFishes(source)
end)

lib.callback.register('stevid_ikanv2:getVehicleData', function(source)
    return getVehicleData(source)
end)

lib.callback.register('stevid_ikanv2:getFishingData', function(source)
    return getUserEquip(source)
end)

lib.callback.register('stevid_ikanv2:getTheme', function(source)
    local src = source
    if getUserData(src) then
        local cid = core.server.Identifier(src)
        local data = exports.oxmysql:executeSync('select darkmode from stevid_ikanv2_user where identifier = ?', {cid})
        if data[1] then
            return data[1].darkmode
        end
    end
end)

lib.callback.register('stevid_ikanv2:getPropertyData', function(source, lokasi)
    return getPropertyData(source, lokasi)
end)

lib.callback.register('stevid_ikanv2:cekPropertyOwned', function(source, property)
    local cid = core.server.Identifier(source)
    local data = exports.oxmysql:executeSync('select property from stevid_ikanv2_user where identifier = ?', {cid})
    if data[1] and json.decode(data[1].property) then
        data = json.decode(data[1].property)
        if data[property] then
            return true
        end
    end
    return false
end)

lib.callback.register('stevid_ikanv2:getTopUser', function(source)
    local db = exports.oxmysql:executeSync('select playername, identifier, json_extract(fishing_simulator_users, "$.exp") as `exp`, fishing_simulator_fishes_caught from stevid_ikanv2_user order by json_extract(fishing_simulator_users, "$.exp") desc limit 10')
    local rv = {}
    if db[1] then
        for i=1, #db do
            local total = 0
            local data = json.decode(db[i].fishing_simulator_fishes_caught)
            if data then
                for k,v in pairs(data) do
                    total += v.amount
                end
            end
            rv[#rv+1] = {
                name = db[i].playername,
                firstname = '',
                exp = db[i].exp,
                fishes_caught = total
            }
        end
    end
    return rv
end)

lib.callback.register('stevid_ikanv2:getNextTourney', function(source)
    return turnamen
end)

-- Crons

for i=1, #Config.fishing_tournaments["schedule"] do
    lib.cron.new(Config.fishing_tournaments["schedule"][i], function (task, date)
        startTournament()
    end)
end

lib.cron.new('*/'..Config.time_degradate_property..' * * * *', degradePropertyCondition)

lib.cron.new('*/'..Config.available_dives['definitions']['time_to_new_dives']..' * * * *', generateDives)

lib.cron.new('*/'..Config.available_contracts['definitions']['time_to_new_contracts']..' * * * *', generateContract)

-- Commands
lib.addCommand('createtournament', {
    restricted = 'group.admin',
    params = {
        {name = 'starting', type = 'number', optional = true},
        {name = 'duration', type = 'number', optional = true},
    }
}, function (source, args, raw)
    startTournament(args.starting, args.duration)
end)

lib.addCommand('degradeproperty', {
    restricted = 'group.admin',
    help = 'Turunkan kualitas kondisi semua properti'
}, degradePropertyCondition)

lib.addCommand('generate_dive', {
    restricted = 'group.admin',
    help = 'Tambahkan kontrak diving'
}, generateDives)

lib.addCommand('generate_delivery', {
    restricted = 'group.admin',
    help = 'Tambahkan kontrak deliveries'
}, generateContract)

lib.addCommand('spawn_fish', {
    restricted = 'group.admin',
    help = 'Tambahkan kontrak deliveries',
    params = {
        {name = 'nama', help = 'nama spawn ikan', type = 'string'},
        {name = 'brp', help = 'jumlah ikan', type = 'number', optional = true},
        {name = 'tipe', help = 'ikan/fishitem', type = 'string', optional = true}
    }
}, function (source, args, raw)
    local src = source
    local hold = args.nama
    if not hold then return end
    if args.tipe == 'ikan' or args.tipe == nil then
        core.server.addItem(src, {
            kategori = 'ikan',
            jumlah = args.brp,
            metadata = {
                tipe = hold,
                imageurl = 'nui://stevid_ikanv2/nui/images/fishing/fishes/'..hold..'.png',
                label = Config.fishes_available[hold].name,
                weight = Config.fishes_available[hold].weight * 1000
            }
        })
        local pd  = getUserData(src)
        pd.exp += Config.fishes_available[hold].exp
        if pd.player_level < 30 then
            if pd.exp >= Config.required_xp_to_levelup[pd.player_level+1] then
                pd.player_level += 1
                pd.skill_points += 1
            end
            setUserData(src, pd)
        end

        local pdf = getUserFishes(src)
        for i=1, #pdf do
            if pdf[i].rarity == Config.fishes_available[hold].rarity then
                pdf[i].amount += (args.brp or 1)
            end
        end
        setUserFishes(src, pdf)
    else
        -- print('disini')
        local fishItem = Config.fish_stores['store_1']['items_to_sell'][args.nama]
        if fishItem then
            core.server.addItem(src, {
                kategori = 'fishitem',
                jumlah = args.brp,
                metadata = {
                    label = fishItem.name,
                    imageurl = 'nui://stevid_ikanv2/nui/'..fishItem.image,
                    tipe = args.nama
                }
            })
        end
    end
end)

local semuaEqupments = {}

-- Items Useable
local function registerItemEquip(source, item)
    -- print('use item')
    local tipe = Config.ItemMetadata and item.metadata.tipe or item.name
    local k = Config.ItemMetadata and item.name or semuaEqupments[item.name]
    local pe = getUserEquip(source)
    if pe[k].item ~= tipe then
        pe[k].item = tipe
        lib.notify(source, {
            title = 'Mengatur '..k..' menjadi '..Config.equipments_upgrades[k][tipe].name
        })
        setUserEquip(source, pe)
    end
    if k == 'rod' then
        local ada = {
            bait = core.server.countItem(source, {
                kategori = 'bait',
                jumlah = 1,
                metadata = {tipe = pe.bait.item}
            }),
            hook = core.server.countItem(source, {
                kategori = 'hook',
                jumlah = 1,
                metadata = {tipe = pe.hook.item}
            }),
            line = core.server.countItem(source, {
                kategori = 'line',
                jumlah = 1,
                metadata = {tipe = pe.line.item}
            }),
            reel = core.server.countItem(source, {
                kategori = 'reel',
                jumlah = 1,
                metadata = {tipe = pe.reel.item}
            }),
            rod = core.server.countItem(source, {
                kategori = 'rod',
                jumlah = 1,
                metadata = {tipe = pe.rod.item}
            }) 
        }
        if  ada.rod and ada.bait and ada.hook and ada.line and ada.reel
        then
            TriggerClientEvent('stevid_ikanv2:startFishing', source)
        else
            if not ada.bait then                    
                lib.notify(source, {
                    title = 'Missing equipment: Bait '.. Config.equipments_upgrades['bait'][pe.bait.item].name,
                    type = 'error'
                })
            end
            if not ada.hook then
                lib.notify(source, {
                    title = 'Missing equipment: Hook '.. Config.equipments_upgrades['hook'][pe.hook.item].name,
                    type = 'error'
                })
            end
            if not ada.line then
                lib.notify(source, {
                    title = 'Missing equipment: Line '.. Config.equipments_upgrades['line'][pe.line.item].name,
                    type = 'error'
                })
            end
            if not ada.reel then
                lib.notify(source, {
                    title = 'Missing equipment: Reel '.. Config.equipments_upgrades['reel'][pe.reel.item].name,
                    type = 'error'
                })
            end
            if not ada.rod then
                lib.notify(source, {
                    title = 'Missing equipment: Rod '.. Config.equipments_upgrades['rod'][pe.rod.item].name,
                    type = 'error'
                })
            end
        end
    end
end

for k,v in pairs(Config.equipments_upgrades) do
    core.server.UseItem(k, registerItemEquip)
    for a, b in pairs(v) do
        semuaEqupments[a] = k
        core.server.UseItem(a, registerItemEquip)
    end
end

RegisterNetEvent('stevid_ikanv2:removeBait', function ()
    local src = source
    local pe = getUserEquip(src)
    local baitData = Config.equipments_upgrades['bait'][pe.bait.item]
    core.server.removeItem(src, {kategori = 'bait', jumlah = 1, metadata = {tipe = pe.bait.item, label = baitData['name'], imageurl =  'nui://stevid_ikanv2/nui/'..baitData.icon} })
    -- exports.ox_inventory:RemoveItem(source, 'bait', 1, {tipe = pe.bait.item, label = baitData['name'], imageurl =  'nui://stevid_ikanv2/nui/'..baitData.icon})
end)

core.server.UseItem('scuba', function (src, item)
    TriggerClientEvent('stevid_ikanv2:toggleswimsuit', src)
end)