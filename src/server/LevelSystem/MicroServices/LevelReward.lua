--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)


local LevelReward = {}

--// Functions
function LevelReward.OnLevelUp(player: Player)
    local profiles = ProfileManager.profiles[player] 
    if not profiles then return warn("[LevelReward]: Missing Profile") end

    --Here you can put in rewards that the player shoudl recevice whenever he makes a level up 

    if profiles.Data.Level % 5 == 0 then
        --maybe a reward for every 5 Levels the player makes 
    end 


end

--// Receving Signals
Signals.LevelUp:Connect(function(player:Player)
    LevelReward.OnLevelUp(player)
end)


--// Init the Module
function LevelReward.Init()
    
end

return LevelReward