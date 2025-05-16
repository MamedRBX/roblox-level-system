

export type SkillEntry = {
	Name: string,
	SkillType: "Strength" | "Wisdom" | "Stamina" | "Luck" | "Origin" , 
	Cost: number,
	Req: { string }?, -- optional list of required skill IDs
	Max: number,
	UnlockedIcon: string,
	LockedIcon: string,
}

export type SkillDataTable = {
	[string]: SkillEntry
}

local SkillData: SkillDataTable = {

	--// Origin Skill
	Gold1 = {
		Name = "Gold1",
		SkillType = "Gold", 
		Cost = 1,
		Max = 5,
		UnlockedIcon = "rbxassetid://80611268709617",
		LockedIcon = "rbxassetid://104325355169552",
	},

	--// Strength
	Strength1 = {
		Name = "Strength1",
		SkillType = "Strength",
		Cost = 1,
		Max = 1,
		Req = {"Gold1"},
		UnlockedIcon = "",
		LockedIcon = "",
	},


	Strength2 = {
		Name = "Strength2",
		SkillType = "Strength",
		Cost = 1,
		Req = { "Strength1" },
		Max = 3,
	},

	Strength3 = {
		Name = "Strength3",
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
		Req = { "Gold1" }
	},
	Stamina2 = {
		Name = "Stamina2",
		SkillType = "Stamina",
		Cost = 1,
		Max = 1,
		Req = { "Stamina1" },
	},
	Stamina3 = {
		Name = "Stamina3",
		SkillType = "Stamina",
		Cost = 1,
		Max = 1,
		Req = { "Stamina1" },
	},

	--// Wisdom
	Wisdom1 = {
		Name = "Wisdom1",
		SkillType = "Wisdom",
		Cost = 1,
		Max = 1,
		Req = {"Gold1"},

	},
	Wisdom2 = {
		Name = "Wisdom2",
		SkillType = "Wisdom",
		Req = {"Wisdom1"},
		Cost = 1,
		Max = 1,
		
	}, 

	Wisdom3 = {
		Name = "Wisdom3",
		SkillType = "Wisdom",
		Req = {"Wisdom1"},
		Cost = 1,
		Max = 1,
	},

	--// Luck
	Luck1 = {
		Name = "Luck1",
		SkillType = "Luck",
		Cost = 1,
		Max = 1,
		Req = {"Gold1"},
	},
	Luck2 = {
		Name = "Luck2",
		SkillType = "Luck",
		Cost = 1,
		Max = 1,
		Req = {"Luck1"},

	},
	Luck3 = {
		Name = "Luck3",
		SkillType = "Luck",
		Cost = 1,
		Max = 1,
		Req = {"Luck1"},

	}
} 


function SkillData.GotRequirements(Data: {}, Skill: {})
    local Req = Skill["Req"]
    if not Req then return true end

    for _, info in Req do
        if not Data[info] then return false end
        if Data[info]:get() < 1 then return false end
    end

    return true
end

return SkillData