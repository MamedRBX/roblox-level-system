--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules 
local Template = require(ReplicatedStorage.Shared.PlayerData.template)

local isDataLoaded = false

local PlayerData: Template.PlayerData

local function LoadData()
	if isDataLoaded then return end 

	while not PlayerData do
		PlayerData = ReplicatedStorage.Events.GetAllData:InvokeServer()
		task.wait(1)

	end
	isDataLoaded = true	
end

LoadData()

local StateManager = {}


function StateManager.GetData(): Template.PlayerData
	while not isDataLoaded do
		task.wait(0.5)
		print()
	end
	return PlayerData
end

return StateManager
