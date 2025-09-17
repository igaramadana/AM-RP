local spawnedProps = {}

for k, v in pairs(Config.item) do
    spawnedProps[v.itemname] = {
        onSpawn = false,
        HandObject = nil
    }

    RegisterNetEvent(v.itemname .. ':SPAWN')
    AddEventHandler(v.itemname .. ':SPAWN', function(CurrentZone)
        local state = spawnedProps[v.itemname]
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if not state.onSpawn then
            local hash = GetHashKey(CurrentZone.Model)
            lib.requestModel(hash) 

            state.HandObject = CreateObject(hash, coords.x, coords.y, coords.z, true, true, true)
            AttachEntityToEntity(
                state.HandObject,
                ped,
                GetPedBoneIndex(ped, CurrentZone.Bone),
                CurrentZone.xPos, CurrentZone.yPos, CurrentZone.zPos,
                CurrentZone.xRot, CurrentZone.yRot, CurrentZone.zRot,
                true, true, false, true, 0, true
            )
            state.onSpawn = true
            SetModelAsNoLongerNeeded(hash)
        else
            if state.HandObject then
                DeleteObject(state.HandObject)
                state.HandObject = nil
            end
            state.onSpawn = false
        end
    end)
end
