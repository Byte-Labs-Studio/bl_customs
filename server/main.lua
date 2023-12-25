if not lib then return end

local config = require 'config'

lib.callback.register('bl_customs:canAffordMod', function(source, amount)
    local moneyType = config.moneyType
    local core = Framework.core
    local player = core.GetPlayer(source)
    local money = player.getBalance(moneyType)
    if amount > money then return false end
    player.removeBalance(moneyType, amount)
    return true
end)