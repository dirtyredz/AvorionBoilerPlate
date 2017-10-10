-- In this example Ill show you how you can update LOCAL CONSTANTS
-- Local constants are local variables that can be updated without manipulating them inside of a vanilla function
-- eventscheduler is a perfect example of this.
-- Lets say you want to add a new event, no need to overwrite everything since that will make your mod incompatable with other mods.

-- Step 1
-- Weve got to get the vanilla file to require this file, so this file can do its work
-- Youll want to copy these 2 lines to the bottom of the file your extending, in this case its eventscheduler.lua
-- Its best practice to namethe modded file the same name as the file your extending.

--[[ Copy these to the bottom of data/scripts/player/eventscheduler.lua

local success, returned = pcall(require, "mods/AvorionBoilerPlate/scripts/player/Locals_eventscheduler.lua")
if not success then print(returned); else events = EventSheduler.addCustomEvents(events); end

]]

function EventSheduler.addCustomEvents(events)

 table.insert(events, {schedule = random():getInt(25, 50) * 60, script = "MyAwesomeEvent", arguments = {0}, minimum = 5 * 60, from = 0, to = 500})

 return events
end
