
local LevelSystemConfig = {}

local Base_Xp_Cost = 100
local XpCost_Increase_Per_Level = 25

--// Functions
function LevelSystemConfig.GetXpForLevel(Level:number) --Calculates how much xp the player needs for the next Level

    return Base_Xp_Cost + (Level - 1) * XpCost_Increase_Per_Level
end



return  LevelSystemConfig