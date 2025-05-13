--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

--// Modules
local FormatNumber = require(ReplicatedStorage.Shared.Libs.FormatNumberShort)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local StateManager = require(ReplicatedStorage.Shared.Client.StateManager)

--// Folder
local LevelRemotesFolder = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder") :: Folder
local SoundFolder = SoundService:WaitForChild("Sounds"):WaitForChild("LevelSystemSounds") :: Folder

--//Sounds
local SkillPointSpend = SoundFolder.SkillPointSpend :: Sound
local ClickSound = SoundFolder.ClickSounds :: Sound

--// Remotes
local SpendMasterySP = LevelRemotesFolder:WaitForChild("SpendMasterySP") :: RemoteEvent

--// Fusion variables
local Spring = Fusion.Spring
local New = Fusion.New
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

local FusionLevelUi = {} --Start of the Module

--// Functions
function FusionLevelUi.CreateSkillCounterUi(skills: {}) --goes through a list of parents ,(the parent of the skills) and creates the Labels and Progressbars
	for _, Skill in skills do
		FusionLevelUi.SkillCounterUi(Skill)
		FusionLevelUi.MileStoneCounterUi(Skill)
		FusionLevelUi.SkillProgressBarUi(Skill)
		FusionLevelUi.SkillButton(Skill)
	end
end


function FusionLevelUi.SkillCounterUi(parent: Frame) --creates a TextLabel for displaying the amount of Skillpoints on a Skill
	local skillName = parent.Name

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
			local mastery = StateManager.Masteries[skillName]
			if not mastery then return "??" end
			return math.floor(mastery:get()) .. " / " .. LevelSystemConfig.GetMileStoneEnd(math.floor(mastery:get()))
		end)
	}
end


function FusionLevelUi.SkillProgressBarUi(parent: Frame) --ProgressBar for Skills
	
	return New "Frame" {
		Name = parent.Name .. "ProgressBar",
		Parent = parent.BarBackground,
		AnchorPoint = Vector2.new(0,0),
		Position = UDim2.fromScale(0,0),
		[Children]= {
			New "UICorner" {
				CornerRadius = UDim.new(0, 8)
				
			}
		},
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(0,255,0),
		Size = Spring(Computed(function()
			local lvl:number = StateManager.Masteries[parent.Name]:get()
			local floor = LevelSystemConfig.GetMileStoneStart(lvl)
			local ceil = LevelSystemConfig.GetMileStoneEnd(lvl)   
			local progress = (lvl - floor) / (ceil - floor)

			return UDim2.fromScale(math.clamp(progress, 0, 1), 1)
		end), 15) 
	}
	

end

function FusionLevelUi.MileStoneCounterUi(parent:Frame) --Milestone for Skills
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

function FusionLevelUi.SkillButton(parent: Frame)--SkillButtons for Skills
	return New "ImageButton" {
		Name = parent.Name.."SkillButton",
		Parent = parent,
		Image = "rbxassetid://118936424993971",
		AnchorPoint = Vector2.new(0,0),
		Position = UDim2.fromScale(0.087, 0.223),
		Size = UDim2.fromScale(0.083,0.512),
		BackgroundTransparency = 1,

		Visible  = Computed(function()
			local display = false
			if StateManager.SkillPoints:get() <= 0 then
				display = false
			else
				if StateManager.Masteries[parent.Name]:get() < LevelSystemConfig.ReturnSkillCap() then
					display = true
				else
					display = false
				end
			end
			return display
			
		end),
		[OnEvent "Activated"] = function()
		ClickSound:Play()
		if StateManager.SkillPoints:get() >= 1 then --quick validation
			print(StateManager.SelectedSpendAmount:get())
			if StateManager.SelectedSpendAmount:get() % 1 == 0 and StateManager.SelectedSpendAmount:get() ~= 0 then
				SkillPointSpend:Play()
				SpendMasterySP:FireServer(StateManager.SelectedSpendAmount:get(), parent.Name) --point spend
			else
				print("number is not even")
				SkillPointSpend:Play()
				SpendMasterySP:FireServer(1 , parent.Name)
			end
			
		else
			--possible popup for "Not enough skillpoints"
			print("not enouth SkillPoints")
		end
	end
	}
end


function FusionLevelUi.CreatingSkillAmountButtons(parent:Frame, amount: number)

	return New "TextButton" {

		Name = parent.Name,
		Parent = parent,
		Text = "x"..amount,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 0,
		TextColor3 = Color3.fromRGB(74, 55, 74),
		Font = Enum.Font.GothamBold,
		TextScaled = true,
		BackgroundColor3 = Color3.fromRGB(150, 112, 150),
		Visible = true,
		[Children] = {
			New "UIStroke" {
				Thickness = 2, 
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 0, 
				Color = Computed(function()
					if StateManager.SelectedSpendAmount:get() == amount then
						return Color3.fromRGB(227, 227, 0)
					else
						return Color3.fromRGB(176, 132, 176)
					end 
				end)
				
			},

			New "UICorner" {
				CornerRadius = UDim.new(0, 3),
			}
		},
		
		[OnEvent "Activated"] = function()
			ClickSound:Play()
			StateManager.SelectedSpendAmount:set(amount)
			StateManager.CustomSpendText:set(tostring(amount))
		end
	}
end
return FusionLevelUi