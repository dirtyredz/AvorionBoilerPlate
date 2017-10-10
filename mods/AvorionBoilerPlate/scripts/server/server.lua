local AvorionBoilerPlate = {}

function AvorionBoilerPlate.onStartUp()
  -- Lets set the consolelevel on server start, so we dont have to set it manually
  print('-- Log Level set to: debug --')
  if not Server():getValue('console_level') then
    local levels = require("mods/LogLevels/scripts/lib/LogLevels")
    Server():setValue('console_level',levels.all)
  end
end

function AvorionBoilerPlate.onPlayerLogIn(playerIndex)
  -- Adding script to player when they log in
  local player = Player(playerIndex)
  player:addScriptOnce("mods/AvorionBoilerPlate/scripts/player/AvorionBoilerPlate.lua")
end

return AvorionBoilerPlate
