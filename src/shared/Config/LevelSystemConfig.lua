
local LevelSystemConfig = {}

local Base_Xp_Cost = 100
local XpCost_Increase_Per_Level = 25
local SkillCap = 100

--// Functions
function LevelSystemConfig.GetXpForLevel(Level:number) --Calculates how much xp the player needs for the next Level

    return Base_Xp_Cost + (Level - 1) * XpCost_Increase_Per_Level
end


function LevelSystemConfig.SkillCap(amountToAdd:number,SkillAmount:number) --Just gives the cap of the SKill , could be extandend
    local total = SkillAmount + amountToAdd

    if SkillAmount >= SkillCap then
        return 0
    elseif total > SkillCap then
        return SkillCap - SkillAmount
    else
        return amountToAdd
    end
end 

return  LevelSystemConfig