
local LevelSystemConfig = {} --Start of the Module

--// Base values
local Base_Xp_Cost = 100
local XpCost_Increase_Per_Level = 25
local SkillCap = 100
local LevelCap = 115
local milestones = {25, 50, 75, 100}


--// Functions
function LevelSystemConfig.GetXpForLevel(Level:number) --Calculates how much xp the player needs for the next Level
	if Level == LevelCap then
		return Base_Xp_Cost + (Level - 2) * XpCost_Increase_Per_Level
	else
    	return Base_Xp_Cost + (Level - 1) * XpCost_Increase_Per_Level
	end
end


function LevelSystemConfig.SkillCap(SkillAmount:number) --Just gives the cap of the Skill , could be extandend
   if SkillAmount < SkillCap then
		return true --player can skill
   else
		return false --player is at Skillcap
   end 
end 


function LevelSystemConfig.GetMileStoneStart(LevelAmount: number) : number --gies the starting point for the Skill Progress bar
	for index, value in milestones do
		if LevelAmount < value then
			if index > 1 then
				return milestones[index - 1] --if the current milestone goal is 50 , then this will give 25 
			else
				
				return 0 -- if its the first milestone , then we just return normally 
			end
		end
		if LevelAmount == SkillCap then
			return value
		end
	end
	warn("[LevelSystemConfig]: Level exceeds all milestones")
    return 
end

function LevelSystemConfig.GetMileStoneEnd(LevelAmount: number): number --gives the end point for the Skill Progress bar
	for _, milestone in milestones do
		if LevelAmount < milestone then
			return milestone
		elseif LevelAmount == SkillCap then
		
			return SkillCap

		end		
			
	end

end

function LevelSystemConfig.MileStoneNumber(LevelAmount: number): number --returns the MileStone tier of that Skill 
	for index, milestone in milestones do
		if LevelAmount < milestone then
			return index
		end
	end
    return #milestones
end


function LevelSystemConfig.LevelCap(Level: number) : boolean  --returns if the player can get another Level
	if Level >= LevelCap then return false else return true end
end

function LevelSystemConfig.ReturnSkillCap()
	return SkillCap
end


return  LevelSystemConfig