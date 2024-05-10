local vehicle = require 'client.modules.vehicle'
local getVehicleDecals, getVehicleWheels, getVehicleColors, getMod, getVehicleWheelType, getVehicleColorTypes in vehicle
local updateCard = require 'client.modules.utils'.updateCard
local needRepair = false

return {
    {
        id = 'custom',
        label = 'Custom',
        icon = 'bug',
        hide = true,
        selector = {
            onOpen = function(data) -- this will trigger before the current menu renders (used in repair to update price depend on vehicle damage), data: self data
                data.icon = 'poo' --here we will update icon
            end,
            onSelect = function()
                return {
                    {id = 200, toggle = true, label = 'this is toggle', price = 100, selected = true},
                    {id = 2000, label = 'this is a mod', price = 100},
                    {id = 'menu1', label = 'this is a menu'}
                }
            end,
            childOnBuy = function(modType) -- trigger on mod buy, this will work if mod id is a number such '2000' 
                if modType == 2000 then -- here we listen to child item
                    print('setted mod')
                    return true -- return true to set check icon
                end
            end,
            childOnSelect = function(modType) -- trigger on mod select of the current menu, this will work if mod id is a string such 'menu1'
                if modType == 'menu1' then -- here we will create submenu for 'menu1', NOTE (currently we don't support menu inside submenu, you will get issue if you try to get back to previous)
                    return {
                        {id = 2000, label = 'this is a mod'},
                        {id = 2002, label = 'this is a mod2'},
                        {id = 2004, label = 'this is a mod3'},
                    }
                end
            end,
            childOnToggle = function(modType, toggle) -- this will trigger when clicking on mod that has toggle
                print(modType, toggle)
            end,
            onModSwitch = function(modType, modId) -- function(modType: parentMenu, modId: modId) | this will only work on mod and not toggle
                print(modType, modId)
            end
        },
    },
    {
        id = 'repair',
        important = true,
        label = 'Repair',
        icon = 'hammer',
        price = 100,
        selected = true,
        selector = {
            onOpen = function(data) -- return self like (data.price, data.icon),  for ex here im calculating vehicle damage
                needRepair = false
                data.hide = false
                local vehicle = cache.vehicle
                local engine, body = GetVehicleEngineHealth(vehicle), GetVehicleBodyHealth(vehicle)
                local bodyDamage = 100 - (body/10)
                local engineDamage = 100 - (engine/10)
                local price = ((bodyDamage * 50) + (engineDamage * 50))
                if price < 0 then
                    price = 0
                end
                
                data.price = math.floor(price) -- we update the price to show on UI
                if data.price == 0 then
                    data.hide = true --if vehicle has no damage, we hide the menu
                else
                    needRepair = true
                end
            end,
            onSelect = function(data)
                local vehicle = cache.vehicle
                local poly = require 'client.modules.polyzone'
                if data.price == 0 then
                    return lib.notify({ title = 'Customs', description = 'Vehicle is fixed already', type = 'warning' })
                end
                if poly.free or lib.callback.await('bl_customs:canAffordMod', false, data.price) then
                    SetVehicleBodyHealth(vehicle, 1000.0)
                    SetVehicleEngineHealth(vehicle, 1000.0)
                    SetVehicleFixed(vehicle)
                    updateCard('repair', {hide = true}) -- let hide the card after repairing
                    needRepair = false
                    lib.notify({ title = 'Customs', description = 'vehicle fixed!', type = 'success' })
                    data.price = 0 -- reset the price
                end
            end,
        },
    },
    {
        id = 'preview',
        important = true, -- An important menu can't be removed. If it's false, it can be removed if you didn't place it in the mods table in locations config
        label = 'Preview',
        icon = 'car-side',
        selector = {
            onSelect = function()
                local camera = require 'client.modules.camera'
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
            end
        }
    },
    {
        id = 'decals',
        label = 'Decals',
        icon = 'screwdriver-wrench',
        selector = {
            onSelect = getVehicleDecals,
            childOnSelect = function(type)
                if type == 'Extras' and needRepair then
                    lib.notify({ title = 'Customs', description = 'Please repair your car!', type = 'inform' })
                    return
                end
                
                return getMod(type)
            end,
        }
    },
    {
        id = 'wheels',
        menuType = 'wheels',
        label = 'Wheels',
        icon = 'tire',
        selector = {
            onSelect = getVehicleWheels,
            childOnSelect = getVehicleWheelType,
        }
    },
    {
        id = 'performance',
        label = 'Performance',
        icon = 'screwdriver-wrench',
        selector = {
            onSelect = getVehicleDecals,
            childOnSelect = getMod,
        },
    },
    {
        id = 'paint',
        menuType = 'paint',
        label = 'Paint',
        icon = 'fill-drip',
        selector = {
            onSelect = getVehicleColors,
            childOnSelect = getVehicleColorTypes,
        }
    },
    {
        id = 'exit',
        important = true,
        label = 'Exit',
        icon = 'right-from-bracket',
        selector = {
            onSelect = function()
                local showMenu = require 'client.modules.menu'
                showMenu(false)
                return true
            end
        },
    },
}
