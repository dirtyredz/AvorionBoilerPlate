local AvorionBoilerPlateConfig = {}
AvorionBoilerPlateConfig.name = "AvorionBoilerPlate"
AvorionBoilerPlateConfig.author = "Dirtyredz"
AvorionBoilerPlateConfig.homepage = "https://github.com/dirtyredz/AvorionBoilerPlate"
AvorionBoilerPlateConfig.tags = {"boilerPlate"}
AvorionBoilerPlateConfig.version = {
    major=1, minor=0, patch = 0,
    string = function()
        return  AvorionBoilerPlateConfig.version.major .. '.' ..
                AvorionBoilerPlateConfig.version.minor .. '.' ..
                AvorionBoilerPlateConfig.version.patch
    end
}

function AvorionBoilerPlateConfig.print(...)
  local args = table.pack(...)
  table.insert(args,1,"[" .. AvorionBoilerPlateConfig.name .. "][" .. AvorionBoilerPlateConfig.version.string .. "]")
  print(table.unpack(args))
end

return AvorionBoilerPlateConfig
