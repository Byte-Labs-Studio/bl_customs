local vehicle = require 'client.modules.vehicle'
local Config = require 'config'
local poly = require 'client.modules.polyzone'
local camera = require 'client.modules.camera'
local table_contain = lib.table.contains
local uiLoaded = false
---comment
---@param menu {type: number, index: number}
local function applyMod(menu)
    local storedData = require 'client.modules.store'.stored
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
    local selector = {
        Primary = vehicle.applyVehicleColor,
        Secondary = vehicle.applyVehicleColor,
        Interior = vehicle.applyInteriorColor,
        Wheels = vehicle.applyExtraColor,
        Pearlescent = vehicle.applyExtraColor,
        Dashboard = vehicle.applyDashboardColor,
        Neon = vehicle.applyNeonColor,
        ['Tyre Smoke'] = vehicle.applyTyreSmokeColor,
        ['Xenon Lights'] = vehicle.applyXenonLightsColor,
        ['Window Tint'] = vehicle.applyWindowsTint,
        ['Neon Colors'] = vehicle.applyNeonColor,
    }
    local isSelector = selector[menu.colorType]
    if not isSelector then return end
    isSelector(menu)
end

---comment
---@param modIndex number
local function handleMod(modIndex)
    local store = require 'client.modules.store'
    local modType = store.modType

    if modType == 'none' then return end

    store.stored.appliedMods = { modType = modType, mod = modIndex }
    if store.menu == 'paint' then
        applyColorMod({ colorType = modType, modIndex = modIndex })
    else
        applyMod({ type = store.menu == 'wheels' and 23 or Config.decals[modType].id, index = modIndex })
    end
end

local function resetLastMod()
    local store = require 'client.modules.store'
    local storedData = store.stored
    if not storedData.boughtMods or storedData.appliedMods and storedData.appliedMods.modType ~= storedData.boughtMods.modType or storedData.appliedMods.mod ~= storedData.boughtMods.mod then
        if store.menu == 'wheels' then
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

    local store = require 'client.modules.store'
    store.menu = 'main'
    store.modType = 'none'
    store.stored = {}
    store.preview = false
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

    if poly.mods then
        SendReactMessage('setZoneMods', poly.mods)
    end
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
    local selector = {
        wheels = vehicle.getVehicleWheelsType,
        decals = vehicle.getMods,
        paint = vehicle.getVehicleColorsTypes,
    }

    local store = require 'client.modules.store'
    return selector[store.menu] and selector[store.menu](type)
end

---comment
---@param menu 'exit' | 'decals' | 'wheels' | 'paint' | 'preview'
---@return table|nil
local function handleMainMenus(menu)
    local selector = {
        exit = function()
            showMenu(false)
            return true
        end,
        decals = vehicle.getVehicleDecals,
        wheels = vehicle.getVehicleWheels,
        paint = vehicle.getVehicleColors,
        preview = function()
            local store = require 'client.modules.store'
            store.preview = not store.preview
            local text = ''
            if store.preview then
                text = 'Preview Mode: On'
                SetNuiFocus(true, false)
                camera.destroyCam()
            else
                text = 'Preview Mode: Off'
                SetNuiFocus(true, true)
                camera.createMainCam()
            end

            lib.notify({ title = 'Customs', description = text, type = 'inform' })
        end,
    }

    local selectorFun = selector[menu]
    return selectorFun and selectorFun()
end

---comment
---@param data {type: string, isBack:boolean, clickedCard:string}
---@return table|nil
local function handleMenuClick(data)
    local menuType = data.type
    local clickedCard = data.clickedCard
    if clickedCard == nil then return end
    camera.switchCam()
    if data.isBack then
        resetLastMod()
    end
    if menuType == 'menu' then
        local store = require 'client.modules.store'

        store.menu = clickedCard
    elseif menuType == 'modType' then
        local store = require 'client.modules.store'

        store.modType = store.menu == 'paint' and
            (table_contain(Config.colors.types, clickedCard) and clickedCard or store.modType) or clickedCard
    end

    return menuType == 'menu' and handleMainMenus(clickedCard) or getModType(clickedCard)
end

---comment
---@param amount number
---@return boolean
local function removeMoney(amount)
    return poly.free or lib.callback.await('bl_customs:canAffordMod', false, amount)
end

local function buyMod(data)
    local store = require 'client.modules.store'
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
    return true
end

---comment
---@param data {price: number, toggle:boolean, mod:number}
---@return boolean|nil
local function toggleMod(data)
    if not removeMoney(data.price) then
        lib.notify({ title = 'Customs', description = 'You\'re broke', type = 'warning' })
        return false
    end
    local store = require 'client.modules.store'
    local mod, toggle in data

    if store.modType == 'Neon' then
        vehicle.enableNeonColor({ modIndex = mod, toggle = toggle })
    else
        ToggleVehicleMod(cache.vehicle, mod, toggle)
    end

    return true
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
    cb(1)
    uiLoaded = true
end)

RegisterNUICallback('toggleMod', function(data, cb)
    cb(toggleMod(data))
end)

RegisterNUICallback("cameraHandle", function(data, cb)
    camera.handleNuiCamera(data)
    cb(1)
end)

return showMenu
