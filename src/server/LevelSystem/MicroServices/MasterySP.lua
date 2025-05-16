--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)
local Singals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)

--// Folders
local LevelSystemFolder = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder") :: Folder


--//Remotes
local UpdateUi = LevelSystemFolder:WaitForChild("UpdateUi") :: RemoteEvent


local MasterySP = {} --Start of the Module

--// Functions 
function MasterySP.OnLevelUp(player)
    local profile = ProfileManager.profiles[player]
    if not profile then return warn("[MasterySP]: Missing Profile") end

    profile.Data.SkillPoints += 1 
	
    UpdateUi:FireClient(player, "Update" ,  {
        SkillPoints = profile.Data.SkillPoints
    })

end

function MasterySP.OnSPSpend(player: Player, amount: number, SkillName: string) --function when the player spends Mastery Skill Points
	local profile = ProfileManager.profiles[player]
	if not profile then return warn("[MasterySP]: Missing Profile") end

	local current = profile.Data.Skills[SkillName]
	if not current then return warn("[MasterySP]: Skill Missing " .. SkillName) end

	local skillPoints = profile.Data.SkillPoints

	for i = 1, amount do
		if skillPoints <= 0 then break end
		if not LevelSystemConfig.SkillCap(current) then break end

		current += 1
		skillPoints -= 1
	end

	profile.Data.Skills[SkillName] = current
	profile.Data.SkillPoints = skillPoints

	UpdateUi:FireClient(player, "Update", {
		SkillPoints = skillPoints,
		Skills = profile.Data.Skills
	})
end

--// Receving Signals
Singals.LevelUp:Connect(function(player:Player)
    MasterySP.OnLevelUp(player)
end)

Singals.SpendMasterySP:Connect(function(player:Player, amount:number, SkillName:string)
    MasterySP.OnSPSpend(player, amount, SkillName)
end)



--// Init Module
function  MasterySP.Init()
    
end

return MasterySP