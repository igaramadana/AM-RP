gg.util = gg.util or {}

gg.util.loadModel = function(model)
    if not IsModelValid(model) then
        -- print("^1[ERROR]^7 Invalid model: " .. tostring(model))
        return false
    end

    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        Wait(100)
        if GetGameTimer() > timeout then
            -- print("^1[ERROR]^7 Model load timed out: " .. tostring(model))
            return false
        end
    end

    return true
end

gg.util.loadAnimDict = function(animDict)
    RequestAnimDict(animDict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
        if GetGameTimer() > timeout then
            print("^1[ERROR]^7 Animation dictionary load timed out: " .. tostring(animDict))
            return false
        end
    end

    return true
end

gg.util.formatNumber = function(number)
    local formatted = tostring(math.floor(number)):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if formatted:sub(1, 1) == "," then
        formatted = formatted:sub(2)
    end
    return formatted
end

gg.util.round = function(num, numDecimalPlaces)
    local multiplier = 10^(numDecimalPlaces or 0)
    return math.floor(num * multiplier + 0.5) / multiplier
end

gg.util.clamp = function(num, min, max)
    if num < min then return min end
    if num > max then return max end
    return num
end

gg.util.getOrdinal = function(num)
    local suffixes = {"th", "st", "nd", "rd"}
    local last_digit = num % 10
    local last_two_digits = num % 100

    if last_two_digits >= 11 and last_two_digits <= 13 then
        return tostring(num) .. "th"
    end

    if last_digit == 1 then
        return tostring(num) .. suffixes[2]  -- "st"
    elseif last_digit == 2 then
        return tostring(num) .. suffixes[3]  -- "nd"
    elseif last_digit == 3 then
        return tostring(num) .. suffixes[4]  -- "rd"
    else
        return tostring(num) .. suffixes[1]  -- "th"
    end
end