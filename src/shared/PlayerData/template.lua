export type SkillLevels = {
	Strength: number,
	Wisdom: number,
	Stamina: number,
	Luck: number,
}

export type SkillTreeEntry = {
	Level: number,
}

export type SkillTree = {
	[string]: SkillTreeEntry
}

local SkillLevels: SkillLevels = {
	Strength = 0,
	Wisdom = 0,
	Stamina = 0,
	Luck = 0,
}

local Template = {
	SkillTreePoints = 0, 
	SkillPoints = 0,    
	Level = 1,
	Xp = 0,
	Skills = SkillLevels,
	SkillTreeSkills = {} :: SkillTree,
}

export type PlayerData = typeof(Template)

return Template
