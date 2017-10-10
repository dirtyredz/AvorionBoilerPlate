-- In this example Ill show you how you can OVERWRITE vanilla functions

-- Step 1
-- Weve got to get the vanilla file to require this file, so this file can do its work
-- Youll want to copy these 2 lines to the bottom of the file your Overwriting, in this case its eventscheduler.lua
-- Its best practice to name the modded file the same name as the file your Overwriting.

--[[ Copy these to the bottom of data/scripts/player/eventscheduler.lua

local success, returned = pcall(require, "mods.AvorionBoilerPlate.scripts.player.eventscheduler")
if not success then print(returned) end

]]


function EventScheduler.initialize()
    -- Get the vanilla files locals
    local events, pause = EventScheduler.GetLocals()

    -- Do some stuff to those locals
    table.insert(events, {schedule = random():getInt(25, 50) * 60, script = "MyAwesomeEvent2", arguments = {0}, minimum = 5 * 60, from = 0, to = 500})


    -- change what initialize does, overwrite = making changes to exsisting code
    for _, event in pairs(events) do
        --event.time = (event.minimum or 5 * 60) + math.random() * event.schedule
        event.time = (event.minimum or 10 * 60) + math.random() * event.schedule
    end

    local frequency = 0
    for _, event in pairs(events) do
        frequency = frequency + 1 / event.schedule
    end

    print ("player events roughly every " .. round((1 / frequency + pause) / 60, 2) .. " minutes")

    -- Store the locals back into the vanilla file
    EventScheduler.SetLocals({events = events, pause = pause})
end
