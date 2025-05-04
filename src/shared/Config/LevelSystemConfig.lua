local ServerScriptService = game:GetService("ServerScriptService")

local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)


local LevelSystemConfig = {}

local Base_Xp_Cost = 100
local XpCost_Increase_Per_Level = 25

--// Functions
function LevelSystemConfig.GetXpForLevel(player, Level:number) --Calculates how much xp the player needs for the next Level
    local profile = ProfileManager.profiles[player]
    if not profile then return warn("[LevelSystemConfig]: Missing Profile") end

    return Base_Xp_Cost + (Level - 1) * XpCost_Increase_Per_Level
end



return  LevelSystemConfig