--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)
local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)
local SkillTreeData = require(ReplicatedStorage.Shared.Config.SkillTreeData)

--//Remotes
local RemoteFolder = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder") :: Folder
local UpdateUiRemote = RemoteFolder:WaitForChild("UpdateUi") :: RemoteEvent

local SkillTreeSP = {} --Start of the Module

--// Functions
function SkillTreeSP.OnLevelUp(player: Player)
    local profile = ProfileManager.profiles[player]
    if not profile then return warn("[SkillTreeSP]: Missing Profile") end

    if profile.Data.Level % 2 == 0 then --we give the player a SkillTree Point for every second Levelup
        --the Level is even so its the second Level 
        local SkillTreeSP = profile.Data.Level / 2
        profile.Data.SkillTreePoints = SkillTreeSP --recalculating the points everytime , simply adding could cause exploiting
    else
        --the Level is not even so no SkillTree Point
    end
end


function SkillTreeSP.OnSpendSP(player: Player, SkillName: string)
	local profile = ProfileManager.profiles[player]
	if not profile then return warn("[SkillTree]: Missing Profile") end

	local Skill = SkillTreeData[SkillName]
	if not Skill then return warn("[SkillTreeSP]: Missing Skill") end

	local currentLevel = profile.Data.SkillTreeSkills[Skill.Name] or 0

	-- Check requirements
	if not SkillTreeData.GotRequirements(profile.Data.SkillTreeSkills, Skill) then
		return warn("[SkillTreeSP]: Does not fulfill the Requirements")
	end

	-- Check SP and max level
	if profile.Data.SkillTreePoints >= Skill.Cost then
		if currentLevel < Skill.Max then
			-- Apply upgrade
			profile.Data.SkillTreeSkills[Skill.Name] = currentLevel + 1
			profile.Data.SkillTreePoints -= Skill.Cost
			
			--Update on the client via the StateManager
			UpdateUiRemote:FireClient(player, "Update", {
				SkillTreePoints = profile.Data.SkillTreePoints,
				SkillTreeSkills = profile.Data.SkillTreeSkills,
			})
		end
	else
		return warn("[SkillTreeSP]: Not enough SkillPoints")
	end
end



--// Receving Signals
Signals.LevelUp:Connect(function(player:Player)
    SkillTreeSP.OnLevelUp(player)
end)

Signals.SpendSkillTreeSP:Connect(function(player:Player, SkillName:string)
    SkillTreeSP.OnSpendSP(player, SkillName)
end)

--// Init the Module
function SkillTreeSP.Init()
    
end


return SkillTreeSP