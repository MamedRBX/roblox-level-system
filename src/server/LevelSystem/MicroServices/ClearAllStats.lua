--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)


local ClearAllStats = {} --Start of the Module 

--// Functions
local function OnClearAllStats(player:Player)
    local profile =  ProfileManager.profiles[player]
    if not profile then return warn("[ClearALlStats]: Missing Profile") end

    profile.Data.SkillTreePoints = 40
    profile.Data.SkillTreeSkills = {}
    profile.Data.SkillPoints = 100
    local MasterySkills = profile.Data.Skills
    for Skill , value in MasterySkills do 
        profile.Data.Skills[Skill] = 0 
    end
    print(profile.Data)
end

--// Receving Signals
Signals.ClearAllStats:Connect(function(player)
    OnClearAllStats(player)
end)

function ClearAllStats.Init() --Init the Module
    
end


return ClearAllStats