gg.dispatch = gg.dispatch or {}

---@param data table
--- data.message   string   | Dispatch message text
--- data.code      string   | Dispatch code (e.g. "10-80")
--- data.icon      string   | FontAwesome icon string
--- data.priority  number   | Priority level (1 = high, 3 = low)
--- data.coords    vector3  | Location for the dispatch alert
--- data.vehicle   number   | Vehicle entity (optional)
--- data.plate     string   | Vehicle plate (optional)
--- data.time      number   | Alert duration in ms (10000 = 10s)
--- data.jobs      table    | List of jobs who see the alert
--- data.blipData  table    | Blip config {radius, sprite, color, scale, length, flash}
---   radius       number   | Blip radius
---   sprite       number   | Blip sprite ID
---   color        number   | Blip color ID
---   scale        number   | Blip scale
---   length       number   | Length in ms (converted to minutes internally)
---   flash        boolean  | Should blip flash
gg.dispatch.alert = function(data)
    local streetHash, crossingHash = GetStreetNameAtCoord(data.coords.x, data.coords.y, data.coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    local priority = 'medium'
    if type(data.jobs) == 'table' then
        data.jobs = data.jobs[1]
    end
    if data.time and data.time > 1000 then
        data.time = math.floor((data.time / 1000) + 0.5)
    end
    local payload = {
        priority = priority,
        code = data.code or '10-80',
        title = 'Dispatch Alert!',
        description = data.message,
        location = {
            label = streetName,
            coords = vec2(data.coords.x, data.coords.y)
        },
        time = data.time or 10000,
        job = data.jobs,
    }

    TriggerServerEvent(GetResourceName() .. ":server:lb-tablet:alert", payload)
end

