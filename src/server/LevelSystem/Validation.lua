--// Services 
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)
local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)


local Validation = {} --Start of the Module 

function Validation.AdjustXp(player: Player)
    local profile = ProfileManager.profiles[player]
    if not profile then return warn("[Validation]: Missing Profile") end
 
    --check if player has reached maximum level
    local LevelCap : boolean = LevelSystemConfig.LevelCap(profile.Data.Level)
    if LevelCap then 
        return true
    else
        return false
    end
    

end

function Validation.SkillPointCheck(player: Player )
    local profile = ProfileManager.profiles[player]
    if not profile then return warn("[Validation]: Missing Profile") end

    if LevelSystemConfig.LevelCap(profile.Data.Level) then
        return true
    else
        return false
    end

    
end


function  Validation.Init() --Init the Module
    
end

return Validation