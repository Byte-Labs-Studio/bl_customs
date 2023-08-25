local vehicle = require 'client.modules.vehicle'
local Store = require 'client.modules.store'
local Config = require 'config'
local poly = require 'client.modules.polyzone'
local camera = require 'client.modules.camera'
local Interface = require 'client.modules.utils'
local table_contain = lib.table.contains

local function resetMenuData()
    local entity = cache.vehicle
    SetVehicleDoorsLocked(entity , 1)
    FreezeEntityPosition(entity, false)
    Store = { menu = 'main', modType = 'none', stored = {}, preview = false}
    camera.destroyCam()
end

---comment
---@param show boolean
local function showMenu(show)
    if not show then 
        Interface.SendReactMessage('setVisible', false)
        resetMenuData()
        return
    end
    local entity = cache.vehicle
    if not poly.isNear or not entity then return end
    Interface.SendReactMessage('setVisible', true, true, true)
    local coords = poly.pos
    SetVehicleEngineOn(entity, true, true, false)
    SetVehicleAutoRepairDisabled(entity, true)
    SetVehicleModKit(entity, 0)
    SetEntityHeading(entity, coords.w)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    FreezeEntityPosition(entity, true)
    SetVehicleDoorsLocked(entity , 4)
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

    return selector[Store.menu] and selector[Store.menu](type)
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
            Store.preview = not Store.preview
            if Store.preview then
                camera.destroyCam()
            else
                camera.createMainCam()
            end
        end,
    }

    return selector[menu] and selector[menu]()
end

---comment
---@param menu {type: number, index: number}
local function applyMod(menu)
    local entity = cache.vehicle
    if menu.type == 51 then -- plate index
        SetVehicleNumberPlateTextIndex(entity, menu.index)
    else
        SetVehicleMod(entity, menu.type, menu.index, Store.stored.customTyres)
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
    Store.stored.appliedMods = {modType = Store.modType, mod = modIndex}
    if Store.menu == 'paint' then
        applyColorMod({ colorType = Store.modType, modIndex = modIndex })
    else
        applyMod({ type = Store.menu == 'wheels' and 23 or Config.decals[Store.modType].id, index = modIndex })
    end
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
        local storedData = Store.stored
        if not storedData.boughtMods or storedData.appliedMods and storedData.appliedMods.modType ~= storedData.boughtMods.modType or storedData.appliedMods.mod ~= storedData.boughtMods.mod then
            if Store.menu == 'wheels' then
                SetVehicleWheelType(cache.vehicle, Store.stored.currentWheelType)
            end
            handleMod(storedData.currentMod)
        end
    end
    if menuType == 'menu' then
        Store.menu = clickedCard
    elseif menuType == 'modType' then
        Store.modType = Store.menu == 'paint' and (table_contain(Config.colors.types, clickedCard) and clickedCard or Store.modType) or clickedCard
    end

    return menuType == 'menu' and handleMainMenus(clickedCard) or getModType(clickedCard)
end

---comment
---@param amount number
---@return boolean
local function removeMoney(amount)
    return lib.callback.await('bl_customs:canAffordMod', false, amount)
end

local function buyMod(data)
    local storedData = Store.stored

    if storedData.currentMod == data.mod then 
        lib.notify({title = 'Customs',description = 'You have this mod already',type = 'warning'})
        return 
    end
    if not removeMoney(data.price) then 
        lib.notify({title = 'Customs',description = 'You\'re broke',type = 'warning'})
        return 
    end
    storedData.boughtMods = {price = data.price, mod = data.mod, modType = Store.modType}
    storedData.currentMod = data.mod
    return true
end

---comment
---@param data {price: number, toggle:boolean, mod:number}
---@return boolean|nil
local function toggleMod(data)
    if not removeMoney(data.price) then 
        lib.notify({title = 'Customs',description = 'You\'re broke',type = 'warning'})
        return 
    end
    if Store.menu == 'wheels' then
        vehicle.toggleCustomTyres(data.toggle)
    elseif Store.modType == 'Neon' then
        vehicle.enableNeonColor({modIndex = data.mod, toggle = data.toggle})
    end
    return true
end

RegisterNUICallback('hideFrame', function(_, cb)
    resetMenuData()
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

RegisterNUICallback('toggleMod', function(data, cb)
    cb(toggleMod(data))
end)

return showMenu
