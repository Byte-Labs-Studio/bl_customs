local vehicle = require 'client.modules.vehicle'
local poly = require 'client.modules.polyzone'
local camera = require 'client.modules.camera'
local lib_table = lib.table
local table_contain = lib_table.contains
local uiLoaded = false
local store = require 'client.modules.store'

---comment
---@param menu {type: number, index: number}
local function applyMod(menu)
    local storedData = store.stored
    local entity = cache.vehicle
    local type, index in menu

    if type == 51 then -- plate index
        SetVehicleNumberPlateTextIndex(entity, index)
    elseif type == 24 then
        SetVehicleLivery(entity, index)
    else
        SetVehicleMod(entity, type, index, storedData.customTyres)
    end

    --if menu.type == 14 then -- do a special thing if you selected a mod
    --end
end

---comment
---@param menu {colorType: string, modIndex: number}
local function applyColorMod(menu)
    local colors = require 'data.colors'
    local selector = colors.functions[menu.colorType]
    if not selector then return end
    selector.setter(menu)
end

local function triggerSelector(prop, ...)
    local category = require 'client.modules.filter'.named[store.menu]
    local selector = category and category.selector
    if not selector or not selector[prop] then return end
    return selector[prop](...)
end


---comment
---@param modIndex number
local function handleMod(modIndex)
    local modType = store.modType ~= 'none' and store.modType

    triggerSelector('onModSwitch', modType or store.menu, modIndex)
    if not modType then return end

    store.stored.appliedMods = { modType = modType, mod = modIndex }
    if store.menuType == 'paint' then
        applyColorMod({ colorType = modType, modIndex = modIndex })
    else
        local decals = require 'data.decals'
        local modType = store.menuType == 'wheels' and 23 or decals[modType] and decals[modType].id
        if not modType then return end
        applyMod({ type = modType, index = modIndex })
    end
end

local function resetLastMod()
    local storedData = store.stored
    if not storedData.boughtMods or storedData.appliedMods and storedData.appliedMods.modType ~= storedData.boughtMods.modType or storedData.appliedMods.mod ~= storedData.boughtMods.mod then
        if store.menuType == 'wheels' then
            SetVehicleWheelType(cache.vehicle, storedData.currentWheelType)
        end
        handleMod(storedData.currentMod)
    end
end

local function resetMenuData()
    local entity = cache.vehicle
    SetVehicleDoorsLocked(entity, 1)
    FreezeEntityPosition(entity, false)
    camera.destroyCam()
    resetLastMod()

    store.menu = 'main'
    store.menuType = ''
    store.modType = 'none'
    store.stored = {}
    store.preview = false
end

local function filterMods()
    local categories = lib.load('client.modules.filter').filtered

    local polyMods = poly.mods
    if not poly.mods then
        return categories
    end

    local filter = {}
    for _, data in ipairs(categories) do

        if polyMods then
            local add = false
            for _, mod in ipairs(poly.mods) do
                if data.important or data.id == mod then
                    add = true
                end
            end
    
            if add then
                filter[#filter+1] = data
            end
        end
    end
    
    return filter
end

---comment
---@param show boolean
local function showMenu(show)
    local SendReactMessage = require 'client.modules.utils'.SendReactMessage
    if not show then
        SendReactMessage('setVisible', false)
        resetMenuData()
        return
    end
    local entity = cache.vehicle
    if not poly.isNear or not entity then return end

    lib.waitFor(function()
        if uiLoaded then return true end
    end)

    SendReactMessage('setZoneMods', filterMods())
    SendReactMessage('setVisible', true)
    local coords = poly.pos
    SetVehicleEngineOn(entity, true, true, false)
    SetVehicleAutoRepairDisabled(entity, true)
    SetVehicleModKit(entity, 0)
    SetEntityHeading(entity, coords.w)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    FreezeEntityPosition(entity, true)
    SetVehicleDoorsLocked(entity, 4)
    camera.createMainCam()
end

---comment
---@param type string
---@return table|nil
local function getModType(type)
    return triggerSelector('childOnSelect', type)
end

---comment
---@param menu 'exit' | 'decals' | 'wheels' | 'paint' | 'preview'
---@return table|nil
local function handleMainMenus(menu)
    local category = require 'client.modules.filter'.named[menu]
    local selector = category and category.selector
    if not selector or not selector.onSelect then return end
    return selector.onSelect(category)
end

---comment
---@param data {type: string, isBack:boolean, clickedCard:string}
---@return table|nil
local function handleMenuClick(data)
    local cardType, clickedCard, isBack, menuType in data
    if clickedCard == nil then return end

    camera.switchCam()

    if isBack then
        resetLastMod()
    end
    if cardType == 'menu' then
        store.menu = clickedCard
        store.menuType = menuType or 'main'
        store.modType = 'none'
        return handleMainMenus(clickedCard)
    elseif cardType == 'modType' then
        local colorTypes = require 'client.modules.filter'.colorTypes
        store.modType = store.menuType == 'paint' and (table_contain(colorTypes, clickedCard) and clickedCard or store.modType) or clickedCard
    end

    return getModType(clickedCard)
end

---comment
---@param amount number
---@return boolean
local function removeMoney(amount)
    return poly.free or lib.callback.await('bl_customs:canAffordMod', false, amount)
end

local function buyMod(data)
    local storedData = store.stored

    if storedData.currentMod == data.mod then
        lib.notify({ title = 'Customs', description = 'You have this mod already', type = 'warning' })
        return false
    end
    if not removeMoney(data.price) then
        lib.notify({ title = 'Customs', description = 'You\'re broke', type = 'warning' })
        return false
    end
    storedData.boughtMods = { price = data.price, mod = data.mod, modType = store.modType }
    storedData.currentMod = data.mod
    return triggerSelector('childOnBuy', data.mod) or true
end

---comment
---@param data {price: number, toggle:boolean, mod:number}
---@return boolean|nil
local function toggleMod(data)
    if not removeMoney(data.price) then
        lib.notify({ title = 'Customs', description = 'You\'re broke', type = 'warning' })
        return false
    end
    local mod, toggle in data

    if store.modType == 'Neon' then
        vehicle.enableNeonColor({ modIndex = mod, toggle = toggle })
    else
        ToggleVehicleMod(cache.vehicle, mod, toggle)
    end

    return triggerSelector('childOnToggle', mod, toggle) and true
end

RegisterNUICallback('hideFrame', function(_, cb)
    showMenu(false)
    cb({})
end)

RegisterNUICallback('setMenu', function(menu, cb)
    local menuData = handleMenuClick(menu)
    cb(menuData or false)
end)

RegisterNUICallback('applyMod', function(modIndex, cb)
    handleMod(modIndex)
    cb(true)
end)

RegisterNUICallback('buyMod', function(data, cb)
    cb(buyMod(data))
end)

RegisterNUICallback('customsLoaded', function(data, cb)
    uiLoaded = true
    cb(require 'client.modules.filter'.colorTypes)
end)

RegisterNUICallback('toggleMod', function(data, cb)
    cb(toggleMod(data))
end)

RegisterNUICallback("cameraHandle", function(data, cb)
    camera.handleNuiCamera(data)
    cb(1)
end)

return showMenu
