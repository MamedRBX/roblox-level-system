--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Module Table
local RemoteEvent = {}

--// Folders 
local RemotesFolder = ReplicatedStorage.Shared.Remotes
local LevelRemotesFolder = Instance.new("Folder", RemotesFolder)
LevelRemotesFolder.Name  = "LevelRemotesFolder"

--// Global Remotes/Functions
local GetAllData = Instance.new("RemoteFunction", RemotesFolder)
GetAllData.Name = "GetAllData"

--// Remotes [LevelSystem]
local XPChanged = Instance.new("RemoteEvent", LevelRemotesFolder)
XPChanged.Name = "XpChange"

local UpdateUi = Instance.new("RemoteEvent", LevelRemotesFolder)
UpdateUi.Name = "UpdateUi"

local SpendMasterySP = Instance.new("RemoteEvent", LevelRemotesFolder)
SpendMasterySP.Name = "SpendMasterySP"

local SpendSkillTreeSP = Instance.new("RemoteEvent", LevelRemotesFolder)
SpendSkillTreeSP.Name = "SpendSkillTreeSP"

local ClearAllStats = Instance.new("RemoteEvent", LevelRemotesFolder)
ClearAllStats.Name = "ClearAllStats"

return RemoteEvent
