local Camera = {}
local cam
local mainCam
local shouldUpdate = false

function Camera.destroyCam()
    RenderScriptCams(false, true, 1000)
    DestroyCam(cam, false)
    DestroyCam(mainCam, false)
    cam = nil
    mainCam = nil
end

function Camera.switchCam()
    if not shouldUpdate then return end
    for i = 0, 5 do
        SetVehicleDoorShut(cache.vehicle, i, false) -- will open every door from 0-5
    end
    shouldUpdate = false
    SetCamActiveWithInterp(mainCam, cam, 400)
    Wait(400)
    local entityPos = GetEntityCoords(cache.vehicle)
    SetCamCoord(cam, entityPos.x + -3.200000, entityPos.y + 3.400000, entityPos.z + 2.100000)
    SetCamRot(cam, -19.500000, -0.000000, 219.000000, 0)
end

function Camera.createMainCam()
    mainCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local entityPos = GetEntityCoords(cache.vehicle)

    RenderScriptCams(true, true, 1000)
    SetCamCoord(mainCam, entityPos.x + -3.200000, entityPos.y + 3.400000, entityPos.z + 2.100000)
    SetCamRot(mainCam, -19.500000, -0.000000, 219.000000, 0)
end

---comment
---@param data {off: vector3, rot: vector3}
function Camera.createCam(data)
    cam = cam or CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local entityPos = GetEntityCoords(cache.vehicle)

    SetCamCoord(cam, entityPos.x + data.off.x, entityPos.y + data.off.y, entityPos.z + data.off.z)
    SetCamRot(cam, data.rot.x, data.rot.y, data.rot.z, 0)
    SetCamActiveWithInterp(cam, mainCam, 500)
    shouldUpdate = true
end

-- to edit parts cams 

--[[local function SetCamEdit(bonePos)
    local offsetEnabled = false
    local off = GetCamCoord(cam)
    local rot = GetCamRot(cam, 0)

    local offX, offY, offZ = off.x, off.y, off.z
    local rotX, rotY, rotZ = rot.x, rot.y, rot.z

    while cam do
        Wait(0)

        if IsControlJustPressed(0, 166) then --f5
            offsetEnabled = not offsetEnabled
            local string = offsetEnabled and 'enabled' or 'disabled'
            print('Offset = ' .. string)
        end
        if IsControlPressed(0, 172) then --up
            if offsetEnabled then
                offY -= 0.1
                offX -= 0.1
                SetCamCoord(cam, offX, offY, offZ)
            else
                --rotY += 0.5
                rotX -= 0.5
                SetCamRot(cam, rotX, rotY, rotZ, 0)
            end
        elseif IsControlPressed(0, 173) then -- down
            if offsetEnabled then
                offX += 0.1
                offY += 0.1
                SetCamCoord(cam, offX, offY, offZ)
            else
                --rotY -= 0.5
                rotX += 0.5
                SetCamRot(cam, rotX, rotY, rotZ, 0)
            end
        elseif IsControlPressed(0, 174) then -- left
            if offsetEnabled then
                offX += 0.1
                offY -= 0.1
                SetCamCoord(cam, offX, offY, offZ)
            end
        elseif IsControlPressed(0, 175) then -- right
            if offsetEnabled then
                offX -= 0.1
                offY += 0.1
                SetCamCoord(cam, offX, offY, offZ)
            end
        elseif IsControlPressed(0, 208) then -- page up 
            if offsetEnabled then
                offZ += 0.1
                SetCamCoord(cam, offX, offY, offZ)
            else
                rotZ += 0.5
                SetCamRot(cam, rotX, rotY, rotZ, 0)
            end
        elseif IsControlPressed(0, 207) then -- page down
            if offsetEnabled then
                offZ -= 0.1
                SetCamCoord(cam, offX, offY, offZ)
            else
                rotZ -= 0.5
                SetCamRot(cam, rotX, rotY, rotZ, 0)
            end
        end


        if IsControlJustPressed(0, 170) then --f5
            print(vec3(rotX, rotY, rotZ), vec3(offX - bonePos.x, offY - bonePos.y , offZ - bonePos.z) )
        end
    end
end
]]
--RegisterCommand('editCam', function(f, args)
--    local Store = require 'config'
--    Camera.createMainCam()
--    Camera.createCam(Store.decals[args[1]].cam)
--    SetCamEdit(GetEntityCoords(cache.vehicle))
--end, false)

return Camera