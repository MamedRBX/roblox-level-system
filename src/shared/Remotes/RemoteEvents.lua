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

return RemoteEvent
