-- In this example Ill show you how you can EXTEND/OVERWRITE vanilla functions

-- Weve got to get the vanilla file to require this file, so this file can do its work
-- Youll want to copy these 2 lines to the bottom of the file your extending, in this case its eventscheduler.lua
-- Its best practice to namethe modded file the same name as the file your extending.

--[[ Copy these to the bottom of data/scripts/player/eventscheduler.lua

local success, returned = pcall(require, "mods.AvorionBoilerPlate.scripts.player.Extending_eventscheduler")
if not success then print(returned) end

]]

-- Thiers a few things to remember about extending vanilla files:
-- You have no scope/access to local variables inside the vanilla file, in this case we have no access to "local events"
-- becuase of that we have to recreate these variables inside the modded side.
-- Its also possible to extend the vanilla function instead of overwriting it.


-- Becuase the vanilla file in this case is useing a GLOBAL namespaced variable "EventScheduler" we have access to its variable
-- Here we save a copy of the old updateServer file
EventScheduler.updateServer_OLD = EventScheduler.updateServer

-- Now lets extend the updateServer() function and modd it so that player events only happen when there is more then player
-- A stupid mod, but a good example of extending
function EventScheduler.updateServer(timeStep)

  -- Here we get all the players in the sector
  local players = {Sector():getPlayers()}
  -- and here we return the function if thiers only one player in the sector
  if #players == 1 then
    -- print('ONLY ONE PLAYER, SKIPPING') --Uncomment to see that this is working
    return
  end

  -- and here we call the original updateServer()
  -- You could also do the reverese by placing the OLD function first
  EventScheduler.updateServer_OLD()

  -- This is a simple example but is limited becuase its only adding a few lines to the orignal file.
end
