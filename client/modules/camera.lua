local Camera = {}
local cam
local mainCam
local shouldUpdate = false
local camDistance = 0.5
local angleY = 0.0
local angleZ = 0.0
local math_clamp = math.clamp
local math_cos = math.cos
local math_sin = math.sin
local targetCoords

local function cos(degrees)
    return math_cos(degrees * math.pi / 180)
end

local function sin(degrees)
    return math_sin(degrees * math.pi / 180)
end

local function getOffCoords()
    return vec3(
        ((cos(angleZ) * cos(angleY)) + (cos(angleY) * cos(angleZ))) / 2 * camDistance,
        ((sin(angleZ) * cos(angleY)) + (cos(angleY) * sin(angleZ))) / 2 * camDistance,
        ((sin(angleY))) * camDistance
    )
end

local function SetCamPosition(mouseX, mouseY)
    if not targetCoords then return end
    local mouseX = mouseX or 0.0 --and mouseX * 5.0 or 0.0
    local mouseY = mouseY or 0.0 --and mouseY * 5.0 or 0.0

    angleZ = angleZ - mouseX -- around Z axis (left / right)
    angleY = angleY + mouseY -- up / down
    angleY = math_clamp(angleY, 0.0, 89.0) -- >=90 degrees will flip the camera, < 0 is underground

    local offset = getOffCoords()
    local camPos = vec3(targetCoords.x + offset.x, targetCoords.y + offset.y, targetCoords.z + offset.z)
    SetCamCoord(cam, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(cam, targetCoords.x, targetCoords.y, targetCoords.z)
end

function Camera.handleNuiCamera(data)
    local coord = data.coords

    if data.type == 'wheel' then
        local distance = camDistance + coord
        if distance < 0.1 then return end
        if distance > 7.0 then return end
        camDistance = distance
        SetCamPosition()
    else
        SetCamPosition(coord.x, coord.y)
    end
end

function Camera.destroyCam()
    RenderScriptCams(false, true, 1000)
    DestroyCam(cam, false)
    DestroyCam(mainCam, false)
    cam = nil
    mainCam = nil
end

function Camera.switchCam()
    if not shouldUpdate then return end
    local entity = cache.vehicle
    for i = 0, 5 do
        SetVehicleDoorShut(entity, i, false) -- will open every door from 0-5
    end
    shouldUpdate = false
    SetCamActiveWithInterp(mainCam, cam, 400)
    Wait(400)
    local entityPos = GetEntityCoords(entity)
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

RegisterCommand('getheading', function()
    print(angleZ)
    print(angleY)
end)

---comment
---@param data {off: vector3, angle: vector2}
function Camera.createCam(data)
    local entityPos = GetEntityCoords(cache.vehicle)
    local offset = data.off
    local coords = vector3(entityPos.x + offset.x, entityPos.y + offset.y, entityPos.z + offset.z)
    targetCoords = coords
    angleZ, angleY = data.angle and data.angle.x or angleZ, data.angle and data.angle.y or angleY
    cam = cam or CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 50.0, false, 0)
    
    SetCamPosition()
    SetCamActiveWithInterp(cam, mainCam, 500, true, true)
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