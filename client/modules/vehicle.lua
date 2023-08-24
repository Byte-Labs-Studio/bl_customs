local Vehicle = {}
local Store = require 'client.modules.store'
local createCam = require 'client.modules.camera'.createCam
local getModsNum = GetNumVehicleMods
local getModText = GetModTextLabel
local getModLabel = GetLabelText

local lib_table = lib.table
local table_deepcopy = lib_table.deepclone
local table_contain = lib_table.contains
local table_matches = lib_table.matches
local table_clone = table.clone
local table_insert = table.insert

local colorData = Store.colors.color
local currentData = Store.data

function Vehicle.getMods(type, wheelData)
    local mods = {}
    local mod = wheelData or Store.decals[type]
    local vehicle = cache.vehicle
    local isWheel = type == 23

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

    if mod.data then
        local data = mod.data
        mods = table_deepcopy(data.mods)
        local currentMod = data.getter(vehicle)
        currentData.stored.currentMod = currentMod
        for _,v in ipairs(mods) do
            if v.id == currentMod then
                v.selected = true
                v.applied = true
            end
        end
        return mods
    end

    local id = 1
    local modType = isWheel and 23 or mod.id
    local modsNum = getModsNum(vehicle, modType)
    local priceStep = mod.price / modsNum
    local currentMod = GetVehicleMod(vehicle, modType)
    currentData.stored.currentMod = currentMod

    for i = 0, modsNum - 1 do
        local text = getModText(vehicle, modType, i)
        local label = getModLabel(text)
        local index = isWheel and 0 or currentMod
        local applied = i == index or nil
        mods[id] = {label = (text ~= 'NULL' and label or text), id = i, selected = applied, applied = not isWheel and applied, price = math.floor((priceStep * id) + 0.5)}
        id += 1
    end

    if wheelData then return mods end

    local applied = currentMod == -1 or nil
    table_insert(mods, 1, {label = 'Default', id = -1, selected = applied, applied = applied})
    return mods
end

----decals
function Vehicle.getVehicleDecals()
    local decals = {}
    local id = 1
    local modType = currentData.modType
    local found = false
    for mod,type in pairs(Store.decals) do
        if mod == 'Plate Index' or getModsNum(cache.vehicle, type.id) ~= 0 then
            local appliedMod = mod == modType
            if appliedMod then found = true end
            decals[id] = {id = mod, selected = appliedMod or nil}
            id += 1
        end
    end
    decals[1].selected = not found and true or decals[1].selected
    return decals
end

----wheels

function Vehicle.getVehicleWheels()
    local wheels = {}
    local wheelsData = Store.wheels
    local data = GetVehicleClass(cache.vehicle) == 8 and {Bike = { id = 6, price = 2000 }} or wheelsData

    local id = 1
    for mod in pairs(data) do
        wheels[id] = {id = mod}
        id += 1
    end
    
    local customTyres = IsToggleModOn(cache.vehicle, 20)
    currentData.stored.customTyres = customTyres
    table_insert(wheels, 1, {price = 100, label = 'Custom Tyres', id = -1, selected = true, toggle = true, applied = customTyres})
    return wheels
end

function Vehicle.getVehicleWheelsType(type)
    local mod = Store.wheels[type]
    local entity = cache.vehicle
    currentData.stored.currentWheelType = GetVehicleWheelType(entity)
    SetVehicleWheelType(entity, mod.id)
    createCam(Store.cams.wheels)
    return Vehicle.getMods(23, mod)
end


----colors 

function Vehicle.getVehicleColors()
    local colors = {}
    local id = 1
    for _, mod in ipairs(Store.colors.types) do
        colors[id] = {id = mod, selected = id == 1 or nil}
        id += 1
    end
    return colors
end

local function getPaintTypes()
    local paint = {}
    local id = 1
    for _, mod in ipairs(Store.colors.paints) do
        paint[id] = {id = mod, selected = id == 1 or nil}
        id += 1
    end
    return paint
end

--modIndex

local function getAllColors()
    local mergedTable = {}
    local id = 1
    for _, subTable in pairs({colorData.Chrome, colorData.Matte, colorData.Metal, colorData.Metallic}) do
        for _, element in ipairs(subTable) do
            mergedTable[id] = element
            id+=1
        end
    end
    table_insert(mergedTable, 1, {label = 'Default', id = -1, selected = true})
    return mergedTable
end

local function getNeons()
    local entity = cache.vehicle
    local currentMod = IsVehicleNeonLightEnabled
    local data = table_deepcopy(colorData.Neons)

    for _,v in ipairs(data) do
        if type(v.id) == "number" and currentMod(entity, v.id) then
            v.applied = true
        end
    end
    return data
end

