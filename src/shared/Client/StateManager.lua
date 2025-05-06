
--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules 
local Template = require(ReplicatedStorage.Shared.PlayerData.template)
local Fusion = require(ReplicatedStorage._Packages.Fusion)

--//Remotes 
local UpdateUiRemote  = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder"):WaitForChild("UpdateUi") :: RemoteEvent

local isDataLoaded = false

local PlayerData: Template.PlayerData

--// Fusion Variables 
local Value = Fusion.Value

--//Functions
local function LoadData()
	if isDataLoaded then return end 
	local GetAllData = ReplicatedStorage.Shared.Remotes:WaitForChild("GetAllData") :: RemoteFunction
	while not PlayerData do
		PlayerData = GetAllData:InvokeServer()
		task.wait(1)

	end
	isDataLoaded = true	
end


--// load all the data
LoadData()


local StateManager = {}

--// Loading Fusion Values
function StateManager.InitReactiveValues()
	StateManager.Level = Value(PlayerData.Level)
	StateManager.Xp = Value(PlayerData.Xp)
	--put all the changable values of the player right here
end

function StateManager.GetData(): Template.PlayerData
	while not isDataLoaded do
		task.wait(0.5)
		print()
	end
	return PlayerData
end


--// Recevie Remotes
UpdateUiRemote.OnClientEvent:Connect(function(key:string , payload: {})
	if not key then return warn("[StateManager]:Missing key") end
	if not payload then return warn("[StateManager]: Missing payload") end
	if key == "Update" then
        for stat, value in pairs(payload) do
            if StateManager[stat] then
                StateManager[stat]:set(value)
            end
        end
    end
end)

return StateManager
