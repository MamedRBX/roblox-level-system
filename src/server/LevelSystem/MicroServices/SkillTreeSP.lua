--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)
local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)


local SkillTreeSP = {}

--// Functions
function SkillTreeSP.OnLevelUp(player: Player)
    local profile = ProfileManager.profiles[player]
    if not profile then return warn("[SkillTreeSP]: Missing Profile") end

    if profile.Data.Level % 2 == 0 then --we give the player a SkillTree Point for every second Levelup
        --the Level is even so its the second Level 
        profile.Data.SkillTreePoints += 1
    else
        --the Level is not even so no SkillTree Point
    end
end

--// Receving Signals
Signals.LevelUp:Connect(function(player:Player)
    SkillTreeSP.OnLevelUp(player)
end)

--// Init the Module
function SkillTreeSP.Init()
    
end


return SkillTreeSP