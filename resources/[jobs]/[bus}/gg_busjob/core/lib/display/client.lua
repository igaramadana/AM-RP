local utility = require("utility")

gg.display = gg.display or {}


gg.display.notify = function(message)
    local _type = utility.notifications
    if _type == 'ox' then
        return lib.notify({ title = message.title, description = message.msg, duration = message.timeout, type = message.status, icon = message.icon})
    elseif _type == 'mythic' then
        return exports['mythic_notify']:SendAlert(message.status, message.msg)
    elseif _type == 'old_mythic' then
        return exports['mythic_notify']:DoHudText(message.status, message.msg)
    elseif _type == 'pNotify' then
        return exports.pNotify:SendNotification({text = message.msg, type = message.status, timeout = message.timeout})
    elseif _type == 'brutal' then
        return exports['brutal_notify']:SendAlert( message.title, message.msg, message.timeout, message.status)
    elseif _type == 'okok' then
        return exports['okokNotify']:Alert(message.title, message.msg, message.timeout, message.status, false)
    elseif _type == 'stNotify' then
        return exports['stNotify']:Notify(message.status, message.msg, message.title)
    elseif _type == 'sd' then
        return exports['sd-notify']:Notify(message.title, message.msg, message.timeout, message.status, message.position, false, false)
    elseif _type == 'wasabi' then
        return exports.wasabi_notify:notify(message.status, message.msg, message.timeout, message.status)
    elseif _type == 'qb' then
        return TriggerEvent('QBCore:Notify', message.msg, message.status, message.timeout)
    elseif _type == 'esx' then
        return TriggerEvent('esx:showNotification', message.msg)
    elseif _type == 'custom' then
        -- add your custom notification here
    end
end

gg.display.DoTextui = function(text)
    local _type = utility.textUi
    if _type == 'ox' then
        return lib.showTextUI(text.msg)
        --an example
        --lib.showTextUI(text.msg, {position = text.position,icon = text.icon,})
    elseif _type == 'jg' then
        return exports['jg-textui']:DrawText(text.msg)
    elseif _type == 'qb' then
        return exports['qb-core']:DrawText(text.msg, text.position)
    elseif _type == 'cd' then
        return TriggerEvent('cd_drawtextui:ShowUI', 'show', text.msg)
    elseif _type == 'lab' then
        return exports['lab-HintUI']:Show(text.msg)
    elseif _type == 'custom' then
        --do stuff here
    end
end

gg.display.RemoveTextui = function()
    local _type = utility.textUi
    if _type == 'ox' then
        return lib.hideTextUI()
    elseif _type == 'jg' then
        return exports['jg-textui']:HideText()
    elseif _type == 'qb' then
        return exports['qb-core']:HideText()
    elseif _type == 'cd' then
        return TriggerEvent('cd_drawtextui:HideUI')
    elseif _type == 'lab' then
        return exports['lab-HintUI']:Hide()
    elseif _type == 'custom' then
        --do stuff here
    end
end


gg.display.openMenu = function(data, options)
    local id, title, menu = data.id, data.title, data.menu

    lib.registerContext({
        id = id,
        title = title,
        menu = menu,
        options = table.unpack({options})
    })
    lib.showContext(id)
end


RegisterNetEvent(GetCurrentResourceName()..':client:notify', function(data)
    gg.display.notify(data)
end)

-- @param data.duration
-- @param data.label
-- @param data
gg.display.ProgressBar = function(data)
    local _type = utility.ProgressBar
    local success = false
    if _type == "ox" then
        if lib.progressCircle({
            duration = data.duration,
            label = data.label,
            canCancel = true,
            position = "bottom",
            disable = {
                car = true,
            },
        }) then success = true else success = false end
    elseif _type == "qb" then

    else
        if lib.progressCircle({
            duration = data.duration,
            label = data.label,
            canCancel = true,
            position = "bottom",
            disable = {
                car = true,
            },
        }) then success = true else success = false end
    end

    return success
end