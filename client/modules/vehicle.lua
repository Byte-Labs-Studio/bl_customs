local Vehicle = {}
local createCam = require 'client.modules.camera'.createCam
local getModsNum = GetNumVehicleMods
local getModText = GetModTextLabel
local getModLabel = GetLabelText
local lib_table = lib.table
local table_deepcopy = lib_table.deepclone
local table_contain = lib_table.contains
local table_matches = lib_table.matches
local table_insert = table.insert
local colors = require 'data.colors'
local colorData = colors.data

---@alias mods {label: string, id: number, selected?: boolean, applied?: boolean, price?: number}

---@param type number
---@param wheelData {id: number, price: number}
---@return mods[]

local function modCount(vehicle, id)
    if id == 24 then
        return GetVehicleLiveryCount(vehicle)
    end
    return getModsNum(vehicle, id)
end


local function isVehicleBlacklist(entity, blacklist)
    local modelName = GetEntityArchetypeName(entity)
    for _, v in ipairs(blacklist) do
        if modelName == v then
            return true
        end
    end
    return false
end

function Vehicle.getMods(type, wheelData)
    local zone = require 'client.modules.polyzone'
    local store = require 'client.modules.store'
    local mods = {}
    local isWheel = type == 23
    local mod = isWheel and wheelData or require 'data.decals'[type]
    local vehicle = cache.vehicle

    if not isWheel then
        local camera = mod.cam
        if camera then
            createCam(camera)
            if camera.door then
                SetVehicleDoorOpen(vehicle, camera.door, false, false)
                SetVehicleActiveForPedNavigation(vehicle, false)
            end
        end
    end

    local data = mod.data
    if data then
        mods = table_deepcopy(data.mods)
        local currentMod = data.getter(vehicle)
        store.stored.currentMod = currentMod
        for _, v in ipairs(mods) do
            if v.id == currentMod then
                v.selected = true
                v.applied = true
            end
        end
        return mods
    end

    local id = 1
    local modType = isWheel and 23 or mod.id
    local modsNum = modCount(vehicle, modType) or getModsNum(vehicle, modType)
    local currentMod = GetVehicleMod(vehicle, modType)

    for i = 0, modsNum - 1 do
        local text = getModText(vehicle, modType, i)
        local label = getModLabel(text)
        local index = isWheel and 0 or currentMod
        local applied = i == index or nil
        local customLabel = mod.labels and mod.labels[i]
        mods[id] = {
            label = customLabel and customLabel.label or (text ~= 'NULL' and label or text),
            id = i,
            selected = applied,
            applied = not isWheel and applied,
            price = not zone.free and (customLabel and customLabel.price or math.floor((mod.price / modsNum * id) + 0.5)) or 0
        }
        id += 1
    end

    store.stored.currentMod = currentMod
    if wheelData then return mods end

    local applied = currentMod == -1 or nil
    table_insert(mods, 1, { label = 'Default', id = -1, selected = applied, applied = applied })
    return mods
end

----decals
---comment
---@return mods[]
function Vehicle.getVehicleDecals()
    local decals = {}
    local count = 1
    local modType = require 'client.modules.store'.modType
    local zone = require 'client.modules.polyzone'

    local found = false
    local vehicle = cache.vehicle

    for mod, modData in pairs(require 'data.decals') do
        local blacklist, id, toggle in modData
        if (not blacklist or (not isVehicleBlacklist(vehicle, blacklist))) then

            local add = false
            local appliedMod = mod == modType
            if appliedMod then found = true end
            
            local modCard = {
                id = mod,
                selected = appliedMod or nil
            }

            if modCount(vehicle, id) > 0 then
                add = true
            elseif toggle then
                modCard.id = id
                modCard.label = mod
                modCard.price = not zone.free and modData.price or 0
                modCard.toggle = true
                modCard.applied = IsToggleModOn(vehicle, id)
                add = true
            end
            if add then
                decals[count] = modCard
                count += 1
            end
        end
    end

    decals[1].selected = not found and true or decals[1].selected

    return decals
