-- In this example Ill show you how you can EXTEND/OVERWRITE vanilla functions

-- Step 1
-- Weve got to get the vanilla file to require this file, so this file can do its work
-- Youll want to copy these 2 lines to the bottom of the file your extending, in this case its eventscheduler.lua
-- Its best practice to namethe modded file the same name as the file your extending.
--[[ Copy these to the bottom of data/scripts/player/eventscheduler.lua

local success, returned = pcall(require, "mods/AvorionBoilerPlate/scripts/player/eventscheduler.lua")
if not success then print(returned) end

]]

-- Thiers a few things to remember about extending vanilla files:
-- You have no scope/access to local variables inside the vanilla file, in this case we have no access to "local events"
-- becuase of that we have to recreate these variables inside the modded side.
-- Its also possible to extend the vanilla function instead of overwriting it.


-- Becuase the vanilla file in this case is useing a GLOBAL namespaced variable "EventScheduler" we have access to its variable
-- Here we save a copy of the old updateServer file
--[[

EventScheduler.updateServer_OLD = EventScheduler.updateServer

-- Now lets extend the updateServer() function and modd it so that player events only happen when there is more then player
-- A stupid mod, but a good example of extending
function EventScheduler.updateServer(timeStep)

  -- Here we get all the players in the sector
  local players = {Sector():getPlayers()}
  -- and here we return the function if thiers only one player in the sector
  if #players == 1 then return end

  -- and here we call the original updateServer()
  -- You could also do the reverese by placing the OLD function first
  EventScheduler.updateServer_OLD()

  -- This is a simple example but is limited becuase its only adding a few lines to the orignal file.
end

]]


-- Here ill show you how to overwrite the updateServer() instead of extending it
-- Best practice is to copy the entire vanilla files contents and strip out whats no longer needed.
-- Remember when overriding you have to overwrite EVERY function that uses a local variable if the function you want to overwrite uses that variable
-- For example if I want to overwrite initialize(), I also need to overwrite updateServer(), secure(), and restore().
-- This is becuase if the modded initialize() changes a local variable, the other functions will not see those changes unless we overwrite them aswell.

-- well begin by removing each line/function we dont want to overwrite, Ill do this by commenting them out but you can just delete them
if onServer() then

-- package.path = package.path .. ";data/scripts/lib/?.lua" -- Deleted becuase the base file has done this already

-- require ("randomext") -- Deleted becuase the base file has already required these packages
-- require ("utility") -- Deleted becuase the base file has already required these packages

local events =
{
    {schedule = random():getInt(45, 60) * 60, script = "convoidistresssignal", arguments = {true}, to = 560},
    {schedule = random():getInt(60, 80) * 60, script = "fakedistresssignal", arguments = {true}, to = 560},
    {schedule = random():getInt(60, 80) * 60, script = "pirateattackstarter", to = 560},
    {schedule = random():getInt(60, 80) * 60, script = "traderattackedbypiratesstarter", to = 560},
    {schedule = random():getInt(25, 50) * 60, script = "alienattack", arguments = {0}, minimum = 5 * 60, from = 0, to = 500},
    {schedule = random():getInt(35, 70) * 60, script = "alienattack", arguments = {1}, minimum = 25 * 60, to = 500},
    {schedule = random():getInt(60, 80) * 60, script = "alienattack", arguments = {2}, minimum = 60 * 60, to = 350},
    {schedule = random():getInt(80, 120) * 60, script = "alienattack", arguments = {3}, minimum = 120 * 60, to = 300},
    --{schedule = random():getInt(50, 70) * 60, script = "spawntravellingmerchant", to = 520},
    -- Lets make our mod lower the duration of the spawntravellingmerchant
    {schedule = random():getInt(25, 50) * 60, script = "spawntravellingmerchant", to = 520},
}

local pause = 5 * 60
local pauseTime = pause

-- Don't remove or alter the following comment, it tells the game the namespace this script lives in. If you remove it, the script will break.
-- namespace EventScheduler -- make sure to delete this aswell
-- EventScheduler = {} -- The base file has already created the namespace

-- Were overwriting this function so we obviously want to keep it
function EventScheduler.initialize()
    for _, event in pairs(events) do
        event.time = (event.minimum or 5 * 60) + math.random() * event.schedule
    end

    local frequency = 0
    for _, event in pairs(events) do
        frequency = frequency + 1 / event.schedule
    end

    print ("player events roughly every " .. round((1 / frequency + pause) / 60, 2) .. " minutes")

end

-- Has no ties to any local variables so we can remove it.
-- function EventScheduler.getUpdateInterval()
--     return 5
-- end

-- We need to overwrite this file aswell becuase is uses the local variable events
function EventScheduler.updateServer(timeStep)
    local player = Player()

    local x, y = Sector():getCoordinates()
    if x == 0 and y == 0 then return end

    -- timeStep = timeStep * 60

    -- only run script for the lowest player index in the sector -> no stacking events
    local players = {Sector():getPlayers()}
    for _, p in pairs(players) do
        -- when there is a player with a lower index, we return
        if p.index < player.index then return end
    end

    -- but, if we're not alone, we speed up events by 50%
    if #players > 1 then timeStep = timeStep * 1.5 end

    if pauseTime > 0 then
        pauseTime = pauseTime - timeStep
        return
    end

    -- update times of events
    for _, event in pairs(events) do
        event.time = event.time - timeStep

        if event.time < 0 then
            -- check if the location is OK
            local from = event.from or 0
            local to = event.to or math.huge

            local position = length(vec2(Sector():getCoordinates()))
            if position >= from and position <= to then
                -- start event
                local arguments = event.arguments or {}
                Player():addScriptOnce(event.script, unpack(arguments))
                event.time = event.schedule

                print ("starting event " .. event.script)

                pauseTime = pause

                break;
            end
        end
    end

end

-- We need to overwrite this file aswell becuase is uses the local variable events
function EventScheduler.secure()
    local times = {}

    for _, event in pairs(events) do
        table.insert(times, event.time)
    end

    return times
end

-- We need to overwrite this file aswell becuase is uses the local variable events
function EventScheduler.restore(times)
    for i = 1, math.min(#times, #events) do
        events[i].time = times[i]
    end
end


end
