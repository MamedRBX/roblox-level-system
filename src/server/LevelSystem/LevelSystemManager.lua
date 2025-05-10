--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local QueueSystem = require(ServerScriptService.Server.LevelSystem.QueueSystem)
local Validation = require(ServerScriptService.Server.LevelSystem.Validation)

--// Folder 
local LevelRemotes = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder") :: Folder

--// Remotes
local XpChange = LevelRemotes:WaitForChild("XpChange") :: RemoteEvent
local SpendMasterySP = LevelRemotes:WaitForChild("SpendMasterySP") :: RemoteEvent



local LevelManager = {} --Start of the Module



--// Receving Events 
XpChange.OnServerEvent:Connect(function(player, amount)
	--make possible validation check
	local valid = Validation.AdjustXp(player)
	if not valid then return end 
	QueueSystem:Add("XpChange", player , amount)
end)

SpendMasterySP.OnServerEvent:Connect(function(player:Player , amount:number, SkillName:string)
	--validation check
	local valid = Validation.SkillPointCheck(player)
	if not valid then return end
	QueueSystem:Add("SpendMasterySP", player, amount, SkillName)
end)




--// Init the Module
function LevelManager:Init()
end

return LevelManager