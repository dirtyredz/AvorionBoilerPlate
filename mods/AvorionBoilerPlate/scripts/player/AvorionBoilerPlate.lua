-- constants
local MODULE = 'AvorionBoilerPlate' -- our module name

-- general
local basePath = "mods/" .. MODULE
local modConfig = require(basePath .. '/config/' .. MODULE)

-- namespace AvorionBoilerPlate
AvorionBoilerPlate = {}

function AvorionBoilerPlate.secure()
    return {dummy = 1}
end

function AvorionBoilerPlate.restore(data)
    terminate()
end

function AvorionBoilerPlate.getUpdateInterval()

end

function AvorionBoilerPlate.initialize()

end

function AvorionBoilerPlate.update(timeStep)

end

function AvorionBoilerPlate.updateServer(timeStep)

end

function AvorionBoilerPlate.updateClient(timeStep)

end
