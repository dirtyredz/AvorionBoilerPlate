local Config = {}
Config.name = "LogLevels"
Config.author = "Dirtyredz"
Config.homepage = "https://github.com/dirtyredz/LogLevels"
Config.tags = {"Log","Console","Debug","Levels"}
Config.version = {
    major=1, minor=1, patch = 0,
    string = function()
        return  Config.version.major .. '.' ..
                Config.version.minor .. '.' ..
                Config.version.patch
    end
}

Config.dependencies = {
    basegame = {major=0, minor=14, patch=0},
    mods = {
    }
}

function Config.print(...)
  local args = table.pack(...)
  table.insert(args,1,"[" .. Config.name .. "][" .. Config.version.string .. "]")
  print(table.unpack(args))
end

return Config
