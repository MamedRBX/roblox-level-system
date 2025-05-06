--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)
local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)

local LevelProgression = {}

--// Functions
function LevelProgression.AdjustXp(player:Player , amount:number) --adding Xp to the player 
    local profile = ProfileManager.profiles[player]
    while not profile do
        profile = ProfileManager.profiles[player]
        task.wait(0.8)
        warn("[LevelProgression]: trying to load Profile")
    end
    

    local currentXp = profile.Data.Xp
    local currentLevel = profile.Data.Level

    

    local totalXp = currentXp + amount

    
    --Leveling loop 
    while totalXp >= LevelSystemConfig.GetXpForLevel( currentLevel) do
        totalXp -= LevelSystemConfig.GetXpForLevel(currentLevel)
        profile.Data.Level = currentLevel + 1
        --sending signal that the player has leveled up
        Signals.LevelUp:Fire(player) --> 1 stands for 1 levelup , possibly could add more 
    end
    
    -- Update xp
    profile.Data.Xp = totalXp
    player.leaderstats.Xp.Value = totalXp

    --Update Level
    player.leaderstats.Level.Value = profile.Data.Level

    --Updating Ui 
    local UdapteUiRemote  = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder"):WaitForChild("UpdateUi") :: RemoteEvent 
    UdapteUiRemote:FireClient(player, "Update", {
     Xp = profile.Data.Xp ,
     Level = profile.Data.Level ,
    }) --sending Xp and Level value to the StateManager to update
 
end

--// receving Signals
Signals.XPChanged:Connect(function(player:Player, amount:number)

    LevelProgression.AdjustXp(player , amount)
end)


--// Init the Module
function  LevelProgression.Init()
    
end

return LevelProgression 