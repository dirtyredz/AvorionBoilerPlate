-- constants
local MODULE = 'AvorionBoilerPlate' -- our module name

-- general
local modsDir = "mods/"
local basePath = modsDir .. MODULE
local modConfig = require(basePath .. '/config/' .. MODULE)

-- Script variables
local SuperImportantValue = 0


-- LogLevels
-- This is a thrid party mod and not required to mod, but is highly advisable as it makes generating warning/fatal/debug prints possible
local logLevels = require(modsDir .. "LogLevels/scripts/lib/PrintLog")

-- namespace AvorionBoilerPlate
AvorionBoilerPlate = {}

-- This function will be called when the player is saved into the database.
-- The server will not save the entire script and all its values.
-- Instead it will call this function to gather all values from the script that have to be saved.
-- if you have any important values that need saving, put them into a table and return them here and the database will save them.
-- When the player is loaded from the database, the restore() function will be called
-- with all the values that were returned by this function before.
function AvorionBoilerPlate.secure()
  -- array of data to store to the database
  local DataToSecure = {
    SuperImportantValue = SuperImportantValue
  }
  return DataToSecure
end

-- if previously there was a table returned by secure(), this function will be called when the player is
-- restored from the database and the table returned by secure() will be given as parameter here.
-- This function is called AFTER the initialize() function.
function AvorionBoilerPlate.restore(data)
  -- data is the array that was stored in the database
  SuperImportantValue = data.SuperImportantValue
end

-- this function gets called when the script is attached to the player
function AvorionBoilerPlate.initialize()
  --Player() returns the current player this script is attached to
  local player = Player()

  --print accepts multiple arguments
  --you can either concatenate or agurment seperate what your wanting to print to the console
  --Using modConfig allows us to use the print function settup in the config file so our mod name and mod version are always printed infront of our print
  --Using logLevels.trace, allows us to tell Loglevels that this is a trace print, Only printing it when the console is settup to print trace and below.
  modConfig.print('Initialized, on player:',player.name,logLevels.trace)
  --modConfig.print('Initialized, on player:' .. player.name)--Example of print concatenation

  -- Here is a unique function exposed to all of avorion
  -- its important to remeber that a script runs in tandom with its client counterpart
  -- meaning both the client and the server are runing the same script at the same timeStep
  -- so this function will return true if its running on the server, and this is very important,
  -- since you can only do certain things on the client and certain thins on the server
  -- You want to make sure important thing like paying money and attaching scripts is done on the server.
  if onServer() then

    --This is an example of how you would attach a callback function to a script
    --Here were attachng the callback named onSectorEntered(1st arg), to the function in this script named onSectorEntered(2nd arg)
    --The function itself is placed further down the file, ignore the namespacing (AvorionBoilerPlate.) here as the callback will automatically search insde this scripts namespace
    player:registerCallback("onSectorEntered", "onSectorEntered")

    --Here were attachng the callback named onShipChanged(1st arg), to the function in this script named onShipChanged(2nd arg)
    player:registerCallback("onShipChanged", "onShipChanged")

  end

  -- Here is the counterpart to onServer()
  -- This function will return true only when the script is being executed on the client side
  -- Client side handle things like display information to the screen, or generate the various UI's/Interfaces/Menus that you use and see
  if onClient() then
    --Remember the client can only do so much here, it cant use server protected functions
    -- Print will print both to the client log and the server log, depending on whos calling it
    -- Client print will appear in white inside the console.
    modConfig.print('Notice how this print is white instead of blue like the other prints?')
    modConfig.print('Thats becuase any print done on the client is shown as white, and printed to the clients log not the servers')

  end

end

-- will control how often update/updateClient/updateServer are called.
-- without this function those functions will be called each frame
-- returning any value here will tell those functions to only update every x second/frame
function AvorionBoilerPlate.getUpdateInterval()
  --Can accept int or float
  return 5 --update every 5th second/frame
end

-- this function gets called once each frame, on client and server
function AvorionBoilerPlate.update(timeStep)

end

-- this function gets called once each frame, on server only
function AvorionBoilerPlate.updateServer(timeStep)
  -- increment this variable every 5th second/frame
  SuperImportantValue = SuperImportantValue + 1
  -- Were using the debug loglevel here so if we want to see this in game we have to set the consolelevel with this command in game: /consolelevel debug
  modConfig.print('Dirtyredz is',SuperImportantValue,'times cooler!!',logLevels.debug)
end

-- this function gets called once each frame, on client only
function AvorionBoilerPlate.updateClient(timeStep)

end

--This is one example of using a player callback function
--you can view all player callback functions here: avorion/Documentation/Player Callback.html
--This specific callback will be called whenever the players ships ID changes (when changing ships)
function AvorionBoilerPlate.onShipChanged(playerIndex, craftIndex)
  --lets get the current player
  local player = Player()
  --This is a fallback in the event this function was called on the wrong player (Trust me on this, can happen with callbacks)
  if Player().index ~= playerIndex then return end

  --If we didnt get a craft index return
  if not craftIndex then return end

  --Assign the new craft to an Entity object so we can use it.
  local craft = Entity(craftIndex)

  --Print to the console which player has entered which craft
  modConfig.print(player.name, ', Has entered craft:',craft.name,logLevels.info)

end

--This is one example of using a player callback function
--you can view all player callback functions here: avorion/Documentation/Player Callback.html
--This specific callback will be called whenever the players Enters a sector
function AvorionBoilerPlate.onSectorEntered(playerIndex, x, y)
  --lets get the current player
  local player = Player()
  --This is a fallback in the event this function was called on the wrong player (Trust me on this, can happen with callbacks)
  if Player().index ~= playerIndex then return end

  --Print to the console which player has entered which sector
  modConfig.print(player.name, ', Has entered sector:',x,y,logLevels.info)

end
