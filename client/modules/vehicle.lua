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
local store = require 'client.modules.store'

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

---comment
---@param modType string
---@return mods[]|nil
local function getPaintType(modType)
    local zone = require 'client.modules.polyzone'
    local colors = require 'data.colors'
    local colorType = store.modType

    if not table_contain(colors.paints, modType) then return false end

    local colorsData = colors.data[modType]
    local colorTypeData = colorsData and table_deepcopy(colorsData)
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

function Vehicle.getMod(type, wheelData)
    local zone = require 'client.modules.polyzone'
    local stored = store.stored
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

    local onClick = mod.onClick
    if onClick then
        local success, result = pcall(onClick, vehicle, stored)
        return success and result or {}
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

    stored.currentMod = currentMod
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
    local modType = store.modType
    local currentMenu = store.menu
    local zone = require 'client.modules.polyzone'

    local found = false
    local vehicle = cache.vehicle

    for mod, modData in pairs(require 'data.decals') do
        local blacklist, id, toggle, menuId, custom, canInteract in modData
        local canInteractMenu = true
        if canInteract then
            local success, resp = pcall(canInteract, vehicle)
            if not success or not resp then
                canInteractMenu = false
            end
        end

        if canInteractMenu and ((not blacklist or (not isVehicleBlacklist(vehicle, blacklist))) and menuId == currentMenu) then
            local add = false
            local appliedMod = mod == modType
            if appliedMod then found = true end
            
            local modCard = {
                id = mod,
                selected = appliedMod or nil
            }

            if custom or modCount(vehicle, id) > 0 then
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

    if decals[1] then
        decals[1].selected = not found and true or decals[1].selected
    end

    return decals
end

----wheels
---@return mods[]
function Vehicle.getVehicleWheels()
    local wheels = {}
    local vehicle = cache.vehicle
    local wheelsData = require 'data.wheels'
    local zone = require 'client.modules.polyzone'
    local data = GetVehicleClass(vehicle) == 8 and { Bike = { id = 6, price = not zone.free and 2000 or 0 } } or wheelsData

    local count = 1
    for mod, modData in pairs(data) do
        local blacklist, id, toggle, price in modData
        if (not blacklist or (not isVehicleBlacklist(vehicle, blacklist))) then
            price = not zone.free and price or 0
            if toggle then
                modData.applied = IsToggleModOn(vehicle, id)
                wheels[count] = modData
                if id == 20 then
                    store.stored.customTyres = modData.applied
                end
            else
                wheels[count] = { id = type(mod) == 'string' and mod or id }
            end
            count += 1
        end
    end

    return wheels
end

---comment
---@param type string
---@return mods[]
function Vehicle.getVehicleWheelType(type)
    local mod = require 'data.wheels'[type]
    local entity = cache.vehicle
    store.stored.currentWheelType = GetVehicleWheelType(entity)
    SetVehicleWheelType(entity, mod.id)
    createCam(require 'data.colors'.functions.Wheels.cam)
    return Vehicle.getMod(23, mod)
end

----colors

---@return mods[]
function Vehicle.getVehicleColors()
    local colorsData = {}
    local id = 1
    for _, mod in ipairs(require 'client.modules.filter'.colorTypes) do
        colorsData[id] = { id = mod, selected = id == 1 or nil }
        id += 1
    end
    return colorsData
end

---@return mods[]
function Vehicle.getPaintTypes()
    local paint = {}
    local id = 1
    for _, mod in ipairs(require 'data.colors'.paints) do
        paint[id] = { id = mod, selected = id == 1 or nil }
        id += 1
    end
    return paint
end

--modIndex

---@return mods[]
function Vehicle.getAllColors()
    local colorData = require 'data.colors'.data
    local mergedTable = {}
    local id = 1
    local zone = require 'client.modules.polyzone'

    for _, subTable in pairs(table_deepcopy({ colorData.Chrome, colorData.Matte, colorData.Metal, colorData.Metallic, colorData.Chameleon })) do
        for _, element in ipairs(subTable) do
            element.price = not zone.free and element.price or 0
            mergedTable[id] = element
            id += 1
        end
    end
    table_insert(mergedTable, 1, { label = 'Default', id = -1, selected = true })
    return mergedTable
end


---@return mods[]
function Vehicle.getNeons()
    local entity = cache.vehicle
    local currentMod = IsVehicleNeonLightEnabled
    local colorData = require 'data.colors'.data
    local data = table_deepcopy(colorData.Neons)

    for _, v in ipairs(data) do
        if type(v.id) == "number" and currentMod(entity, v.id) then
            v.applied = true
        end
    end
    return data
end

---@return mods[]
function Vehicle.getXenonColor()
    local colorData = require 'data.colors'.data
    return checkSelected(table_deepcopy(colorData.Xenon), GetVehicleXenonLightsColor(cache.vehicle))
end

---@return mods[]
function Vehicle.getTyreSmokes()
    local colorData = require 'data.colors'.data
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
function Vehicle.getWindowsTint()
    local colorData = require 'data.colors'.data
    return checkSelected(table_deepcopy(colorData.WindowsTint), GetVehicleWindowTint(cache.vehicle))
end

---@param modType string
---@return mods[]|nil
function Vehicle.getVehicleColorTypes(modType)
    local isPaintType = getPaintType(modType) --get paint type such Metallic/Matte/Metal/Chrome/Chameleon
    if isPaintType then return isPaintType end

    local colors = require 'data.colors'
    local selector = colors.functions[modType]
    if not selector then return end
    if selector.cam then
        createCam(selector.cam)
    end
    return selector.onClick()
end

-- mod index application

---@alias applyColor {modIndex: number, colorType?: string}

---@param modIndex number
function Vehicle.applyExtraColor(vehicle, modIndex)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    pearlescentColor = store.modType == 'Pearlescent' and modIndex or pearlescentColor
    wheelColor = store.modType == 'Wheels' and modIndex or wheelColor
    SetVehicleExtraColours(vehicle, pearlescentColor, wheelColor)
end

---@param modIndex number
function Vehicle.applyTyreSmokeColor(vehicle, modIndex)
    local colorData = require 'data.colors'.data
    local color = colorData.TyreSmoke[modIndex]
    if not color then return end

    ToggleVehicleMod(vehicle, 20, true)
    SetVehicleTyreSmokeColor(vehicle, color.rgb[1], color.rgb[2], color.rgb[3])
end

---@param modIndex number
function Vehicle.applyXenonLightsColor(vehicle, modIndex)
    ToggleVehicleMod(vehicle, 22, true)
    SetVehicleXenonLightsColor(vehicle, modIndex)
end

---@param modIndex number
function Vehicle.applyVehicleColor(vehicle, modIndex)
    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local primaryColor = store.modType == 'Primary' and modIndex or colorPrimary
    local secondaryColor = store.modType == 'Secondary' and modIndex or colorSecondary
    SetVehicleColours(vehicle, primaryColor, secondaryColor)
end

return Vehicle
