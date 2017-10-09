package.path = package.path .. ";data/scripts/lib/?.lua"
package.path = package.path .. ";data/scripts/server/?.lua"
require ("factions")
require ("stringutility")

function onStartUp()
    Server():registerCallback("onPlayerLogIn", "onPlayerLogIn")
    Server():registerCallback("onPlayerLogOff", "onPlayerLogOff")
    Galaxy():registerCallback("onPlayerCreated", "onPlayerCreated")
    Galaxy():registerCallback("onFactionCreated", "onFactionCreated")

    --Added by LogLevels to set the default levels for the console
    print('-- Log Level set to: debug --')
    if not Server():getValue('log_level') then
      local levels = require("mods/LogLevels/scripts/lib/LogLevels")
      Server():setValue('console_level',levels.all)
    end
end

function onShutDown()

end

function update(timeStep)
    local server = Server()

    local guardianRespawnTime = server:getValue("guardian_respawn_time")
    if guardianRespawnTime then

        guardianRespawnTime = guardianRespawnTime - timeStep;
        if guardianRespawnTime < 0 then
            guardianRespawnTime = nil
        end

        server:setValue("guardian_respawn_time", guardianRespawnTime)
    end

    local serverRuntime = server:getValue("online_time") or 0
    serverRuntime = serverRuntime + timeStep
    server:setValue("online_time", serverRuntime)

end

function onPlayerCreated(index)
    local player = Player(index)
    Server():broadcastChatMessage("Server", 0, "Player %s created!"%_t, player.name)
end

function onFactionCreated(index)

end

function onPlayerLogIn(playerIndex)
    local player = Player(playerIndex)
    Server():broadcastChatMessage("Server", 0, "Player %s joined the galaxy"%_t, player.name)

    player:addScriptOnce("headhunter.lua")
    player:addScriptOnce("eventscheduler.lua")
    player:addScriptOnce("story/spawnswoks.lua")
    player:addScriptOnce("story/spawnai.lua")
    player:addScriptOnce("story/spawnguardian.lua")
    player:addScriptOnce("story/spawnadventurer.lua")

    --Added by AvorionBoilerPlate, this is you a script is attached to a player object.
    player:addScriptOnce("mods/AvorionBoilerPlate/scripts/player/AvorionBoilerPlate.lua")


    matchResources(player)
end

function onPlayerLogOff(playerIndex)
    local player = Player(playerIndex)
    Server():broadcastChatMessage("Server", 0, "Player %s left the galaxy"%_t, player.name)

end
