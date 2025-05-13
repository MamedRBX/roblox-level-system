-- SkillData.lua

export type SkillEntry = {
	Name: string,
	SkillType: "Strength" | "Wisdom" | "Stamina" | "Luck" | "Origin" , 
	Cost: number,
	Req: { string }?, -- optional list of required skill IDs
	Max: number,
}

export type SkillDataTable = {
	[string]: SkillEntry
}

local SkillData: SkillDataTable = {

	--// Origin Skill
	Gold1 = {
		Name = "Gold1",
		SkillType = "Origin", 
		Cost = 1,
		Max = 5,
	},

	--// Strength
	Strength1 = {
		Name = "Strength1",
		SkillType = "Strength",
		Cost = 1,
		Max = 1,
	},


	Strength2 = {
		Name = "Strength2",
		SkillType = "Strength",
		Cost = 1,
		Req = { "Strength1" },
		Max = 3,
	},

	Strength3 = {
		Name = "Strength2",
		SkillType = "Strength",
		Cost = 1,
		Req = { "Strength1" },
		Max = 3,
	},

	--// Stamina
	Stamina1 = {
		Name = "Stamina1",
		SkillType = "Stamina",
		Cost = 1,
		Max = 1,
	},
	Stamina2 = {
		Name = "Stamina2",
		SkillType = "Stamina",
		Cost = 1,
		Max = 1,
	},
	Stamina3 = {
		Name = "Stamina2",
		SkillType = "Stamina",
		Cost = 1,
		Max = 1,
	},

	--// Wisdom
	Wisdom1 = {
		Name = "Wisdom1",
		SkillType = "Wisdom",
		Cost = 1,
		Max = 1,
	},
	Wisdom2 = {
		Name = "Wisdom1",
		SkillType = "Wisdom",
		Req = {"Wisdom1"},
		Cost = 1,
		Max = 1,
	},

	Wisdom3 = {
		Name = "Wisdom1",
		SkillType = "Wisdom",
		Cost = 1,
		Max = 1,
	},

	--// Luck
	Luck1 = {
		Name = "Luck1",
		SkillType = "Luck",
		Cost = 1,
		Max = 1,
	},
	Luck2 = {
		Name = "Luck1",
		SkillType = "Luck",
		Cost = 1,
		Max = 1,
	},
	Luck3 = {
		Name = "Luck1",
		SkillType = "Luck",
		Cost = 1,
		Max = 1,
	}
}

return SkillData