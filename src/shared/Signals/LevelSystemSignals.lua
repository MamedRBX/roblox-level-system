--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Signal = require(ReplicatedStorage.Shared.Libs.Signal)


local Signals = {
    XPChanged = Signal.new(),
    LevelUp = Signal.new(), 
    -- add more as needed
}

return Signals