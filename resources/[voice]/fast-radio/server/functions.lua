function GetCoreObject()
    local framework, frameworkName = getFramework()
    return framework, frameworkName
end

function resetConnection(source)
    for k,v in pairs(RADIO_DATA) do
        for a, src in pairs(v.users) do
            if source == src.id then
                RADIO_DATA[k]["users"][a] = nil
                updateMembers(source, RADIO_DATA[k]["users"])
                return true
            end
        end
    end
end

function updateMembers(source, users)
    for k,v in pairs(users) do
        -- if v.id ~= source then
            TriggerClientEvent('fast-radio:client:refreshPlayers', v.id)
        -- end
    end
end

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