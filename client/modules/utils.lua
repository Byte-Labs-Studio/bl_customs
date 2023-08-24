local Utils = {}

local currentResourceName = GetCurrentResourceName()

local debugIsEnabled = GetConvarInt(('%s-debugMode'):format(currentResourceName), 0) == 1

function Utils.SendReactMessage(action, data, mouse, input)
  SendNUIMessage({
    action = action,
    data = data
  })
  if action ~= 'setVisible' then return end

  if input then
    SetNuiFocusKeepInput(data)
  end

  if mouse then
    SetNuiFocus(data, false)
  else
    SetNuiFocus(data, data)
  end
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