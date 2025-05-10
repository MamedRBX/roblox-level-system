--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")


--// Modules
local FormatNumber = require(ReplicatedStorage.Shared.Libs.FormatNumberShort)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local StateManager = require(ReplicatedStorage.Shared.Client.StateManager)

--// Fusion variables
local Spring = Fusion.Spring
local New = Fusion.New
local Computed = Fusion.Computed

local FusionLevelUi = {} --Start of the Module

--// Functions
function FusionLevelUi.CreateSkillCounterUi(skills: {}) --goes through a list of parents ,(the parent of the skills) and creates the Labels and Progressbars
	for _, Skill in skills do
		FusionLevelUi.SkillCounterUi(Skill)
		FusionLevelUi.MileStoneCounterUi(Skill)
		FusionLevelUi.SkillProgressBarUi(Skill)
	end
end


function FusionLevelUi.SkillCounterUi(parent: Frame) --creates a TextLabel for displaying the amount of Skillpoints on a Skill
	local skillName = parent.Name
	local mastery = StateManager.Masteries[skillName]
	local smoothVal = Spring(mastery, 30, 1)

	return New "TextLabel" {
		Name = skillName .. "LevelCounter",
		Parent = parent,
		BackgroundTransparency = 1,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.62, 0.424),
		Size = UDim2.fromScale(0.118, 0.336),
		TextColor3 = Color3.fromRGB(255, 255, 255),

		Text = Computed(function()
			local baseValue = smoothVal:get()
			return math.floor(baseValue) .. " / " .. LevelSystemConfig.MileStoneCalc(math.floor(baseValue))
		end)
	}
end


function FusionLevelUi.SkillProgressBarUi(parent: Frame)
	return New "Frame" {
		Name = parent.Name .. "ProgressBar",
		Parent = parent,
		AnchorPoint = Vector2.new(0,0),
		Position = UDim2.fromScale(0,0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(0,255,0),
		Size = Spring(Computed(function()
        local currentLevel = StateManager.Masteries[parent.Name]:get()
        local maxLevel = LevelSystemConfig.MileStoneCalc(StateManager.Masteries[parent.Name]:get())
        local fillRatio = math.clamp(currentLevel / maxLevel, 0, 1)
        return UDim2.fromScale(fillRatio, 1)
    end), 15) 
	}
end

function FusionLevelUi.MileStoneCounterUi(parent:Frame)
	return New "TextLabel" {
		Name = parent.Name .. "MileStone",
		Parent = parent,
		TextScaled = true,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.868,0.701),
		Size = UDim2.fromScale(0.27, 0.494),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		Text = Computed(function()
		
			return "MILESTONE "..LevelSystemConfig.MileStoneNumber(StateManager.Masteries[parent.Name]:get())
		end)
	}
end

return FusionLevelUi