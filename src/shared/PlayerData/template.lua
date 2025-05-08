
export type SkillLevels = {
    Strength: number,
    Wisdom: number,
    Stamina: number,
    Luck: number,
    Stealth: number,
}

local SkillLevels:SkillLevels = {
	Strength = 0,
	Wisdom = 0,
	Stamina = 0,
	Luck = 0,
	Stealth = 0
} 

local Template = {
	SkillTreePoints = 0, 
	SkillPoints = 0, 
	Level = 1,
	Xp = 0, 
	Skills = SkillLevels
}

export type PlayerData = typeof(Template)

return Template
