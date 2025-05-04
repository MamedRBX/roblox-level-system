--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)
local Singals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)

local MasterySP = {}

--// Functions 
function MasterySP.OnLevelUp(player)
    local profile = ProfileManager.profiles[player]
    if not profile then return warn("[MasterySP]: Missing Profile") end

    profile.Data.SkillPoints += 1 
    
end

--// Receving Signals
Singals.LevelUp:Connect(function(player:Player)
    MasterySP.OnLevelUp(player)
end)

--// Init Module
function  MasterySP.Init()
    
end

return MasterySP