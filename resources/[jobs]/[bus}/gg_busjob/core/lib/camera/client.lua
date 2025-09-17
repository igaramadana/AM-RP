gg.camera = gg.camera or {}

local camera = nil

gg.camera.createCameraNPC = function(entity, offset)
    local offset = offset or {0.0,0.0,0.0}

    if not DoesEntityExist(entity) then
        print("Entity does not exist.")
        return
    end

    local coords = GetOffsetFromEntityInWorldCoords(entity, -3.0 + offset[1], 0.75 + offset[1], 1.75 + offset[1])
    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    SetCamCoord(cam, coords.x, coords.y, coords.z)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(entity) - 180, 0)
    SetCamFov(cam, 60.0)
    camera = cam
end

gg.camera.createCameraCoord = function(coord, offset, rotation)
    if not coord or type(coord) ~= "table" then return end

    local offset = offset or {0.0, 0.0, 0.0}
    local rotation = rotation or {0.0, 0.0, 0.0}

    -- Apply heading rotation to offset
    local heading = coord[4] or 0.0
    local hRad = math.rad(heading)
    local ox, oy = offset[1] or 0.0, offset[2] or 0.0
    local rx = ox * math.cos(hRad) - oy * math.sin(hRad)
    local ry = ox * math.sin(hRad) + oy * math.cos(hRad)

    local camX = coord[1] + rx
    local camY = coord[2] + ry
    local camZ = coord[3] + (offset[3] or 0.0)

    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    SetCamCoord(cam, camX, camY, camZ)
    SetCamRot(cam, rotation[1], rotation[2], rotation[3], 0)
    SetCamFov(cam, 60.0)

    camera = cam
end




gg.camera.removeCamera = function()
    DestroyCam(camera, true)
    RenderScriptCams(false, false, 1)
    camera = nil
end