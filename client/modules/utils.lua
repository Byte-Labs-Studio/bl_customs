local Utils = {}

local currentResourceName = GetCurrentResourceName()

local debugIsEnabled = GetConvarInt(('%s-debugMode'):format(currentResourceName), 0) == 1

function Utils.SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
  if action ~= 'setVisible' then return end

  SetNuiFocusKeepInput(false)
  SetNuiFocus(data, false)
end

function Utils.updateCard(id, update)
  Utils.SendReactMessage('updateCard', {
    id = id,
    update = update
  })
end

function Utils.debugPrint(...)
  if not debugIsEnabled then return end
  local args <const> = { ... }

  local appendStr = ''
  for _, v in ipairs(args) do
    appendStr = appendStr .. ' ' .. tostring(v)
  end
  local msgTemplate = '^3[%s]^0%s'
  local finalMsg = msgTemplate:format(currentResourceName, appendStr)
  print(finalMsg)
end

return Utils