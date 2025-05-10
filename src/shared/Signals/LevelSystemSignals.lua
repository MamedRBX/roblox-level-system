--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Signal = require(ReplicatedStorage.Shared.Libs.Signal)


local Signals = {
    --// Server Signals
    XPChanged = Signal.new(),
    LevelUp = Signal.new(), 
    SpendMasterySP = Signal.new(),
    SpendSkillTreeSP = Signal.new(),
    -- add more as needed

    
    --// Client signals 
    LevelPopUp = Signal.new(),
    XpPopUp = Signal.new(),

}

return Signals