local function getXenonColor()
    local currentMod = GetVehicleXenonLightsColor(cache.vehicle)
    local data = table_deepcopy(colorData.Xenon)

    for _,v in ipairs(data) do
        if v.id == currentMod then
            v.selected = true
            v.applied = true
        end
    end
    return data
end

local function getTyreSmokes()
    local currentMod = {GetVehicleTyreSmokeColor(cache.vehicle)}
    local data = table_deepcopy(colorData.TyreSmoke)

    for _,v in ipairs(data) do
        v.id = _
        if table_matches(v.rgb, currentMod) then
            v.selected = true
            v.applied = true
        end
    end
    return data
end

local function getWindowsTint()
    local currentMod = GetVehicleWindowTint(cache.vehicle)
    local data = table_deepcopy(colorData.WindowsTint)

    for _,v in ipairs(data) do
        if v.id == currentMod then
            v.selected = true
            v.applied = true
        end
    end
    return data
end

local function getPaintType(modType)
    local colorType = currentData.modType

    if not table_contain(Store.colors.paints, modType) then return false end
    local colorTypeData = colorData[modType] and table_clone(colorData[modType])
    if not colorTypeData then return end
    local colorPrimary, colorSecondary = GetVehicleColours(cache.vehicle)
    local currentPaint = colorType == 'Primary' and colorPrimary or colorSecondary
    table_insert(colorTypeData, 1, {label = 'Default', id = currentPaint, selected = true, applied = true})
    currentData.stored.currentMod = currentPaint
    return colorTypeData
end

function Vehicle.getVehicleColorsTypes(modType)
    local isPaintType = getPaintType(modType) --get paint type such Metallic/Matte/Metal/Chrome
    if isPaintType then return isPaintType end


    local selector = {
        Primary = getPaintTypes, -- primary
        Secondary = getPaintTypes, -- secondary
        Interior = getAllColors,
        Pearlescent = getAllColors,
        Dashboard = function()
            createCam(Store.cams.dashboard)
            return getAllColors()
        end,
        Neon = getNeons,
        ['Tyre Smoke'] = getTyreSmokes,
        ['Xenon Lights'] = getXenonColor,
        ['Neon Colors'] = getAllColors,
        ['Window Tint'] = getWindowsTint,
        Wheels = function()
            createCam(Store.cams.wheels)
            return getAllColors()
        end,
    }
    return selector[modType] and selector[modType]()
end

-- mod index application

function Vehicle.applyInteriorColor(menu)
    SetVehicleInteriorColor(cache.vehicle, menu.modIndex)
end

function Vehicle.applyExtraColor(menu)
    local entity = cache.vehicle
    local pearlescentColor, wheelColor = GetVehicleExtraColours(entity)
    pearlescentColor = menu.colorType == 'Pearlescent' and menu.modIndex or pearlescentColor
    wheelColor = menu.colorType == 'Wheels' and menu.modIndex or wheelColor
    SetVehicleExtraColours(entity, pearlescentColor, wheelColor)
end

function Vehicle.applyDashboardColor(menu)
    SetVehicleDashboardColor(cache.vehicle, menu.modIndex)
end

function Vehicle.enableNeonColor(menu)
    SetVehicleNeonLightEnabled(cache.vehicle, menu.modIndex, menu.toggle)
end

function Vehicle.toggleCustomTyres(toggle)
    currentData.stored.customTyres = toggle
    ToggleVehicleMod(cache.vehicle, 20, toggle)
end

function Vehicle.applyWindowsTint(menu)
    SetVehicleWindowTint(cache.vehicle, menu.modIndex)
end

function Vehicle.applyNeonColor(menu)
    SetVehicleNeonLightsColor_2(cache.vehicle, menu.modIndex)
end


function Vehicle.applyTyreSmokeColor(menu)
    local color = Store.colors.color.TyreSmoke[menu.modIndex]
    if not color then return end
    local entity = cache.vehicle
    ToggleVehicleMod(entity, 20, true)
    SetVehicleTyreSmokeColor(entity, color.rgb[1], color.rgb[2], color.rgb[3])
end

function Vehicle.applyXenonLightsColor(menu)
    local entity = cache.vehicle
    ToggleVehicleMod(entity, 22, true)
    SetVehicleXenonLightsColor(entity, menu.modIndex)
end

function Vehicle.applyVehicleColor(menu)
    local entity = cache.vehicle
    local colorPrimary , colorSecondary = GetVehicleColours(entity)
    local primaryColor = menu.colorType == 'Primary' and menu.modIndex or colorPrimary
    local secondaryColor = menu.colorType == 'Secondary' and menu.modIndex or colorSecondary
    SetVehicleColours(entity, primaryColor, secondaryColor)
end

return Vehicle