end

----wheels
---@return mods[]
function Vehicle.getVehicleWheels()
    local wheels = {}
    local wheelsData = require 'data.wheels'
    local zone = require 'client.modules.polyzone'
    local data = GetVehicleClass(cache.vehicle) == 8 and { Bike = { id = 6, price = not zone.free and 2000 or 0 } } or wheelsData

    local id = 1
    for mod in pairs(data) do
        wheels[id] = { id = mod }
        id += 1
    end

    local customTyres = IsToggleModOn(cache.vehicle, 20)
    require 'client.modules.store'.stored.customTyres = customTyres
    table_insert(wheels, 1, {price = not zone.free and 100 or 0, label = 'Custom Tyres', id = 20, selected = true, toggle = true, applied = customTyres })
    return wheels
end

---comment
---@param type string
---@return mods[]
function Vehicle.getVehicleWheelsType(type)
    local mod = require 'data.wheels'[type]
    local entity = cache.vehicle
    require 'client.modules.store'.stored.currentWheelType = GetVehicleWheelType(entity)
    SetVehicleWheelType(entity, mod.id)
    createCam(colors.cam.wheels)
    return Vehicle.getMods(23, mod)
end

----colors

---@return mods[]
function Vehicle.getVehicleColors()
    local colorsData = {}
    local id = 1
    for _, mod in ipairs(colors.types) do
        colorsData[id] = { id = mod, selected = id == 1 or nil }
        id += 1
    end
    return colorsData
end

---@return mods[]
local function getPaintTypes()
    local paint = {}
    local id = 1
    for _, mod in ipairs(colors.paints) do
        paint[id] = { id = mod, selected = id == 1 or nil }
        id += 1
    end
    return paint
end

--modIndex


---@return mods[]
local function getAllColors()
    local mergedTable = {}
    local id = 1
    local zone = require 'client.modules.polyzone'

    for _, subTable in pairs(table_deepcopy({ colorData.Chrome, colorData.Matte, colorData.Metal, colorData.Metallic, colorData.Chameleon })) do
        for _, element in ipairs(subTable) do
            if zone.free then
                element.price = 0
            end
            mergedTable[id] = element
            id += 1
        end
    end
    table_insert(mergedTable, 1, { label = 'Default', id = -1, selected = true })
    return mergedTable
end


---@return mods[]
local function getNeons()
    local entity = cache.vehicle
    local currentMod = IsVehicleNeonLightEnabled
    local data = table_deepcopy(colorData.Neons)

    for _, v in ipairs(data) do
        if type(v.id) == "number" and currentMod(entity, v.id) then
            v.applied = true
        end
    end
    return data
end

local function checkSelected(data, currentMod)
    local isSelected = false
    for _, v in ipairs(data) do
        if v.id == currentMod then
            v.selected = true
            v.applied = true
            isSelected = true
        end
    end
    if not isSelected then
        data[1].selected = true
        data[1].applied = true
    end
    return data
end

---@return mods[]
local function getXenonColor()
    return checkSelected(table_deepcopy(colorData.Xenon), GetVehicleXenonLightsColor(cache.vehicle))
end


---@return mods[]
local function getTyreSmokes()
    local currentMod = { GetVehicleTyreSmokeColor(cache.vehicle) }
    local data = table_deepcopy(colorData.TyreSmoke)

    for _, v in ipairs(data) do
        v.id = _
        if table_matches(v.rgb, currentMod) then
            v.selected = true
            v.applied = true
        end
    end
    return data
end

---@return mods[]
local function getWindowsTint()
    return checkSelected(table_deepcopy(colorData.WindowsTint), GetVehicleWindowTint(cache.vehicle))
end

