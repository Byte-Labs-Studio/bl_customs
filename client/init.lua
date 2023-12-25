if not lib then return end

local showMenu = require 'client.modules.menu'
CreateThread(function()
    lib.addKeybind({
        name = 'customs',
        description = 'press G to open customs',
        defaultKey = 'G',
        onReleased = function(self)
            showMenu(true)
        end
    })
end)