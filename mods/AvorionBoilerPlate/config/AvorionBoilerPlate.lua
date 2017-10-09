local Config = {}
Config.name = "AvorionBoilerPlate"
Config.author = "Dirtyredz"
Config.homepage = "https://github.com/dirtyredz/AvorionBoilerPlate"
Config.tags = {"boilerPlate"}
Config.version = {
    major=1, minor=0, patch = 0,
    string = function()
        return  Config.version.major .. '.' ..
                Config.version.minor .. '.' ..
                Config.version.patch
    end
}

function Config.print(...)
  local args = table.pack(...)
  table.insert(args,1,"[" .. Config.name .. "][" .. Config.version.string .. "]")
  print(table.unpack(args))
end

return Config
