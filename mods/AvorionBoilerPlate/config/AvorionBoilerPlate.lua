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

Config.dependencies = {
    basegame = {major=0, minor=14, patch=2},
    mods = {
        {
            name = 'LogLevels',
            version = {major=1, minor=1, patch=0}
        },
        {
            name = 'CBA',
            version = {major=1, minor=0, patch=0}
        }
    }
}

function Config.print(...)
  local args = table.pack(...)
  table.insert(args,1,"[" .. Config.name .. "][" .. Config.version.string() .. "]")
  print(table.unpack(args))
end

return Config
