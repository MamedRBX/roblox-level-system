--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPack = game:GetService("StarterPack")

--// Moduels
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local StateManager = require(ReplicatedStorage.Shared.Client.StateManager)
local SkillData = require(ReplicatedStorage.Shared.Config.SkillTreeData)

--// Remotes 
local LevelRemotesFolder = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder") :: Folder

local SpendSkillTreeSP = LevelRemotesFolder:WaitForChild("SpendSkillTreeSP") :: RemoteEvent

--// Fusion variables
local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

--// Base variables
local LockedHiddenIcon = "rbxassetid://85236772489895"
local QuestionMarkIcon = "rbxassetid://92618739934773"


local FusionSkillTree = {} --Start of the Module

--// Functions
local function Unlock_LevelSkill(Skill: {})
	local hasRequirements = SkillData.GotRequirements(StateManager.SkillTreeSkills, Skill)
	if not hasRequirements then
		return warn("[FusionSkillTree]: Does not fulfill requirements or they're nil")
	end
 
	if StateManager.SkillTreePoints:get() < Skill.Cost then
		return warn("[FusionSkillTree]: Not enough points")
	end

	local currentLevel = StateManager.SkillTreeSkills[Skill.Name]
    if currentLevel and currentLevel:get() then currentLevel = currentLevel:get() else currentLevel = 0 end
    

	if currentLevel >= Skill.Max then
		return warn("[FusionSkillTree]: This skill is already maxed out")
	end


	-- All checks passed
	SpendSkillTreeSP:FireServer(Skill.Name)
end


function FusionSkillTree.BuildSkill(Skill: {}, parent: string)
    FusionSkillTree.UnlockedSkill(Skill, parent)
end

function FusionSkillTree.UnlockedSkill(Skill: {}, parent: string) --Background image of the skill when its in the unlocked stage
 
    return New "ImageButton" { --Thats the whole Base of the Skill Note
        Name = Skill.Name,
        Parent = parent,
        Size = UDim2.fromScale(1,1),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.fromScale(0.5,0.5),
        Image = LockedHiddenIcon,
        BackgroundTransparency = 1,
        ScaleType = "Fit",
        Visible = Computed(function()
            if not StateManager.SkillTreeSkills[Skill.Name] then return true end 
            if StateManager.SkillTreeSkills[Skill.Name]:get() >= 0 then
                return false
            else
                return true
            end
        end),

        [Children] = {
            New "ImageLabel" {
                Name = "QuestionMarkIcon", --The Icon when the Skill is Unlocked and hidden because requirements are not furfilled
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5,0.5),
                Size = UDim2.fromScale(0.4,0.4),
                Image = QuestionMarkIcon,
                BackgroundTransparency = 1,
                Visible = Computed(function()
                    local GotRequirements = SkillData.GotRequirements(StateManager.SkillTreeSkills ,Skill)
                    if GotRequirements then return false else return true end
                end)
                
            },
            New "ImageLabel" {
                Name = "SkillIconLocked", --The Icon when the Skill is Locked
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5,0.45),
                Size = UDim2.fromScale(0.5,0.5),
                Image = Skill.LockedIcon,
                BackgroundTransparency = 1,
                Visible = Computed(function()
                    local GotRequirements = SkillData.GotRequirements(StateManager.SkillTreeSkills ,Skill)
                    if GotRequirements and StateManager.SkillTreeSkills[Skill.Name]:get() == 0 then return true else return false end
                end)    
            },
            New "ImageLabel" {      --The Icon when the Skill is Unlocked
                Name = "SkillIconUnLocked",
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1,1),
                Image = Skill.UnlockedIcon,
                BackgroundTransparency = 1,
                Visible = Computed(function()
                    print(StateManager.SkillTreeSkills)
                    if StateManager.SkillTreeSkills[Skill.Name]:get() >= 1 then
                        return true
                    else
                        return false
                    end
                end)
            },
            New "TextLabel" {
                Name = "LevelCounter"..Skill.Name, --the level Counter when a skill is unlocked
                BackgroundTransparency = 1,
                TextScaled = true,
                Position = UDim2.fromScale(0.5,0.65),
                Size = UDim2.fromScale(0.3,0.3),
                AnchorPoint = Vector2.new(0.5,0.5),
                TextColor3 = Color3.fromRGB(255,255,255),
                Text = Computed(function()
                    local state = StateManager.SkillTreeSkills[Skill.Name]
                    return tostring((state and state:get()) or 0)
                end),
                Visible = Computed(function()
                local state = StateManager.SkillTreeSkills[Skill.Name]
                return (state and state:get() or 0) > 0
            end),
            },
        },
        [OnEvent "MouseButton1Up"] = function()
			Unlock_LevelSkill(Skill)
		end,
        [OnEvent "InputBegan"] = function()
            
        end
    }
end


return FusionSkillTree