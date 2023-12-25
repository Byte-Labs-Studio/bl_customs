local lib_zones = lib.zones
local locations = require 'config'.locations
local polyzone = {
    isNear = false
}

---comment
---@param custom {locData: vector4}
local function onEnter(custom)
    lib.showTextUI('[G] - Customs')
    polyzone.pos = custom.locData
    polyzone.isNear = true
end

local function onExit()
    lib.hideTextUI()
    polyzone.pos = nil
    polyzone.isNear = false
end

CreateThread(function ()
    for _, v in ipairs(locations) do
        lib_zones.box({
            coords = v.pos.xyz,
            size = vec3(8, 8, 6),
            rotation = v.pos.w,
            onEnter = onEnter,
            onExit = onExit,
            locData = vector4(v.pos.x, v.pos.y, v.pos.z, v.vehHeading)
        })
    end
end)

return polyzone