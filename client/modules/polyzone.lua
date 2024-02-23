local lib_zones = lib.zones
local config = require 'config'
local locations = config.locations
local group = config.group
local core = Framework.core
local polyzone = {
    isNear = false
}

---comment
local function isAllowed(job)
    local name = job.name
    local grade = group[name]
    return grade and grade <= job.grade.name
end

---@param custom {locData: vector4}
local function onEnter(custom)
    if group and type(group) == 'table' then
        local playerData = core.getPlayerData()
        if not isAllowed(playerData.job) then return end
    end
    lib.showTextUI('[G] - Customs')
    polyzone.pos = custom.locData
    polyzone.isNear = true
end

local function onExit()
    lib.hideTextUI()
    polyzone.pos = nil
    polyzone.isNear = false
end


CreateThread(function()
    for _, v in ipairs(locations) do
        local pos = v.pos
        local blip_data = v.blip

        lib_zones.box({
            coords = pos.xyz,
            size = vec3(8, 8, 6),
            rotation = pos.w,
            onEnter = onEnter,
            onExit = onExit,
            locData = vector4(pos.x, pos.y, pos.z, pos.w)
        })

        if blip_data then
            local sprite, color, shortRange, label in blip_data
            local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
            SetBlipDisplay(blip, 4)
            SetBlipSprite(blip, sprite)
			SetBlipScale(blip, 1.0)
            SetBlipColour(blip, color)
			SetBlipAsShortRange(blip, shortRange or false)

            BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(label)
			EndTextCommandSetBlipName(blip)
        end
    end
end)

return polyzone
