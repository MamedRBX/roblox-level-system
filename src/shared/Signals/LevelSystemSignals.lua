--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Signal = require(ReplicatedStorage.Shared.Libs.Signal)


local Signals = {
    XPChanged = Signal.new(),
    LevelUp = Signal.new(), 
    XpPopUp = Signal.new(),
    LevelPopUp = Signal.new(),
    SpendMasterySP = Signal.new(),
    SpendSkillTreeSP = Signal.new()
    -- add more as needed
}

return Signals