---comment
---@param modType string
---@return mods[]|nil
local function getPaintType(modType)
    local store = require 'client.modules.store'
    local zone = require 'client.modules.polyzone'

    local colorType = store.modType

    if not table_contain(colors.paints, modType) then return false end
    local colorTypeData = colorData[modType] and table_deepcopy(colorData[modType])
    if not colorTypeData then return end
    local colorPrimary, colorSecondary = GetVehicleColours(cache.vehicle)
    local currentPaint = colorType == 'Primary' and colorPrimary or colorSecondary
    if zone.free then
        for _,v in ipairs(colorTypeData) do
            v.price = 0
        end
    end
    table_insert(colorTypeData, 1, { label = 'Default', id = currentPaint, selected = true, applied = true })
    store.stored.currentMod = currentPaint
    return colorTypeData
end

---@param modType string
---@return mods[]|nil
function Vehicle.getVehicleColorsTypes(modType)
    local isPaintType = getPaintType(modType) --get paint type such Metallic/Matte/Metal/Chrome/Chameleon
    if isPaintType then return isPaintType end

    local cam = colors.cam
    local selector = {
        Primary = getPaintTypes,   -- primary
        Secondary = getPaintTypes, -- secondary
        Interior = getAllColors,
        Pearlescent = getAllColors,
        Dashboard = function()
            createCam(cam.dashboard)
            return getAllColors()
        end,
        Neon = getNeons,
        ['Tyre Smoke'] = getTyreSmokes,
        ['Xenon Lights'] = getXenonColor,
        ['Neon Colors'] = getAllColors,
        ['Window Tint'] = getWindowsTint,
        Wheels = function()
            createCam(cam.wheels)
            return getAllColors()
        end,
    }
    return selector[modType] and selector[modType]()
end

-- mod index application

---@alias applyMod {modIndex: number, toggle?: boolean}

---@param menu applyMod
function Vehicle.applyInteriorColor(menu)
    SetVehicleInteriorColor(cache.vehicle, menu.modIndex)
end

---@param menu applyMod
function Vehicle.applyExtraColor(menu)
    local entity = cache.vehicle
    local pearlescentColor, wheelColor = GetVehicleExtraColours(entity)
    pearlescentColor = menu.colorType == 'Pearlescent' and menu.modIndex or pearlescentColor
    wheelColor = menu.colorType == 'Wheels' and menu.modIndex or wheelColor
    SetVehicleExtraColours(entity, pearlescentColor, wheelColor)
end

---@param menu applyMod
function Vehicle.applyDashboardColor(menu)
    SetVehicleDashboardColor(cache.vehicle, menu.modIndex)
end

---@param menu applyMod
function Vehicle.enableNeonColor(menu)
    SetVehicleNeonLightEnabled(cache.vehicle, menu.modIndex, menu.toggle)
end

---@param menu applyMod
function Vehicle.applyWindowsTint(menu)
    SetVehicleWindowTint(cache.vehicle, menu.modIndex)
end

---@param menu applyMod
function Vehicle.applyNeonColor(menu)
    SetVehicleNeonLightsColor_2(cache.vehicle, menu.modIndex)
end

---@param menu applyMod
function Vehicle.applyTyreSmokeColor(menu)
    local color = colorData.TyreSmoke[menu.modIndex]
    if not color then return end
    local entity = cache.vehicle
    ToggleVehicleMod(entity, 20, true)
    SetVehicleTyreSmokeColor(entity, color.rgb[1], color.rgb[2], color.rgb[3])
end

---@param menu applyMod
function Vehicle.applyXenonLightsColor(menu)
    local entity = cache.vehicle
    ToggleVehicleMod(entity, 22, true)
    SetVehicleXenonLightsColor(entity, menu.modIndex)
end

---@param menu applyMod
function Vehicle.applyVehicleColor(menu)
    local entity = cache.vehicle
    local colorPrimary, colorSecondary = GetVehicleColours(entity)
    local primaryColor = menu.colorType == 'Primary' and menu.modIndex or colorPrimary
    local secondaryColor = menu.colorType == 'Secondary' and menu.modIndex or colorSecondary
    SetVehicleColours(entity, primaryColor, secondaryColor)
end

return Vehicle
