local function hideText()
    exports["j-textui"]:hideTextUI()
end

local function drawText(text, position)
    if type(position) ~= 'string' then position = 'left' end
    exports["j-textui"]:displayTextUI(text, position)
end

local function changeText(text, position)
    if type(position) ~= 'string' then position = 'left' end
    exports['j-textui']:changeText(text, position)
end

local function keyPressed()
    CreateThread(function()     -- Not sure if a thread is needed but why not eh?
        SendNUIMessage({
            action = 'KEY_PRESSED',
        })
        Wait(500)
        hideText()
    end)
end

RegisterNetEvent('qb-core:client:DrawText', function(text, position)
    drawText(text, position)
end)

RegisterNetEvent('qb-core:client:ChangeText', function(text, position)
    changeText(text, position)
end)

RegisterNetEvent('qb-core:client:HideText', function()
    hideText()
end)

RegisterNetEvent('qb-core:client:KeyPressed', function()
    keyPressed()
end)

exports('DrawText', drawText)
exports('ChangeText', changeText)
exports('HideText', hideText)
exports('KeyPressed', keyPressed)
